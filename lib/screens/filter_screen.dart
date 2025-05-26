import 'dart:convert';
import 'package:app/services/serial_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  void openQRScanner() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => QRScanView(
          onAuthenticated: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const SerialEditScreen(
                  initialSerial: '12345678',
                  model: 'ESP32',
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> configureMicrocontroller() async {
    if (kDebugMode) {
      print('🟦 Sending CONFIG123...');
    }
    try {
      final response =
          await SerialService.sendToMicrocontroller('{"action":"CONFIG123"}');

      if (kDebugMode) {
        print('📦 CONFIG response: $response');
      }

      final decoded = jsonDecode(response.trim());
      final message = decoded['message'] ?? 'Unknown response';

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ $message')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Configure failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Microcontroller Config (USB)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: openQRScanner,
              child: const Text('Scan QR Code'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: configureMicrocontroller,
              child: const Text('Configure Microcontroller'),
            ),
          ],
        ),
      ),
    );
  }
}

class QRScanView extends StatelessWidget {
  final VoidCallback onAuthenticated;

  const QRScanView({required this.onAuthenticated, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Scanner')),
      body: MobileScanner(
        onDetect: (capture) async {
          final barcode = capture.barcodes.first;
          final code = barcode.rawValue;

          if (code == null) return;

          try {
            final cleaned = code.trim();
            final decoded = jsonDecode(cleaned);
            final username = decoded['username'] as String?;
            final password = decoded['password'] as String?;

            if (username == null || password == null) throw Exception();

            final authMessage = jsonEncode({
              'action': "auth",
              'username': username,
              'password': password,
            });

            final response =
                await SerialService.sendToMicrocontroller(authMessage);

            if (kDebugMode) {
              print('📨 Auth response: $response');
            }

            try {
              final jsonResponse = jsonDecode(response.trim());
              if (jsonResponse['status'] == 'OK') {
                Navigator.pop(context);
                onAuthenticated();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('❌ Invalid credentials')),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Unexpected response from device')),
              );
            }
          } catch (e) {
            if (kDebugMode) {
              print('❌ QR decode error: $e');
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid QR code format')),
            );
          }
        },
      ),
    );
  }
}

class SerialEditScreen extends StatefulWidget {
  final String initialSerial;
  final String model;

  const SerialEditScreen({
    required this.initialSerial,
    required this.model,
    super.key,
  });

  @override
  State<SerialEditScreen> createState() => _SerialEditScreenState();
}

class _SerialEditScreenState extends State<SerialEditScreen> {
  late TextEditingController _serialController;
  String result = '';

  @override
  void initState() {
    super.initState();
    _serialController = TextEditingController(text: widget.initialSerial);
  }

  Future<void> submitSerial() async {
    final serial = _serialController.text.trim();

    if (serial.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter serial number')),
      );
      return;
    }

    final message = jsonEncode({"serial": serial});

    final response = await SerialService.sendToMicrocontroller(message);

    if (!context.mounted) return;
    setState(() {
      result = response;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Device response: $response')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Serial Number')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Model: ${widget.model}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _serialController,
              decoration: const InputDecoration(
                labelText: 'Serial Number',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => submitSerial(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: submitSerial,
              child: const Text('Save'),
            ),
            if (result.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Result: $result',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

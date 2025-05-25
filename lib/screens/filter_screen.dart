import 'package:app/services/wifi_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? scannedSerial;
  String? scannedModel;

  void openQRScanner() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => QRScanView(
          onScanned: (String data) {
            final parts = data.split(';');
            if (parts.length == 2) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => SerialEditScreen(
                    initialSerial: parts[0],
                    model: parts[1],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void displaySerialNumber() async {
    showDialog(
      context: context,
      builder: (context) => FutureBuilder<String>(
        future: WifiService.readSerial(),
        builder: (context, snapshot) {
          if (kDebugMode) {
            print('ESP read result: ${snapshot.data}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AlertDialog(
              title: Text('Checking...'),
              content: SizedBox(
                height: 50,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: const Text('Connection Error'),
              content: const Text('Failed to connect to microcontroller.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          } else {
            return AlertDialog(
              title: const Text('Serial Number'),
              content: Text(snapshot.data ?? 'Unknown'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> configureMicrocontroller() async {
    final response =
        await WifiService.writeSerial('admin', '1234', 'CONFIG123');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configured: $response')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Microcontroller Config')),
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
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: displaySerialNumber,
              child: const Text('Display the Serial Number'),
            ),
          ],
        ),
      ),
    );
  }
}

class QRScanView extends StatelessWidget {
  final void Function(String data) onScanned;

  const QRScanView({required this.onScanned, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Scanner')),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          final code = barcode.rawValue;
          if (code != null) {
            Navigator.pop(context);
            onScanned(code);
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
    final response =
        await WifiService.writeSerial('admin', '1234', _serialController.text);
    setState(() {
      result = response;
    });
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
              Text('Result: $result'),
            ],
          ],
        ),
      ),
    );
  }
}

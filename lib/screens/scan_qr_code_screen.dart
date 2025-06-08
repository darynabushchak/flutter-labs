import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../services/usb_service.dart';

class ScanQrCodeScreen extends StatefulWidget {
  const ScanQrCodeScreen({super.key});

  @override
  State<ScanQrCodeScreen> createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  bool _scanned = false;
  String statusMessage = '';

  void _handleBarcode(BarcodeCapture barcodeCapture) {
    if (_scanned) return;
    _scanned = true;

    final barcodes = barcodeCapture.barcodes;
    if (barcodes.isNotEmpty) {
      final rawValue = barcodes.first.rawValue;
      if (rawValue != null) {
        try {
          final data = json.decode(rawValue);
          final username = data['username']?.toString();
          final password = data['password']?.toString();

          if (username != null && password != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              _showSerialNumberDialog(context, username, password);
            });
            return;
          }

          setState(() {
            statusMessage = 'QR code does not contain valid credentials.';
          });
        } catch (e) {
          setState(() {
            statusMessage = 'Failed to parse QR code.';
          });
        }
      }
    } else {
      setState(() {
        statusMessage = 'No barcode detected!';
      });
    }
  }

  void _showSerialNumberDialog(
      BuildContext context, String username, String password) {
    final serialController = TextEditingController();
    final usbService = UsbService();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Enter New Serial Number'),
        content: TextField(
          controller: serialController,
          decoration: const InputDecoration(
            labelText: 'Serial Number',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              FocusScope.of(dialogContext).unfocus();
              final serialNumber = serialController.text.trim();
              if (serialNumber.isEmpty) {
                Navigator.pop(dialogContext);
                _showMessage(
                    dialogContext, 'Serial number cannot be empty.');
                return;
              }

              final connected = await usbService.connect();
              if (!connected) {
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                  _showMessage(
                      dialogContext, 'Failed to connect to microcontroller.');
                }
                return;
              }

              await usbService.sendData({
                'username': username,
                'password': password,
                'serial_number': serialNumber,
              });

              final response = await usbService.readData();
              await usbService.close();

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
                final message = _extractMessageFromResponse(response);
                _showMessage(
                    dialogContext, message ?? 'Serial number updated.');
              }
            },
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  String? _extractMessageFromResponse(String? response) {
    if (response == null || response.isEmpty) return null;
    try {
      final Map<String, dynamic> decoded =
      jsonDecode(response) as Map<String, dynamic>;
      return decoded['message']?.toString();
    } catch (_) {
      return response;
    }
  }

  void _showMessage(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Info'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
          ),
          if (statusMessage.isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.all(16),
                child: Text(
                  statusMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

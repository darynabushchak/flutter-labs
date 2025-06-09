import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrService {
  Future<Map<String, dynamic>?> scanQRCode() async {
    final MobileScannerController controller = MobileScannerController();
    final qrCapture = await controller.barcodes.first;
    if (qrCapture.barcodes.isNotEmpty) {
      final rawValue = qrCapture.barcodes.first.rawValue;
      if (rawValue != null) {
        try {
          final data = json.decode(rawValue);
          if (data is Map<String, dynamic>) {
            return data;
          }
        } catch (e) {
          if (kDebugMode) {
            print('QR Decode Error: $e');
          }
        }
      }
    }
    return null;
  }
}

import 'dart:convert';

import 'package:app/utils/transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:usb_serial/usb_serial.dart';

class SerialService {
  static Future<String> sendToMicrocontroller(String message) async {
    if (kDebugMode) {
      print('🔌 Looking for USB devices...');
    }

    final List<UsbDevice> devices = await UsbSerial.listDevices();

    if (devices.isEmpty) {
      if (kDebugMode) {
        print('❌ No USB device found.');
      }
      return 'No USB device found';
    }

    final UsbDevice device = devices.first;
    if (kDebugMode) {
      print('🟢 Found USB device: ${device.productName}');
    }

    final UsbPort? port = await UsbSerial.createFromDeviceId(device.deviceId);
    if (port == null) {
      if (kDebugMode) {
        print('❌ Failed to create USB port.');
      }
      return 'Failed to create port';
    }

    try {
      final bool opened = await port.open();
      if (!opened) {
        if (kDebugMode) {
          print('❌ Failed to open USB port.');
        }
        return 'Failed to open port';
      }

      await port.setDTR(true);
      await port.setRTS(true);
      await port.setPortParameters(9600, 8, 1, UsbPort.PARITY_NONE);

      final String fullMessage = '$message\n';
      final dataToSend = utf8.encode(fullMessage);

      if (kDebugMode) {
        print('➡️ Sending to microcontroller: $fullMessage');
      }

      await port.write(Uint8List.fromList(dataToSend));

      if (kDebugMode) {
        print('✅ Message sent (${dataToSend.length} bytes)');
      }

      final transaction = Transaction.stringTerminated(
        port.inputStream!,
        Uint8List.fromList([10]),
      );

      final String response = await transaction.stream.first
          .timeout(const Duration(seconds: 3), onTimeout: () => 'Timed out');

      if (kDebugMode) {
        print('📥 Response received: $response');
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Communication error: $e');
      }
      return 'Error: $e';
    } finally {
      await port.close();
      if (kDebugMode) {
        print('🔒 USB port closed');
      }
    }
  }
}

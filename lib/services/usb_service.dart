import 'dart:convert';
import 'dart:typed_data' as typed;

import 'package:flutter/foundation.dart';
import 'package:usb_serial/usb_serial.dart';

class UsbService {
  UsbPort? _port;

  Future<bool> connect() async {
    final List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      debugPrint('No USB devices found');
      return false;
    }

    _port = await devices[0].create();
    if (await _port?.open() ?? false) {
      await _port!.setDTR(true);
      await _port!.setRTS(true);
      await _port!.setPortParameters(
        9600,
        UsbPort.DATABITS_8,
        UsbPort.STOPBITS_1,
        UsbPort.PARITY_NONE,
      );
      debugPrint('Connected to USB device');
      return true;
    }

    return false;
  }

  Future<void> sendJson(Map<String, dynamic> data) async {
    await sendData(data);
  }

  Future<void> sendData(Map<String, dynamic> data) async {
    if (_port == null) {
      debugPrint('Port not open');
      return;
    }

    String jsonString = json.encode(data);
    await _port!.write(typed.Uint8List.fromList(utf8.encode('$jsonString\n')));
    debugPrint('Sent: $jsonString');
  }

  Future<String?> readResponse() async {
    return await readData();
  }

  Future<String?> readData() async {
    if (_port == null) {
      debugPrint('Port not open');
      return null;
    }

    final reader = UsbPortReader(_port!);
    final buffer = StringBuffer();
    bool lineEnded = false;

    try {
      await for (var chunk in reader.stream.timeout(const Duration(seconds: 3),
          onTimeout: (sink) {
        sink.close();
      })) {
        for (var byte in chunk) {
          if (byte >= 32 && byte <= 126) {
            buffer.write(String.fromCharCode(byte));
          }
          if (byte == 10) {
            lineEnded = true;
            break;
          }
        }
        if (lineEnded) {
          break;
        }
      }
    } catch (e) {
      debugPrint('Error reading data: $e');
      return null;
    }

    final response = buffer.toString().trim();
    debugPrint('Received: $response');
    return response.isEmpty ? null : response;
  }

  Future<void> disconnect() async {
    await close();
  }

  Future<void> close() async {
    await _port?.close();
    _port = null;
    debugPrint('Port closed');
  }
}

class UsbPortReader {
  final UsbPort _port;

  UsbPortReader(this._port);

  Stream<List<int>> get stream async* {
    await for (typed.Uint8List data in _port.inputStream!) {
      yield data;
    }
  }
}

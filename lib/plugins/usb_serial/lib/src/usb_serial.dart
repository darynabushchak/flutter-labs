import 'dart:async';

import 'package:app/plugins/usb_serial/lib/src/usb_port.dart';
import 'package:app/plugins/usb_serial/lib/src/usb_device.dart';
import 'package:flutter/services.dart';

class UsbSerial {
  static const MethodChannel _channel = MethodChannel('usb_serial');

  static Future<List<UsbDevice>> listDevices() async {
    final List<dynamic> devices =
        (await _channel.invokeMethod<List<dynamic>>('listDevices')) ?? [];
    return devices
        .map((d) => UsbDevice.fromMap(Map<String, dynamic>.from(d as Map)))
        .toList();
  }

  static Future<UsbPort?> createPort(UsbDevice device) async {
    final bool result = (await _channel
        .invokeMethod('openDevice', {'deviceName': device.deviceName})) as bool;
    if (!result) return null;

    return _UsbSerialPort(device.deviceName);
  }
}

class _UsbSerialPort extends UsbPort {
  final String _deviceName;
  final EventChannel _inputChannel;
  Stream<Uint8List>? _inputStream;

  _UsbSerialPort(this._deviceName)
      : _inputChannel = EventChannel('usb_serial/$_deviceName/input');

  @override
  Stream<Uint8List>? get inputStream {
    _inputStream ??= _inputChannel
        .receiveBroadcastStream()
        .map((event) => Uint8List.fromList(List<int>.from(event as List)))
        .cast<Uint8List>();
    return _inputStream;
  }

  @override
  Future<bool> open() async {
    return true; // Already opened by createPort
  }

  @override
  Future<bool> close() async {
    return true; // Simulated close
  }

  @override
  Future<int> write(Uint8List data) async {
    final int sent = (await UsbSerial._channel.invokeMethod('write', {
      'deviceName': _deviceName,
      'data': data,
    })) as int;
    return sent;
  }

  @override
  Future<void> setDTR(bool value) async {
    await UsbSerial._channel.invokeMethod('setDTR', {
      'deviceName': _deviceName,
      'value': value,
    });
  }

  @override
  Future<void> setRTS(bool value) async {
    await UsbSerial._channel.invokeMethod('setRTS', {
      'deviceName': _deviceName,
      'value': value,
    });
  }

  @override
  Future<void> setPortParameters(
      int baudRate, int dataBits, int stopBits, int parity,) async {
    await UsbSerial._channel.invokeMethod('setPortParameters', {
      'deviceName': _deviceName,
      'baudRate': baudRate,
      'dataBits': dataBits,
      'stopBits': stopBits,
      'parity': parity,
    });
  }
}

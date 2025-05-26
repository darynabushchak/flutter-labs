import 'dart:typed_data';

abstract class UsbPort {
  static const int PARITY_NONE = 0;
  static const int PARITY_ODD = 1;
  static const int PARITY_EVEN = 2;

  Future<bool> open();
  Future<bool> close();
  Stream<Uint8List>? get inputStream;
  Future<int> write(Uint8List data);
  Future<void> setDTR(bool value);
  Future<void> setRTS(bool value);
  Future<void> setPortParameters(int baudRate, int dataBits, int stopBits, int parity);
}

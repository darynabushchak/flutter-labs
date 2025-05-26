import 'dart:async';
import 'dart:typed_data';

class Transaction {
  final Stream<Uint8List> _stream;
  final List<int> _buffer = [];
  final List<int> _terminator;

  Transaction._(this._stream, this._terminator);

  Stream<String> get stream async* {
    await for (final chunk in _stream) {
      _buffer.addAll(chunk);

      int index = _indexOf(_buffer, _terminator);
      while (index != -1) {
        final data = _buffer.sublist(0, index);
        _buffer.removeRange(0, index + _terminator.length);
        yield String.fromCharCodes(data);
        index = _indexOf(_buffer, _terminator);
      }
    }
  }

  static Transaction stringTerminated(
      Stream<Uint8List> input, Uint8List terminator,) {
    return Transaction._(input, terminator);
  }

  static int _indexOf(List<int> data, List<int> pattern) {
    for (int i = 0; i <= data.length - pattern.length; i++) {
      bool found = true;
      for (int j = 0; j < pattern.length; j++) {
        if (data[i + j] != pattern[j]) {
          found = false;
          break;
        }
      }
      if (found) return i;
    }
    return -1;
  }
}

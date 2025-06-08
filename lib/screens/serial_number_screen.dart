import 'dart:convert';
import 'dart:typed_data' as typed;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> sendData(Map<String, dynamic> data) async {
    if (_port == null) {
      debugPrint('Port not open');
      return;
    }

    String jsonString = json.encode(data);
    await _port!.write(typed.Uint8List.fromList(utf8.encode('$jsonString\n')));
    debugPrint('Sent: $jsonString');
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
      await for (var chunk in reader.stream.timeout(const Duration(seconds: 3), onTimeout: (sink) {
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

/// 🧩 SerialNumberCubit
class SerialNumberCubit extends Cubit<SerialNumberState> {
  final UsbService usbService;

  SerialNumberCubit(this.usbService) : super(SerialNumberInitial());

  Future<void> fetchSerialNumber() async {
    emit(SerialNumberLoading());

    try {
      final isConnected = await usbService.connect();
      if (!isConnected) {
        emit(SerialNumberError('USB device not found'));
        return;
      }

      await usbService.sendData({'action': 'read_serial'});
      final response = await usbService.readData();
      await usbService.close();

      if (response != null) {
        final serial = _parseSerialNumberFromResponse(response);
        emit(SerialNumberLoaded(serial));
      } else {
        emit(SerialNumberError('Failed to read serial number'));
      }
    } catch (e) {
      emit(SerialNumberError('Error: ${e.toString()}'));
    }
  }

  String _parseSerialNumberFromResponse(String response) {
    try {
      final data = response.trim();
      final jsonMap = jsonDecode(data);
      if (jsonMap['status'] == 'OK' && jsonMap['message'] != null) {
        final message = jsonMap['message'].toString();
        return message.isEmpty ? 'Serial number is empty' : message;
      }
      return 'Serial number not found';
    } catch (e) {
      return 'Invalid response format';
    }
  }
}

/// 📦 SerialNumberState
abstract class SerialNumberState {}

class SerialNumberInitial extends SerialNumberState {}

class SerialNumberLoading extends SerialNumberState {}

class SerialNumberLoaded extends SerialNumberState {
  final String serialNumber;
  SerialNumberLoaded(this.serialNumber);
}

class SerialNumberError extends SerialNumberState {
  final String message;
  SerialNumberError(this.message);
}

/// 📱 SerialNumberScreen
class SerialNumberScreen extends StatefulWidget {
  const SerialNumberScreen({super.key});

  @override
  State<SerialNumberScreen> createState() => _SerialNumberScreenState();
}

class _SerialNumberScreenState extends State<SerialNumberScreen> {
  late final SerialNumberCubit _cubit;
  final _usbService = UsbService();

  @override
  void initState() {
    super.initState();
    _cubit = SerialNumberCubit(_usbService);
    _cubit.fetchSerialNumber();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _showSerialNumberDialog() {
    final serialController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
              final newSerial = serialController.text.trim();
              if (newSerial.isEmpty) {
                Navigator.pop(dialogContext);
                _showMessage('Serial number cannot be empty.');
                return;
              }

              final connected = await _usbService.connect();
              if (!connected) {
                Navigator.pop(dialogContext);
                _showMessage('Failed to connect to microcontroller.');
                return;
              }

              await _usbService.sendData({
                'username': 'admin',
                'password': '1234',
                'serial_number': newSerial,
              });

              final response = await _usbService.readData();
              await _usbService.close();
              Navigator.pop(dialogContext);

              if (response != null && response.contains('OK')) {
                _showMessage('Serial number updated.');
                _cubit.fetchSerialNumber();
              } else {
                _showMessage('Failed to update serial number.');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Info'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Serial Number')),
        body: BlocBuilder<SerialNumberCubit, SerialNumberState>(
          builder: (context, state) {
            if (state is SerialNumberLoading || state is SerialNumberInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SerialNumberLoaded) {
              return _buildContent(state.serialNumber);
            } else if (state is SerialNumberError) {
              return _buildContent(state.message);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Serial Number:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _cubit.fetchSerialNumber(),
            child: const Text('Refresh'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

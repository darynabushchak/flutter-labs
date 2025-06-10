import 'dart:convert';

import 'package:app/cubits/serial_number/serial_number_state.dart';
import 'package:app/services/usb_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SerialNumberCubit extends Cubit<SerialNumberState> {
  final UsbService usbService;

  SerialNumberCubit(this.usbService) : super(SerialNumberInitial());

  Future<void> fetchSerialNumber() async {
    emit(SerialNumberLoading());
    try {
      final connected = await usbService.connect();
      if (!connected) {
        emit(SerialNumberError('USB device not found'));
        return;
      }

      await usbService.sendData({'action': 'read_serial'});
      final response = await usbService.readData();
      await usbService.close();

      if (response != null) {
        final data = jsonDecode(response);
        final message = data['message']?.toString() ?? '';
        emit(
          SerialNumberLoaded(
            message.isEmpty ? 'Serial number is empty' : message,
          ),
        );
      } else {
        emit(SerialNumberError('Failed to read serial number'));
      }
    } catch (e) {
      emit(SerialNumberError('Error: ${e.toString()}'));
    }
  }

  Future<void> updateSerialNumber(String newSerial) async {
    emit(SerialNumberLoading());
    try {
      final connected = await usbService.connect();
      if (!connected) {
        emit(SerialNumberError('USB device not found'));
        return;
      }

      await usbService.sendData({
        'username': 'admin',
        'password': '1234',
        'serial_number': newSerial,
      });
      final response = await usbService.readData();
      await usbService.close();

      if (response != null && response.contains('OK')) {
        emit(SerialNumberLoaded(newSerial));
      } else {
        emit(SerialNumberError('Failed to update serial number'));
      }
    } catch (e) {
      emit(SerialNumberError('Error: ${e.toString()}'));
    }
  }
}

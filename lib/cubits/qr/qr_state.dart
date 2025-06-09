import 'dart:convert';
import 'package:app/cubits/qr/qr_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QrCubit extends Cubit<QrState> {
  QrCubit() : super(QrInitial());

  void startScanning() {
    emit(QrScanning());
  }

  void processQrCode(String rawValue) {
    emit(QrScanning());

    try {
      final data = json.decode(rawValue);
      if (data is Map<String, dynamic>) {
        if (data.containsKey('username') && data.containsKey('password')) {
          emit(QrScanned(rawValue));
        } else {
          emit(QrError('QR code does not contain valid credentials.'));
        }
      } else {
        emit(QrError('Invalid QR code format.'));
      }
    } catch (e) {
      emit(QrError('Failed to parse QR code.'));
    }
  }

  void reset() {
    emit(QrInitial());
  }
}

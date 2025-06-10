import 'package:app/cubits/qr/qr_cubit.dart';
import 'package:app/cubits/qr/qr_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QrCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('QR Scanner')),
        body: BlocConsumer<QrCubit, QrState>(
          listener: (context, state) {
            if (state is QrScanned) {
              Navigator.pushNamed(context, '/edit-serial',
                  arguments: state.rawValue,);
            } else if (state is QrError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is QrScanning || state is QrInitial) {
              return _buildScanner(context);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildScanner(BuildContext context) {
    final cubit = context.read<QrCubit>();

    return MobileScanner(
      onDetect: (capture) {
        final barcode = capture.barcodes.first;
        final rawValue = barcode.rawValue;
        if (rawValue != null) {
          cubit.processQrCode(rawValue);
        }
      },
    );
  }
}

import 'package:app/cubits/serial_number/serial_number_cubit.dart';
import 'package:app/cubits/serial_number/serial_number_state.dart';
import 'package:app/services/usb_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SerialNumberScreen extends StatelessWidget {
  const SerialNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SerialNumberCubit(UsbService())..fetchSerialNumber(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Serial Number')),
        body: BlocBuilder<SerialNumberCubit, SerialNumberState>(
          builder: (context, state) {
            if (state is SerialNumberLoading || state is SerialNumberInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SerialNumberLoaded) {
              return _buildContent(context, state.serialNumber);
            } else if (state is SerialNumberError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, String serialNumber) {
    final cubit = context.read<SerialNumberCubit>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Serial Number:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(serialNumber, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: cubit.fetchSerialNumber,
            child: const Text('Refresh'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _showEditDialog(context, cubit),
            child: const Text('Edit Serial Number'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, SerialNumberCubit cubit) {
    final serialController = TextEditingController();
    showDialog(
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
            onPressed: () {
              final newSerial = serialController.text.trim();
              if (newSerial.isNotEmpty) {
                cubit.updateSerialNumber(newSerial);
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

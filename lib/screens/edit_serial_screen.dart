import 'package:app/services/usb_service.dart';
import 'package:flutter/material.dart';

class EditSerialScreen extends StatefulWidget {
  const EditSerialScreen({super.key});

  @override
  State<EditSerialScreen> createState() => _EditSerialScreenState();
}

class _EditSerialScreenState extends State<EditSerialScreen> {
  final usbService = UsbService();
  final TextEditingController controller = TextEditingController();
  String status = '';

  Future<void> saveSerial() async {
    final newSerial = controller.text.trim();
    if (newSerial.isEmpty) {
      setState(() {
        status = 'Serial number cannot be empty!';
      });
      return;
    }
    if (await usbService.connect()) {
      await usbService.sendData({
        'username': 'admin',
        'password': '1234',
        'serial_number': newSerial,
      });
      final response = await usbService.readData();
      setState(() {
        status = response ?? 'No response from device';
      });
      await usbService.close();
    } else {
      setState(() {
        status = 'Could not connect to device';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Serial Number')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'New Serial Number',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveSerial,
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            Text(status),
          ],
        ),
      ),
    );
  }
}

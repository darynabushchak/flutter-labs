import 'package:app/services/serial_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StoredDataScreen extends StatefulWidget {
  const StoredDataScreen({super.key});

  @override
  State<StoredDataScreen> createState() => _StoredDataScreenState();
}

class _StoredDataScreenState extends State<StoredDataScreen> {
  late Future<String> _readResult;

  @override
  void initState() {
    super.initState();
    _readResult = SerialService.sendToMicrocontroller('{"action":"read_serial"}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Last Stored Serial')),
      body: FutureBuilder<String>(
        future: _readResult,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            if (kDebugMode) {
              print('❌ FutureBuilder error: ${snapshot.error}');
            }
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            final data = snapshot.data?.trim();
            return Center(
              child: Text(
                data != null && data.isNotEmpty
                    ? '📦 Stored serial:\n$data'
                    : '⚠️ No serial number found',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}

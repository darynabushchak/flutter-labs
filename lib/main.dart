import 'package:app/screens/login_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:app/screens/scan_qr_code_screen.dart';
import 'package:app/screens/serial_number_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Labs - Cubit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginScreen(),
        '/serial-number': (_) => const SerialNumberScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/qr-scanner': (_) => const QrScannerScreen(),
      },
    );
  }
}

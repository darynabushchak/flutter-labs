import 'package:app/components/bottom_nav_bar.dart';
import 'package:app/login_components/login_content.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        backgroundColor: const Color(0xFF254D19),
        foregroundColor: Colors.white,
      ),
      body: const LoginContent(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

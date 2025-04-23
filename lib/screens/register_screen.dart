import 'package:app/components/bottom_nav_bar.dart';
import 'package:app/register_components/register_content.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color(0xFF254D19),
        foregroundColor: Colors.white,
      ),
      body: const RegisterContent(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

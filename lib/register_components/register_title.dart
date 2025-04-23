import 'package:flutter/material.dart';

class RegisterTitle extends StatelessWidget {
  const RegisterTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Create New Account',
      style: TextStyle(
        color: Color(0xFF098449),
        fontSize: 34,
        fontWeight: FontWeight.bold,
        fontFamily: 'Lato',
      ),
      textAlign: TextAlign.center,
    );
  }
}

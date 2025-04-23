import 'package:flutter/material.dart';

class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Log into your account',
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

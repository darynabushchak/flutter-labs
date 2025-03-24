import 'package:app/components/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(label: 'Email or Username'),
        SizedBox(height: 10),
        CustomTextField(label: 'Password', obscureText: true),
      ],
    );
  }
}

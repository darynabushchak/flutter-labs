import 'package:app/components/custom_text_field.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CustomTextField(label: 'Username'),
        SizedBox(height: 10),
        CustomTextField(label: 'Email'),
        SizedBox(height: 10),
        CustomTextField(label: 'Password', obscureText: true),
      ],
    );
  }
}

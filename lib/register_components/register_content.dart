import 'package:app/register_components/register_buttons.dart';
import 'package:app/register_components/register_form.dart';
import 'package:app/register_components/register_title.dart';
import 'package:flutter/material.dart';

class RegisterContent extends StatelessWidget {
  const RegisterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RegisterTitle(),
          SizedBox(height: 20),
          RegisterForm(),
          SizedBox(height: 20),
          RegisterButtons(),
        ],
      ),
    );
  }
}

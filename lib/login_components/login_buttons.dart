import 'package:app/components/custom_button.dart';
import 'package:flutter/material.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'Log In',
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

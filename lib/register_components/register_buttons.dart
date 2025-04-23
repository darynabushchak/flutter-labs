import 'package:flutter/material.dart';

class RegisterButtons extends StatelessWidget {
  const RegisterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already Registered? ',
          style: TextStyle(fontSize: 18),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: const Text(
            'Log in here',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF069498),
            ),
          ),
        ),
      ],
    );
  }
}

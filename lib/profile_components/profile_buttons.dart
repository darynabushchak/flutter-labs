import 'package:app/components/custom_button.dart';
import 'package:flutter/material.dart';

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Login or Sign Up',
      onPressed: () => Navigator.pushNamed(context, '/login'),
    );
  }
}

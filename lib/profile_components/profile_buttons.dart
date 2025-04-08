import 'package:app/components/custom_button.dart';
import 'package:app/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<UserProvider>().user != null;

    return CustomButton(
      text: isLoggedIn ? 'Log out' : 'Login or Sign Up',
      onPressed: () async {
        if (isLoggedIn) {
          await context.read<UserProvider>().logout();

          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
    );
  }
}

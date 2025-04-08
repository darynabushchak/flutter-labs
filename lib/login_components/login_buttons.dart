import 'package:app/components/custom_button.dart';
import 'package:app/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginButtons extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButtons({
    required this.emailController,
    required this.passwordController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'Log In',
          onPressed: () async {
            final email = emailController.text.trim();
            final password = passwordController.text;

            final success =
                await context.read<UserProvider>().login(email, password);
            if (success) {
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Wrong credentials')),
                );
              }
            }
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

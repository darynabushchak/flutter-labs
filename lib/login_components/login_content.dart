import 'package:app/login_components/login_buttons.dart';
import 'package:app/login_components/login_form.dart';
import 'package:app/login_components/login_title.dart';
import 'package:flutter/material.dart';

class LoginContent extends StatelessWidget {
  const LoginContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LoginTitle(),
          const SizedBox(height: 20),
          const LoginForm(),
          const SizedBox(height: 20),
          const LoginButtons(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Not registered? ',
                style: TextStyle(fontSize: 18),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  'Register here',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF069498),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

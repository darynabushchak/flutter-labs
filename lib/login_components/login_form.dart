import 'package:app/components/custom_text_field.dart';
import 'package:app/services/connectivity_service.dart';
import 'package:app/utils/validators.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForm({
    required this.emailController,
    required this.passwordController,
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: widget.emailController,
            label: 'Email',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!validateEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: widget.passwordController,
            label: 'Password',
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final focusScope = FocusScope.of(context);

              final hasConnection =
                  await ConnectivityService.hasInternetConnection();
              if (!mounted) return;

              if (!hasConnection) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('No internet connection')),
                );
                return;
              }

              if (_formKey.currentState?.validate() ?? false) {
                focusScope.unfocus();
              } else {
                messenger.showSnackBar(
                  const SnackBar(content: Text('Invalid form')),
                );
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

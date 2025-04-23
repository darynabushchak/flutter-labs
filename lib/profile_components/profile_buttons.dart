import 'package:app/components/custom_button.dart';
import 'package:app/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      await context.read<UserProvider>().logout();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<UserProvider>().user != null;

    return CustomButton(
      text: isLoggedIn ? 'Log out' : 'Login or Sign Up',
      onPressed: () {
        if (isLoggedIn) {
          _confirmLogout(context);
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
    );
  }
}

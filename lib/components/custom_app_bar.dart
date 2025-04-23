import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Festivo App'),
      centerTitle: true,
      backgroundColor: const Color(0xFF254D19),
      foregroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(0),
        child: ClipOval(
          child: Image.asset(
            'assets/logo.png',
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

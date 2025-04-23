import 'package:app/components/bottom_nav_bar.dart';
import 'package:app/profile_components/profile_content.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF254D19),
        foregroundColor: Colors.white,
      ),
      body: const ProfileContent(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

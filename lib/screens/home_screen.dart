import 'package:app/components/bottom_nav_bar.dart';
import 'package:app/home_components/home_content.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0xFF254D19),
        foregroundColor: Colors.white,
      ),
      body: const HomeContent(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

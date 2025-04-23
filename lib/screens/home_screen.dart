import 'package:app/components/bottom_nav_bar.dart';
import 'package:app/home_components/home_content.dart';
import 'package:app/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final greetingName =
        (user?.name.isNotEmpty ?? false) ? user!.name : user?.email ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $greetingName'),
        backgroundColor: const Color(0xFF254D19),
        foregroundColor: Colors.white,
      ),
      body: const HomeContent(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

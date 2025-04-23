import 'dart:async';

import 'package:app/components/bottom_nav_bar.dart';
import 'package:app/home_components/home_content.dart';
import 'package:app/state/user_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();

    final provider = context.read<UserProvider>();
    if (provider.offlineMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offline mode: limited functionality'),
            backgroundColor: Colors.orange,
          ),
        );
      });
    }

    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection lost'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final name = user?.name ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $name'),
        backgroundColor: const Color(0xFF254D19),
        foregroundColor: Colors.white,
      ),
      body: const HomeContent(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

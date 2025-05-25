import 'package:app/screens/filter_screen.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:app/screens/register_screen.dart';
import 'package:app/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userProvider = UserProvider();
  await userProvider.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => userProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final initialRoute = user != null ? '/home' : '/register';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Festivo App',
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const HomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/filter': (context) => const FilterScreen(),
      },
    );
  }
}

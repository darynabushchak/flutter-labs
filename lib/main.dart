import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ColorScreen(),
    );
  }
}

class ColorScreen extends StatefulWidget {
  const ColorScreen({super.key});

  @override
  State<ColorScreen> createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  Color _bgColor = Colors.white;

  Color _getColorFromString(String color) {
    switch (color.toLowerCase()) {
      case 'red':
        return Colors.redAccent;
      case 'green':
        return Colors.greenAccent;
      case 'blue':
        return Colors.blueAccent;
      case 'turn off':
        return Colors.black;
      default:
        return Colors.white;
    }
  }

  void _updateColor(String input) {
    setState(() {
      _bgColor = _getColorFromString(input);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Type a color (red, green, blue, etc.)',
            ),
            onSubmitted: _updateColor,
          ),
        ),
      ),
    );
  }
}

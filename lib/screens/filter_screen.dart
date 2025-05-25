import 'package:app/home_components/light_bulb_widget.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final List<Color> colors = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.blue,
  ];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startColorCycle();
  }

  void _startColorCycle() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Color Cycle Lamp')),
      body: Center(
        child: LightBulbWidget(color: colors[currentIndex]),
      ),
    );
  }
}

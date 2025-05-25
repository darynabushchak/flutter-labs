import 'package:flutter/material.dart';

class LightBulbWidget extends StatelessWidget {
  final Color color;

  const LightBulbWidget({required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: const Icon(
        Icons.lightbulb,
        size: 80,
        color: Colors.white,
      ),
    );
  }
}

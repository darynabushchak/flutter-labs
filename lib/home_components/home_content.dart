import 'package:app/home_components/home_buttons.dart';
import 'package:app/home_components/mode_selector.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available modes',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato',
                  color: Color(0xFF6fa666),
                ),
              ),
              SizedBox(height: 10),
              ModeSelector(),
            ],
          ),
        ),
        Spacer(),
        HomeButtons(),
      ],
    );
  }
}

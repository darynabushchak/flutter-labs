import 'package:app/components/custom_button.dart';
import 'package:flutter/material.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: const Text(
              'Create Your Own',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
                color: Color(0xFF6fa666),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Apply',
            onPressed: () {},
            textStyle: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

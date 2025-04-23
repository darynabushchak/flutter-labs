import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? textStyle;

  const CustomButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6fa666),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size(250, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}

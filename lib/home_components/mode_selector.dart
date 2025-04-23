import 'package:flutter/material.dart';

class ModeSelector extends StatefulWidget {
  const ModeSelector({super.key});

  @override
  State<ModeSelector> createState() => _ModeSelectorState();
}

class _ModeSelectorState extends State<ModeSelector> {
  String selectedMode = 'permanent lighting';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ['permanent lighting', 'slow', 'flashing'].map((mode) {
        return RadioListTile<String>(
          title: Text(
            mode,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Color(0xFF404040),
            ),
          ),
          value: mode,
          groupValue: selectedMode,
          onChanged: (value) {
            setState(() => selectedMode = value!);
          },
        );
      }).toList(),
    );
  }
}

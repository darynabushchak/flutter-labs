import 'package:app/profile_components/profile_buttons.dart';
import 'package:app/profile_components/profile_title.dart';
import 'package:flutter/material.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileTitle(),
            SizedBox(height: 20),
            ProfileButtons(),
          ],
        ),
      ),
    );
  }
}

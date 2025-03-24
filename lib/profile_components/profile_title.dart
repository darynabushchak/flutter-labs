import 'package:app/profile_components/profile_avatar.dart';
import 'package:flutter/material.dart';

class ProfileTitle extends StatelessWidget {
  const ProfileTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ProfileAvatar(imageUrl: 'assets/user.png'),
        SizedBox(height: 20),
      ],
    );
  }
}

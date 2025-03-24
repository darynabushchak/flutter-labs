import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;

  const ProfileAvatar({super.key, required this.imageUrl, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: AssetImage(imageUrl),
      onBackgroundImageError: (exception, stackTrace) {
      },
    );
  }
}

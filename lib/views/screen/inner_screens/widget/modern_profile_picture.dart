import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class ModernProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;

  const ModernProfileAvatar({
    Key? key,
    this.imageUrl,
    this.size = TSizes.iconLg,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.white,
        backgroundImage:
            (imageUrl != null && imageUrl!.isNotEmpty) ? NetworkImage(imageUrl!) : null,
        child: (imageUrl == null || imageUrl!.isEmpty)
            ? Icon(Icons.person, size: size * 0.65, color: Colors.grey.shade400)
            : null,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/widget/modern_profile_picture.dart';

class HomeHeader extends StatelessWidget {
  final String? name;
  final String? profileImageUrl;

  const HomeHeader({
    Key? key,
    this.name,
    this.profileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ModernProfileAvatar(
          imageUrl: profileImageUrl,
          size: 44,
          onTap: () {
            // Optional: Go to profile screen
          },
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            'Good day for shopping${name != null ? ', $name' : ''}!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

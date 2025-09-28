import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String userId;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool showCamera;
  final double radius;

  const ProfilePictureWidget({
    super.key,
    required this.userId,
    this.borderColor,
    this.backgroundColor,
    this.showCamera = false,
    this.radius = 50,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('buyers')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        String? profileImageUrl;
        
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          profileImageUrl = data?['profileImage'] as String?;
        }

        return Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 3)
                : null,
            boxShadow: [
              BoxShadow(
                color: TColors.primary.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipOval(
            child: profileImageUrl != null && profileImageUrl.isNotEmpty
                ? Image.network(
                    profileImageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: backgroundColor ?? TColors.lightContainer,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: TColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar();
                    },
                  )
                : _buildDefaultAvatar(),
          ),
        );
      },
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: backgroundColor ?? TColors.lightContainer,
      child: Center(
        child: Icon(
          Iconsax.user,
          color: TColors.primary,
          size: radius * 0.6,
        ),
      ),
    );
  }
}
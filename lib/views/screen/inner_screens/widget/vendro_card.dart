import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class VendorCard extends StatelessWidget {
  final String fullName;
  final String email;
  final String? storeImage;
  final String? city;
  final String? locality;
  final String? streetAddress;
  final VoidCallback onTap;
  final bool isVerified;

  const VendorCard({
    super.key,
    required this.fullName,
    required this.email,
    this.storeImage,
    this.city,
    this.locality,
    this.streetAddress,
    required this.onTap,
    this.isVerified = false,
  });

  String _buildAddressString() {
    List<String> addressParts = [];
    
    if (city != null && city!.isNotEmpty) {
      addressParts.add(city!);
    }
    if (locality != null && locality!.isNotEmpty) {
      addressParts.add(locality!);
    }
    if (streetAddress != null && streetAddress!.isNotEmpty) {
      addressParts.add(streetAddress!);
    }
    
    return addressParts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    final addressString = _buildAddressString();

    return Container(
      width: TSizes.vendorCardWidth, // Add this to TSizes: static const double vendorCardWidth = 280.0;
      height: TSizes.vendorCardHeight, // Add this to TSizes: static const double vendorCardHeight = 160.0;
      margin: const EdgeInsets.only(right: TSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.lightContainer,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: isDark ? TColors.darkGrey.withOpacity(0.1) : TColors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          child: Padding(
            padding: const EdgeInsets.all(TSizes.lg), // Increased padding for breathing space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Profile Image and Verified Badge
                Row(
                  children: [
                    // Store Image Avatar - Larger size
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            TColors.newBlue.withOpacity(0.15),
                            TColors.newBlue.withOpacity(0.08),
                          ],
                        ),
                        border: Border.all(
                          color: TColors.newBlue.withOpacity(0.2),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: TColors.newBlue.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 32, // Increased from 28
                        backgroundColor: Colors.transparent,
                        backgroundImage: (storeImage != null && storeImage!.isNotEmpty)
                            ? NetworkImage(storeImage!)
                            : null,
                        child: (storeImage == null || storeImage!.isEmpty)
                            ? Text(
                                fullName.isNotEmpty ? fullName[0].toUpperCase() : 'V',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: TColors.newBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Verified Badge - More prominent
                    if (isVerified)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.sm,
                          vertical: TSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              TColors.success.withOpacity(0.15),
                              TColors.success.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                          border: Border.all(
                            color: TColors.success.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Iconsax.verify5,
                              color: TColors.success,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Verified',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: TColors.success,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: TSizes.spaceBtwItems), // More space
                
                // Vendor Name - More prominent
                Text(
                  fullName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? TColors.textDarkPrimary : TColors.textPrimary,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                
                // Email with Icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: TColors.newBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Iconsax.sms,
                        size: 12,
                        color: TColors.newBlue,
                      ),
                    ),
                    const SizedBox(width: TSizes.sm),
                    Expanded(
                      child: Text(
                        email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                
                // Address (if available) with Icon
                if (addressString.isNotEmpty)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: TColors.newBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Iconsax.location,
                          size: 12,
                          color: TColors.newBlue,
                        ),
                      ),
                      const SizedBox(width: TSizes.sm),
                      Expanded(
                        child: Text(
                          addressString,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                
                const Spacer(),
                
                // Bottom Row: Action Button
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: TSizes.sm,
                          horizontal: TSizes.md,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              TColors.newBlue,
                              TColors.newBlue.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                          boxShadow: [
                            BoxShadow(
                              color: TColors.newBlue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Visit Store',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: TColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: TSizes.xs),
                            Icon(
                              Iconsax.arrow_right_3,
                              color: TColors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
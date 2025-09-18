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
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkerGrey : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          child: Padding(
            padding: const EdgeInsets.all(TSizes.md),
            child: Row(
              children: [
                // Store Image Avatar
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        TColors.newBlue.withOpacity(0.1),
                        TColors.newBlue.withOpacity(0.05),
                      ],
                    ),
                    border: Border.all(
                      color: TColors.newBlue.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.transparent,
                    backgroundImage: (storeImage != null && storeImage!.isNotEmpty)
                        ? NetworkImage(storeImage!)
                        : null,
                    child: (storeImage == null || storeImage!.isEmpty)
                        ? Text(
                            fullName.isNotEmpty ? fullName[0].toUpperCase() : 'V',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: TColors.newBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ),
                
                const SizedBox(width: TSizes.md),
                
                // Vendor Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vendor Name and Verified Badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              fullName,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isDark ? TColors.textDarkPrimary : TColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isVerified) ...[
                            const SizedBox(width: TSizes.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TSizes.sm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: TColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                                border: Border.all(
                                  color: TColors.success.withOpacity(0.2),
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Iconsax.verify5,
                                    color: TColors.success,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Verified',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: TColors.success,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Email
                      Row(
                        children: [
                          Icon(
                            Iconsax.sms,
                            size: 14,
                            color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              email,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      
                      // Address (if available)
                      if (addressString.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Iconsax.location,
                              size: 14,
                              color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                addressString,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(width: TSizes.sm),
                
                // Arrow Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TColors.newBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                  ),
                  child: Icon(
                    Iconsax.arrow_right_3,
                    color: TColors.newBlue,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
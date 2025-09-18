import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class OrderHistoryWidget extends StatelessWidget {
  final String orderId;
  final String shoeImage;
  final String shoeName;
  final double shoePrice;
  final int quantity;
  final String shoeSizes;
  final DateTime createdAt;
  final bool delivered;
  final bool processing;
  final VoidCallback onTap;

  const OrderHistoryWidget({
    super.key,
    required this.orderId,
    required this.shoeImage,
    required this.shoeName,
    required this.shoePrice,
    required this.quantity,
    required this.shoeSizes,
    required this.createdAt,
    required this.delivered,
    required this.processing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.white,
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
            padding: const EdgeInsets.all(TSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status and Order ID Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusBadge(context, isDark),
                    Text(
                      '#${orderId.length > 8 ? orderId.substring(0, 8).toUpperCase() : orderId.toUpperCase()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? TColors.darkGrey : TColors.darkGrey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: TSizes.spaceBtwItems),

                // Main Content Row - Image and Details
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shoe Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                        border: Border.all(
                          color: isDark ? TColors.darkGrey : TColors.grey.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                        child: Image.network(
                          shoeImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: isDark ? TColors.darkerGrey : TColors.lightContainer,
                              child: Icon(
                                Iconsax.image,
                                color: isDark ? TColors.darkGrey : TColors.darkGrey,
                                size: 32,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: isDark ? TColors.darkerGrey : TColors.lightContainer,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: TColors.newBlue,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: TSizes.md),

                    // Order Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Shoe Name
                          Text(
                            shoeName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? TColors.white : TColors.dark,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: TSizes.spaceBtwItems / 2),

                          // Price and Quantity Row
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TSizes.sm,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: TColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                                ),
                                child: Text(
                                  '\$${shoePrice.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: TColors.success,
                                  ),
                                ),
                              ),
                              const SizedBox(width: TSizes.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TSizes.sm,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: TColors.newBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                                ),
                                child: Text(
                                  'Qty: $quantity',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: TColors.newBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: TSizes.spaceBtwItems / 2),

                          // Shoe Size
                          Row(
                            children: [
                              Icon(
                                Iconsax.size,
                                size: 14,
                                color: isDark ? TColors.darkGrey : TColors.darkGrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Size: $shoeSizes',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDark ? TColors.darkGrey : TColors.darkGrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: TSizes.spaceBtwItems / 2),

                          // Order Date
                          Row(
                            children: [
                              Icon(
                                Iconsax.calendar,
                                size: 14,
                                color: isDark ? TColors.darkGrey : TColors.darkGrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('MMM dd, yyyy • hh:mm a').format(createdAt),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDark ? TColors.darkGrey : TColors.darkGrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: TSizes.spaceBtwItems),

                // Total Price Row
                Container(
                  padding: const EdgeInsets.all(TSizes.sm),
                  decoration: BoxDecoration(
                    color: isDark ? TColors.darkerGrey : TColors.lightContainer,
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? TColors.white : TColors.dark,
                        ),
                      ),
                      Text(
                        '\$${(shoePrice * quantity).toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: TColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isDark) {
    Color badgeColor;
    IconData badgeIcon;
    String badgeText;

    if (delivered) {
      badgeColor = TColors.success;
      badgeIcon = Iconsax.tick_circle;
      badgeText = 'Delivered';
    } else if (processing) {
      badgeColor = TColors.warning;
      badgeIcon = Iconsax.clock;
      badgeText = 'Processing';
    } else {
      badgeColor = TColors.info;
      badgeIcon = Iconsax.info_circle;
      badgeText = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.sm,
        vertical: TSizes.xs,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            badgeColor.withOpacity(0.15),
            badgeColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
        border: Border.all(
          color: badgeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeIcon,
            color: badgeColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            badgeText,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
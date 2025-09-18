import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class OrderHistoryWidget extends StatelessWidget {
  final String orderId;
  final String status; // 'delivered' or 'processing'
  final double totalPrice;
  final int itemCount;
  final DateTime orderDate;
  final List<dynamic>? items;
  final VoidCallback onTap;
  final Map<String, dynamic>? additionalData;

  const OrderHistoryWidget({
    super.key,
    required this.orderId,
    required this.status,
    required this.totalPrice,
    required this.itemCount,
    required this.orderDate,
    this.items,
    required this.onTap,
    this.additionalData,
  });

  bool get isDelivered => status.toLowerCase() == 'delivered' || (additionalData?['delivered'] == true);
  bool get isProcessing => status.toLowerCase() == 'processing' || (additionalData?['processing'] == true);

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
                // Header Row - Order ID and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Order ID
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark ? TColors.darkGrey : TColors.darkGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '#${orderId.substring(0, 8).toUpperCase()}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? TColors.white : TColors.dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Status Badge
                    _buildStatusBadge(context, isDark),
                  ],
                ),
                
                const SizedBox(height: TSizes.spaceBtwItems),
                
                // Order Details Row
                Row(
                  children: [
                    // Items Count
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        Iconsax.box,
                        '$itemCount Items',
                        'Products',
                        TColors.newBlue,
                        isDark,
                      ),
                    ),
                    
                    const SizedBox(width: TSizes.spaceBtwItems),
                    
                    // Total Price
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        Iconsax.dollar_circle,
                        '\$${totalPrice.toStringAsFixed(2)}',
                        'Total',
                        TColors.success,
                        isDark,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: TSizes.spaceBtwItems),
                
                // Order Date and Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Order Date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Date',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark ? TColors.darkGrey : TColors.darkGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('MMM dd, yyyy').format(orderDate),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark ? TColors.white : TColors.dark,
                          ),
                        ),
                      ],
                    ),
                    
                    // View Details Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.md,
                        vertical: TSizes.sm,
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View Details',
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
                  ],
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

    if (isDelivered) {
      badgeColor = TColors.success;
      badgeIcon = Iconsax.tick_circle;
      badgeText = 'Delivered';
    } else if (isProcessing) {
      badgeColor = TColors.warning;
      badgeIcon = Iconsax.clock;
      badgeText = 'Processing';
    } else {
      badgeColor = TColors.info;
      badgeIcon = Iconsax.info_circle;
      badgeText = 'Unknown';
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

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color iconColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(TSizes.sm),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkerGrey : TColors.lightContainer,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        border: Border.all(
          color: isDark ? TColors.darkGrey.withOpacity(0.2) : TColors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 16,
            ),
          ),
          const SizedBox(width: TSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? TColors.white : TColors.dark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? TColors.darkGrey : TColors.darkGrey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
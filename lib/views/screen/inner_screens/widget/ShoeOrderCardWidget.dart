import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class ShoeOrderCard extends StatelessWidget {
  final String shoeImage;
  final String shoeName;
  final String shoeCategory;
  final int quantity;
  final List<String> shoeSizes;
  final double shoePrice;
  final String orderId;
  final DateTime createdAt;
  final bool delivered;
  final bool processing;

  const ShoeOrderCard({
    Key? key,
    required this.shoeImage,
    required this.shoeName,
    required this.shoeCategory,
    required this.quantity,
    required this.shoeSizes,
    required this.shoePrice,
    required this.orderId,
    required this.createdAt,
    required this.delivered,
    required this.processing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format date
    final formattedDate = DateFormat('MMM d, yyyy').format(createdAt);

    // Choose badge and color
    String status;
    Color badgeColor;
    IconData statusIcon;
    
    if (delivered) {
      status = "Delivered";
      badgeColor = Colors.green.shade600;
      statusIcon = Icons.check_circle_outline;
    } else if (processing) {
      status = "Processing";
      badgeColor = Colors.orange.shade600;
      statusIcon = Icons.refresh_rounded;
    } else {
      status = "Pending";
      badgeColor = Colors.grey.shade600;
      statusIcon = Icons.hourglass_empty_rounded;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shadowColor: Colors.black.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Order ID
                Text(
                  "Order #${orderId.substring(0, 6)}",
                  style:Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 13,
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: 16,
                        color: badgeColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: badgeColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Product details section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shoe Image
                Hero(
                  tag: 'order_image_$orderId',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      shoeImage,
                      width:TSizes.productImageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shoeName,
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Category chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          shoeCategory,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.blue.shade700,
                            fontSize: 12
                          )
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Size and quantity
                      Row(
                        children: [
                          _buildInfoItem(context, "Size" , shoeSizes.join(', ')),
                          const SizedBox(width: 16),
                          _buildInfoItem(context, "Qty", quantity.toString()),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Price with bold styling
                      Text(
                        "\$${shoePrice.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: TColors.newBlue,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: TColors.darkGrey),
            ),
            
            // Order date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Iconsax.calendar5,
                      size: TSizes.iconSm,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Ordered on: $formattedDate",
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for product info items
  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
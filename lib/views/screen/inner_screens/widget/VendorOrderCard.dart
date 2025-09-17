import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/views/vendor_side/vendor_order_details_screen.dart';

class VendorOrderCard extends StatelessWidget {
  final String shoeImage;
  final String shoeName;
  final String shoeCategory;
  final int quantity;
  final String shoeSizes;
  final double shoePrice;
  final String orderId;
  final DateTime createdAt;
  final bool delivered;
  final bool processing;
  final String locality;
  final String fullName;
  final String State;
  final String streetAddress;
  final String zipCode;
  final String email;
  final String shoeId;

  const VendorOrderCard({
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
    required this.locality,
    required this.fullName,
    required this.State,
    required this.streetAddress,
    required this.zipCode,
    required this.email,
    required this.shoeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formattedDate = DateFormat('MMM d, yyyy').format(createdAt);
    final totalPrice = shoePrice * quantity;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order status bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: delivered
                  ? TColors.success.withOpacity(0.1)
                  : processing
                  ? TColors.warning.withOpacity(0.1)
                  : TColors.info.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  delivered
                      ? Icons.check_circle
                      : processing
                      ? Icons.sync
                      : Icons.pending,
                  color: delivered
                      ? TColors.success
                      : processing
                      ? TColors.warning
                      : TColors.info,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  delivered
                      ? 'Delivered'
                      : processing
                      ? 'Processing'
                      : 'Pending',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: delivered
                        ? TColors.success
                        : processing
                        ? TColors.warning
                        : TColors.info,
                  ),
                ),
                const Spacer(),
                Text(
                  'Order #${orderId.substring(0, 6)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? TColors.textDarkSecondary
                        : TColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Product details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    shoeImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isDark
                            ? TColors.darkContainer
                            : TColors.lightContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.broken_image,
                        color: TColors.darkGrey,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Product info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shoeName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shoeCategory,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColors.newBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildInfoChip(context, 'Size: $shoeSizes'),
                          const SizedBox(width: 8),
                          _buildInfoChip(context, 'Qty: $quantity'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(
            color: isDark
                ? TColors.borderDark
                : TColors.borderLight.withOpacity(0.5),
            height: 1,
          ),

          // Customer details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: TColors.newBlue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Customer',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formattedDate,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? TColors.textDarkSecondary
                            : TColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                _buildCustomerDetail(context, fullName),
                _buildCustomerDetail(
                  context,
                  '$streetAddress, $locality, $State, $zipCode',
                ),
              ],
            ),
          ),

          // Divider
          Divider(
            color: isDark
                ? TColors.borderDark
                : TColors.borderLight.withOpacity(0.5),
            height: 1,
          ),

          // Order total and action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Total:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TColors.newBlue,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        context,
                        'View Details',
                        Icons.email_outlined,
                        TColors.info,
                        () {
                          // navigate to vendor details Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return VendorOrderDetailsScreen(
                                  orderData: {
                                    'shoeImage': shoeImage,
                                    'shoeName': shoeName,
                                    'shoeCategory': shoeCategory,
                                    'quantity': quantity,
                                    'shoeSizes': shoeSizes,
                                    'shoePrice': shoePrice,
                                    'orderId': orderId,
                                    'createdAt': createdAt,
                                    'delivered': delivered,
                                    'processing': processing,
                                    'locality': locality,
                                    'fullName': fullName,
                                    'State': State,
                                    'streetAddress': streetAddress,
                                    'zipCode': zipCode,
                                    'email': email,
                                    'shoeId': shoeId,
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Replace the second Expanded button with this modern design
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: delivered
                              ? TColors.success.withOpacity(0.1)
                              : TColors
                                    .newBlue, // Changed from buttonSecondary to newBlue
                          foregroundColor: delivered
                              ? TColors.success
                              : TColors.white,
                          elevation: delivered
                              ? 0
                              : 2, // Add elevation when not delivered
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Slightly more rounded
                            side: BorderSide(
                              color: delivered
                                  ? TColors.success.withOpacity(0.3)
                                  : Colors
                                        .transparent, // Only show border when delivered
                            ),
                          ),
                        ),
                        onPressed: delivered
                            ? null // Disable button when already delivered
                            : () async {
                                // Show confirmation dialog before marking as delivered
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: Text(
                                      "Confirm Delivery",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    content: Text(
                                      "Are you sure you want to mark this order as delivered? This action cannot be undone.",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: TColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: TColors.success,
                                          foregroundColor: TColors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          // Close dialog
                                          Navigator.pop(context);

                                          // Update Firestore
                                          await FirebaseFirestore.instance
                                              .collection('shoeOrders')
                                              .doc(orderId)
                                              .update({
                                                'delivered': true,
                                                'processing': false,
                                              })
                                              .then((_) {
                                              });
                                        },
                                        child: Text(
                                          "Confirm",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon changes based on delivery status
                            Icon(
                              delivered
                                  ? Icons.check_circle_outline
                                  : Icons.local_shipping_outlined,
                              size: 18,
                              color: delivered
                                  ? TColors.success
                                  : TColors.white,
                            ),
                            const SizedBox(width: 8),
                            // Text changes based on delivery status
                            Text(
                              delivered ? 'Delivered' : 'Mark as Delivered',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: delivered
                                        ? TColors.success
                                        : TColors.white,
                                  ),
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
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.lightContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildCustomerDetail(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isDark ? TColors.textDarkPrimary : TColors.textPrimary,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

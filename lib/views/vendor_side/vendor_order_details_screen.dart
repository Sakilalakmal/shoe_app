import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class VendorOrderDetailsScreen extends StatefulWidget {
  final dynamic orderData;

  const VendorOrderDetailsScreen({super.key, required this.orderData});

  @override
  State<VendorOrderDetailsScreen> createState() =>
      _VendorOrderDetailsScreenState();
}

class _VendorOrderDetailsScreenState extends State<VendorOrderDetailsScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'MMM d, yyyy',
    ).format(widget.orderData['createdAt']);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Texts.orderDetails,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: TSizes.defaultSpace),

          // Modern Order Summary and Delivery Address sections
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.defaultSpace,
              vertical: TSizes.sm,
            ),
            child: Column(
              children: [
                // Order Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? TColors.darkContainer
                        : TColors.white,
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: TColors.newBlue.withOpacity(0.06),
                        blurRadius: 16,
                        spreadRadius: 1,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title with Icon
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_long_rounded,
                            color: TColors.newBlue,
                            size: 22,
                          ),
                          const SizedBox(width: TSizes.sm),
                          Text(
                            'Order Summary',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: TColors.newBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.md),

                      // Order Details
                      _buildDetailRow(
                        context,
                        'Order ID',
                        '#${widget.orderData['orderId'].toString().substring(0, 6)}',
                        Icons.tag,
                      ),
                      const SizedBox(height: TSizes.sm),
                      _buildDetailRow(
                        context,
                        'Ordered Date',
                        formattedDate,
                        Icons.calendar_today_rounded,
                      ),
                      const SizedBox(height: TSizes.sm),

                      // Total Amount with emphasis
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money_rounded,
                            size: 18,
                            color: TColors.newBlue,
                          ),
                          const SizedBox(width: TSizes.sm),
                          Text(
                            'Total Amount:',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.md,
                              vertical: TSizes.xs,
                            ),
                            decoration: BoxDecoration(
                              color: TColors.newBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                TSizes.borderRadiusSm,
                              ),
                            ),
                            child: Text(
                              '\$${(widget.orderData['shoePrice'] * widget.orderData['quantity']).toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: TColors.newBlue,
                                    fontSize: 16,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwItems),

                // Delivery Address Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? TColors.darkContainer
                        : TColors.white,
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: TColors.newBlue.withOpacity(0.06),
                        blurRadius: 16,
                        spreadRadius: 1,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title with Icon
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: TColors.newBlue,
                            size: 22,
                          ),
                          const SizedBox(width: TSizes.sm),
                          Text(
                            'Delivery Address',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: TColors.newBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.md),

                      // Full Name
                      _buildDetailRow(
                        context,
                        'Customer Full Name',
                        widget.orderData['fullName'] ?? 'Not provided',
                        Icons.person_rounded,
                      ),
                      const SizedBox(height: TSizes.sm),

                      // Address with multi-line layout
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.home_rounded,
                            size: 18,
                            color: TColors.newBlue,
                          ),
                          const SizedBox(width: TSizes.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Address',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.orderData['streetAddress'] ?? ''}, ${widget.orderData['locality'] ?? ''}, ${widget.orderData['State'] ?? ''}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.sm),

                      // Zip Code
                      _buildDetailRow(
                        context,
                        'Zip Code',
                        widget.orderData['zipCode'] ?? 'Not provided',
                        Icons.markunread_mailbox_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Helper method for detail rows
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18, color: TColors.newBlue),
        const SizedBox(width: TSizes.sm),
        Text(
          '$label:',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

}

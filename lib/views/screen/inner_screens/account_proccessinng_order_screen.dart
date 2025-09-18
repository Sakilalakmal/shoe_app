import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/widget/order_history_widget.dart';

class AccountProccessinngOrderScreen extends StatelessWidget {
  const AccountProccessinngOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Processing Orders',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? TColors.white : TColors.dark,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.warning_2, size: 80, color: TColors.error),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                'Please log in to view your orders',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: TColors.error),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? TColors.dark : TColors.white,
      appBar: AppBar(
        title: Text(
          'Processing Orders',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? TColors.white : TColors.dark,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left,
            color: isDark ? TColors.white : TColors.dark,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: isDark ? TColors.dark : TColors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Your Processing Orders',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? TColors.white : TColors.dark,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Text(
              'Orders currently being prepared for delivery',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? TColors.darkGrey : TColors.darkGrey,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Orders List with Real-time Updates
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('shoeOrders')
                    .where('buyerId', isEqualTo: user.uid)
                    .where('processing', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: TColors.newBlue,
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          Text(
                            'Loading your processing orders...',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: isDark
                                      ? TColors.darkGrey
                                      : TColors.darkGrey,
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    print('Error in processing orders: ${snapshot.error}');
                    return _buildErrorState(context, isDark);
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState(context, isDark);
                  }

                  final orders = snapshot.data!.docs;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Orders Count Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.md,
                          vertical: TSizes.sm,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              TColors.warning.withOpacity(0.1),
                              TColors.warning.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            TSizes.cardRadiusMd,
                          ),
                          border: Border.all(
                            color: TColors.warning.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.clock,
                              color: TColors.warning,
                              size: 20,
                            ),
                            const SizedBox(width: TSizes.sm),
                            Text(
                              '${orders.length} Processing Order${orders.length == 1 ? '' : 's'}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: TColors.warning,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: TSizes.spaceBtwSections),

                      // Orders List
                      Expanded(
                        child: ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final orderData =
                                orders[index].data() as Map<String, dynamic>;

                            return OrderHistoryWidget(
                              orderId: orderData['orderId'] ?? orders[index].id,
                              shoeImage: orderData['shoeImage'] ?? '',
                              shoeName: orderData['shoeName'] ?? 'Unknown Shoe',
                              shoePrice: (orderData['shoePrice'] ?? 0.0)
                                  .toDouble(),
                              quantity: orderData['quantity'] ?? 1,
                              shoeSizes: orderData['shoeSizes'] ?? 'N/A',
                              createdAt:
                                  (orderData['createdAt'] as Timestamp?)
                                      ?.toDate() ??
                                  DateTime.now(),
                              delivered:
                                  false, // Always false for processing orders
                              processing: true, // Always true for this screen
                              onTap: () {
                                _showOrderDetails(context, orderData, isDark);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(TSizes.xl),
              decoration: BoxDecoration(
                color: TColors.warning.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: TColors.warning.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Icon(Iconsax.clock, size: 80, color: TColors.warning),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Text(
              'No Processing Orders',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? TColors.white : TColors.dark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Container(
              padding: const EdgeInsets.all(TSizes.md),
              decoration: BoxDecoration(
                color: isDark ? TColors.darkContainer : TColors.lightContainer,
                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                border: Border.all(
                  color: isDark
                      ? TColors.darkGrey
                      : TColors.grey.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'You don\'t have any orders being processed right now.\nYour orders will appear here once they\'re being prepared.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? TColors.darkGrey : TColors.darkGrey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [TColors.newBlue, TColors.newBlue.withOpacity(0.8)],
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
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Iconsax.shop, color: TColors.white),
                label: Text(
                  'Start Shopping',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: TColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.xl,
                    vertical: TSizes.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(TSizes.xl),
              decoration: BoxDecoration(
                color: TColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: TColors.error.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Icon(Iconsax.warning_2, size: 80, color: TColors.error),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: TColors.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Container(
              padding: const EdgeInsets.all(TSizes.md),
              decoration: BoxDecoration(
                color: isDark ? TColors.darkContainer : TColors.lightContainer,
                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                border: Border.all(
                  color: TColors.error.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'Unable to load your processing orders.\nPlease check your connection and try again.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? TColors.darkGrey : TColors.darkGrey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [TColors.error, TColors.error.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                boxShadow: [
                  BoxShadow(
                    color: TColors.error.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Refresh the page by rebuilding
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AccountProccessinngOrderScreen(),
                    ),
                  );
                },
                icon: const Icon(Iconsax.refresh, color: TColors.white),
                label: Text(
                  'Try Again',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: TColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.xl,
                    vertical: TSizes.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(
    BuildContext context,
    Map<String, dynamic> orderData,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: isDark ? TColors.dark : TColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(TSizes.cardRadiusLg),
            topRight: Radius.circular(TSizes.cardRadiusLg),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TColors.darkGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Header with Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Details',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? TColors.white : TColors.dark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.sm,
                      vertical: TSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          TColors.warning.withOpacity(0.15),
                          TColors.warning.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                      border: Border.all(
                        color: TColors.warning.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Iconsax.clock, color: TColors.warning, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Processing',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: TColors.warning,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Order Information
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDetailRow(
                        'Order ID',
                        '#${(orderData['orderId'] ?? 'N/A').toString().toUpperCase()}',
                        isDark,
                      ),
                      _buildDetailRow(
                        'Shoe Name',
                        orderData['shoeName'] ?? 'N/A',
                        isDark,
                      ),
                      _buildDetailRow(
                        'Price',
                        '\$${(orderData['shoePrice'] ?? 0.0).toStringAsFixed(2)}',
                        isDark,
                      ),
                      _buildDetailRow(
                        'Quantity',
                        '${orderData['quantity'] ?? 1} items',
                        isDark,
                      ),
                      _buildDetailRow(
                        'Size',
                        orderData['shoeSizes'] ?? 'N/A',
                        isDark,
                      ),
                      _buildDetailRow(
                        'Total Amount',
                        '\$${((orderData['shoePrice'] ?? 0.0) * (orderData['quantity'] ?? 1)).toStringAsFixed(2)}',
                        isDark,
                      ),
                      _buildDetailRow(
                        'Order Date',
                        (orderData['createdAt'] as Timestamp?)
                                ?.toDate()
                                .toString()
                                .split(' ')[0] ??
                            'N/A',
                        isDark,
                      ),
                      _buildDetailRow('Status', 'Processing 🕒', isDark),
                    ],
                  ),
                ),
              ),

              // Close Button
              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.newBlue,
                    foregroundColor: TColors.white,
                    padding: const EdgeInsets.symmetric(vertical: TSizes.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: TColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.sm),
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.lightContainer,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        border: Border.all(
          color: isDark
              ? TColors.darkGrey.withOpacity(0.2)
              : TColors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/widget/order_history_widget.dart';

class DeliveredOrdersScreen extends StatelessWidget {
  const DeliveredOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Delivered Orders'),
        ),
        body: Center(
          child: Text(
            'Please log in to view your orders',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delivered Orders',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
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
              'Your Delivered Orders',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? TColors.white : TColors.dark,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Text(
              'Track and review your completed orders',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? TColors.darkGrey : TColors.darkGrey,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Orders List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('shoeOrders')
                    .where('buyerId', isEqualTo: user.uid)
                    .where('delivered', isEqualTo: true)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: TColors.newBlue,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return _buildErrorState(context, isDark);
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState(context, isDark);
                  }

                  final orders = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final orderData = orders[index].data() as Map<String, dynamic>;
                      
                      return OrderHistoryWidget(
                        orderId: orderData['orderId'] ?? orders[index].id,
                        status: 'delivered',
                        totalPrice: (orderData['shoePrice'])*orderData['quantity'].toDouble(),
                        itemCount: orderData.length ?? 1,
                        orderDate: (orderData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
                        items: orderData['items'],
                        additionalData: orderData,
                        onTap: () {
                          _showOrderDetails(context, orderData, isDark);
                        },
                      );
                    },
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(TSizes.xl),
            decoration: BoxDecoration(
              color: TColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.box_tick,
              size: 80,
              color: TColors.success,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          Text(
            'No Delivered Orders Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? TColors.white : TColors.dark,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            'You don\'t have any delivered orders yet.\nStart shopping to see your orders here!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? TColors.darkGrey : TColors.darkGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Iconsax.shop),
            label: const Text('Start Shopping'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.newBlue,
              foregroundColor: TColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.xl,
                vertical: TSizes.md,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.warning_2,
            size: 80,
            color: TColors.error,
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: TColors.error,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            'Unable to load your delivered orders.\nPlease try again later.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? TColors.darkGrey : TColors.darkGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> orderData, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: isDark ? TColors.dark : TColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(TSizes.cardRadiusLg),
            topRight: Radius.circular(TSizes.cardRadiusLg),
          ),
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
              
              // Order Details Header
              Text(
                'Order Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? TColors.white : TColors.dark,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              
              // Order Information
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDetailRow('Order ID', '#${(orderData['orderId'] ?? 'N/A').toString().substring(0, 8).toUpperCase()}', isDark),
                      _buildDetailRow('Status', 'Delivered ✅', isDark),
                      _buildDetailRow('Total Price', '\$${(orderData['totalPrice'] ?? 0.0).toStringAsFixed(2)}', isDark),
                      _buildDetailRow('Items Count', '${(orderData['items'] as List?)?.length ?? 1} products', isDark),
                      _buildDetailRow('Order Date', (orderData['orderDate'] as Timestamp?)?.toDate().toString().split(' ')[0] ?? 'N/A', isDark),
                      // Add more details as needed
                    ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? TColors.darkGrey : TColors.darkGrey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? TColors.white : TColors.dark,
            ),
          ),
        ],
      ),
    );
  }
}
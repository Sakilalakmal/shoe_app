import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/widget/order_history_widget.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order History'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.warning_2,
                size: 80,
                color: TColors.error,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                'Please log in to view your orders',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: TColors.error,
                ),
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
          'Order History',
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: TColors.newBlue,
          unselectedLabelColor: isDark ? TColors.darkGrey : TColors.darkGrey,
          indicatorColor: TColors.newBlue,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          tabs: const [
            Tab(
              icon: Icon(Iconsax.clock),
              text: 'Processing',
            ),
            Tab(
              icon: Icon(Iconsax.tick_circle),
              text: 'Delivered',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Processing Orders Tab
          _ProcessingOrdersTab(userId: user.uid, isDark: isDark),
          // Delivered Orders Tab
          _DeliveredOrdersTab(userId: user.uid, isDark: isDark),
        ],
      ),
    );
  }
}

// Processing Orders Tab Widget
class _ProcessingOrdersTab extends StatelessWidget {
  final String userId;
  final bool isDark;

  const _ProcessingOrdersTab({
    required this.userId,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('shoeOrders')
          .where('buyerId', isEqualTo: userId)
          .where('processing', isEqualTo: true)
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
          return _buildErrorState(context, 'processing orders', isDark);
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
            context, 
            'processing', 
            isDark,
            'No Processing Orders',
            'You don\'t have any processing orders yet.\nYour orders will appear here once they\'re being prepared.',
            Iconsax.clock,
            TColors.warning,
          );
        }

        final orders = snapshot.data!.docs;

        return Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Text(
                'Processing Orders (${orders.length})',
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

              // Orders List
              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final orderData = orders[index].data() as Map<String, dynamic>;
                    
                    return OrderHistoryWidget(
                      orderId: orderData['orderId'] ?? orders[index].id,
                      shoeImage: orderData['shoeImage'] ?? '',
                      shoeName: orderData['shoeName'] ?? 'Unknown Shoe',
                      shoePrice: (orderData['shoePrice'] ?? 0.0).toDouble(),
                      quantity: orderData['quantity'] ?? 1,
                      shoeSizes: orderData['shoeSizes'] ?? 'N/A',
                      createdAt: (orderData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
                      delivered: orderData['delivered'] ?? false,
                      processing: orderData['processing'] ?? true,
                      onTap: () {
                        // Handle order tap - can navigate to order details
                        _showOrderDetails(context, orderData, isDark);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Delivered Orders Tab Widget
class _DeliveredOrdersTab extends StatelessWidget {
  final String userId;
  final bool isDark;

  const _DeliveredOrdersTab({
    required this.userId,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('shoeOrders')
          .where('buyerId', isEqualTo: userId)
          .where('delivered', isEqualTo: true)
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
          return _buildErrorState(context, 'delivered orders', isDark);
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
            context,
            'delivered',
            isDark,
            'No Delivered Orders',
            'You don\'t have any delivered orders yet.\nCompleted orders will appear here.',
            Iconsax.box_tick,
            TColors.success,
          );
        }

        final orders = snapshot.data!.docs;

        return Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Text(
                'Delivered Orders (${orders.length})',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? TColors.white : TColors.dark,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              Text(
                'Your successfully completed orders',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? TColors.darkGrey : TColors.darkGrey,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Orders List
              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final orderData = orders[index].data() as Map<String, dynamic>;
                    
                    return OrderHistoryWidget(
                      orderId: orderData['orderId'] ?? orders[index].id,
                      shoeImage: orderData['shoeImage'] ?? '',
                      shoeName: orderData['shoeName'] ?? 'Unknown Shoe',
                      shoePrice: (orderData['shoePrice'] ?? 0.0).toDouble(),
                      quantity: orderData['quantity'] ?? 1,
                      shoeSizes: orderData['shoeSizes'] ?? 'N/A',
                      createdAt: (orderData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
                      delivered: orderData['delivered'] ?? true,
                      processing: orderData['processing'] ?? false,
                      onTap: () {
                        // Handle order tap - can navigate to order details
                        _showOrderDetails(context, orderData, isDark);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Helper Functions
Widget _buildEmptyState(
  BuildContext context,
  String type,
  bool isDark,
  String title,
  String subtitle,
  IconData icon,
  Color iconColor,
) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(TSizes.xl),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 80,
              color: iconColor,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? TColors.white : TColors.dark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            subtitle,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TSizes.buttonRadius),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildErrorState(BuildContext context, String type, bool isDark) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
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
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            'Unable to load your $type.\nPlease check your connection and try again.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? TColors.darkGrey : TColors.darkGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          ElevatedButton.icon(
            onPressed: () {
              // Trigger rebuild by changing state
            },
            icon: const Icon(Iconsax.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.error,
              foregroundColor: TColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.xl,
                vertical: TSizes.md,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void _showOrderDetails(BuildContext context, Map<String, dynamic> orderData, bool isDark) {
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
                    _buildDetailRow('Order ID', '#${(orderData['orderId'] ?? 'N/A').toString().toUpperCase()}', isDark),
                    _buildDetailRow('Shoe Name', orderData['shoeName'] ?? 'N/A', isDark),
                    _buildDetailRow('Price', '\$${(orderData['shoePrice'] ?? 0.0).toStringAsFixed(2)}', isDark),
                    _buildDetailRow('Quantity', '${orderData['quantity'] ?? 1}', isDark),
                    _buildDetailRow('Size', orderData['shoeSizes'] ?? 'N/A', isDark),
                    _buildDetailRow('Status', (orderData['delivered'] == true) ? 'Delivered ✅' : 'Processing 🕒', isDark),
                    _buildDetailRow('Order Date', (orderData['createdAt'] as Timestamp?)?.toDate().toString().split(' ')[0] ?? 'N/A', isDark),
                    _buildDetailRow('Total Amount', '\$${((orderData['shoePrice'] ?? 0.0) * (orderData['quantity'] ?? 1)).toStringAsFixed(2)}', isDark),
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
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? TColors.white : TColors.dark,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}
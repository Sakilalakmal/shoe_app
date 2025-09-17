import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/components/notify_message/motion_toast.dart';

class EarningScreen extends StatelessWidget {
  const EarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    CollectionReference vendors = FirebaseFirestore.instance.collection('vendors');

    final Stream<QuerySnapshot> _vendorStream = FirebaseFirestore.instance
        .collection('shoeOrders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return FutureBuilder<DocumentSnapshot>(
      future: vendors.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState(context, "Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return _buildErrorState(context, "Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  // Custom App Bar with gradient
                  _buildAppBar(context, data, isDark),
                  
                  // Main Content with StreamBuilder
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _vendorStream,
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return _buildErrorState(context, "Something went wrong");
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(color: TColors.newBlue),
                          );
                        }

                        // Calculate totals
                        double totalOrder = 0.0;
                        int completedOrders = 0;
                        int pendingOrders = 0;
                        
                        for (var orderItem in snapshot.data!.docs) {
                          totalOrder += (orderItem['shoePrice'] ?? 0) * (orderItem['quantity'] ?? 1);
                          if (orderItem['delivered'] == true) {
                            completedOrders++;
                          } else {
                            pendingOrders++;
                          }
                        }

                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(TSizes.defaultSpace),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Summary section
                              Text(
                                "Earnings Summary",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? TColors.white : TColors.black,
                                ),
                              ),
                              
                              const SizedBox(height: TSizes.spaceBtwItems),
                              
                              // Main earnings card
                              _buildMainEarningsCard(context, totalOrder, isDark),
                              
                              const SizedBox(height: TSizes.spaceBtwItems),
                              
                              // Stats row
                              Row(
                                children: [
                                  // Orders card
                                  Expanded(
                                    child: _buildStatsCard(
                                      context, 
                                      "Total Orders",
                                      snapshot.data!.docs.length.toString(),
                                      Iconsax.box,
                                      TColors.newBlue,
                                      isDark,
                                    ),
                                  ),
                                  const SizedBox(width: TSizes.spaceBtwItems),
                                  // Completed orders card
                                  Expanded(
                                    child: _buildStatsCard(
                                      context, 
                                      "Completed",
                                      completedOrders.toString(),
                                      Iconsax.tick_circle,
                                      TColors.success,
                                      isDark,
                                    ),
                                  ),
                                  const SizedBox(width: TSizes.spaceBtwItems),
                                  // Pending orders card
                                  Expanded(
                                    child: _buildStatsCard(
                                      context, 
                                      "Pending",
                                      pendingOrders.toString(),
                                      Iconsax.timer,
                                      TColors.warning,
                                      isDark,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: TSizes.spaceBtwSections),
                              
                              // Recent transactions section
                              Text(
                                "Recent Transactions",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? TColors.white : TColors.black,
                                ),
                              ),
                              
                              const SizedBox(height: TSizes.spaceBtwItems),
                              
                              // Transactions list
                              snapshot.data!.docs.isNotEmpty
                                ? _buildRecentTransactionsList(context, snapshot.data!.docs, isDark)
                                : _buildEmptyState(context, "No transactions yet", isDark),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: TColors.newBlue,
          ),
        );
      },
    );
  }
  
  // Custom App Bar with Gradient Background
  Widget _buildAppBar(BuildContext context, Map<String, dynamic> data, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultSpace,
        vertical: TSizes.md,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
              ? [TColors.newBlue, TColors.newBlue.withOpacity(0.8)]
              : [TColors.newBlue, TColors.newBlue.withOpacity(0.8)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(TSizes.cardRadiusLg),
          bottomRight: Radius.circular(TSizes.cardRadiusLg),
        ),
        boxShadow: [
          BoxShadow(
            color: TColors.newBlue.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: TColors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundColor: TColors.primary,
              radius: 20,
              child: Text(
                data['fullName']?[0]?.toUpperCase() ?? 'V',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: TColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: TSizes.md),
          
          // Welcome Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome back,',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: TColors.white.withOpacity(0.8),
                ),
              ),
              Text(
                data['fullName'] ?? 'Vendor',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: TColors.white,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          
          const Spacer(),
          
          // Logout Button
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              AppToast.success(context, "Successfully logged out");
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TColors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.logout,
                color: TColors.white,
                size: TSizes.iconSm,
              ),
            ),
            iconSize: TSizes.iconMd,
          ),
        ],
      ),
    );
  }
  
  // Main Earnings Card Widget
  Widget _buildMainEarningsCard(BuildContext context, double amount, bool isDark) {
    final formatter = NumberFormat.currency(symbol: '\$');
    
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TColors.newBlue,
            TColors.newBlue.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: TColors.newBlue.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Earnings',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: TColors.white.withOpacity(0.8),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                ),
                child: const Icon(
                  Iconsax.dollar_circle,
                  color: TColors.white,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          
          Text(
            formatter.format(amount),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: TColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          
          // Order progress indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.7, // Placeholder value
              backgroundColor: TColors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(TColors.white),
              minHeight: 6,
            ),
          ),
          
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          
          Text(
            'Last updated: ${DateFormat('MMM d, yyyy').format(DateTime.now())}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: TColors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
  
  // Stats Card Widget
  Widget _buildStatsCard(BuildContext context, String title, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        boxShadow: [
          BoxShadow(
            color: TColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const Spacer(),
              Icon(
                Iconsax.arrow_right_3,
                color: isDark ? TColors.darkGrey : TColors.darkGrey,
                size: 16,
              ),
            ],
          ),
          
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? TColors.white : TColors.black,
            ),
          ),
          
          const SizedBox(height: 2),
          
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? TColors.darkGrey : TColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
  
  // Recent Transactions List
  Widget _buildRecentTransactionsList(BuildContext context, List<QueryDocumentSnapshot> transactions, bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length > 5 ? 5 : transactions.length, // Show only 5 most recent
      itemBuilder: (context, index) {
        final transaction = transactions[index].data() as Map<String, dynamic>;
        final amount = (transaction['shoePrice'] ?? 0) * (transaction['quantity'] ?? 1);
        final date = (transaction['createdAt'] as Timestamp).toDate();
        final isDelivered = transaction['delivered'] ?? false;
        
        return Container(
          margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
          padding: const EdgeInsets.all(TSizes.md),
          decoration: BoxDecoration(
            color: isDark ? TColors.darkContainer : TColors.white,
            borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
            boxShadow: [
              BoxShadow(
                color: TColors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                child: Image.network(
                  transaction['shoeImage'] ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 50,
                    height: 50,
                    color: TColors.grey.withOpacity(0.2),
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: TColors.darkGrey,
                      size: 20,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: TSizes.md),
              
              // Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction['shoeName'] ?? 'Unknown Product',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Iconsax.calendar,
                          size: 12,
                          color: TColors.darkGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d, yyyy').format(date),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Amount and status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TColors.newBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isDelivered
                          ? TColors.success.withOpacity(0.1)
                          : TColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      isDelivered ? 'Completed' : 'Pending',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isDelivered ? TColors.success : TColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Error State Widget
  Widget _buildErrorState(BuildContext context, String message) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.warning_2,
              size: 60,
              color: TColors.error,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  // Empty State Widget
  Widget _buildEmptyState(BuildContext context, String message, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        border: Border.all(
          color: isDark ? TColors.darkContainer : TColors.grey.withOpacity(0.1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.document,
            size: 48,
            color: TColors.darkGrey.withOpacity(0.5),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: TColors.darkGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
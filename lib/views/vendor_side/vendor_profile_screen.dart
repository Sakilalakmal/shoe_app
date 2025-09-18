import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/vendor_side/upload_screen.dart';

class VendorProfileScreen extends StatelessWidget {
  const VendorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('vendors')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, vendorSnapshot) {
            if (vendorSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: TColors.newBlue),
              );
            }

            if (vendorSnapshot.hasError || !vendorSnapshot.hasData || !vendorSnapshot.data!.exists) {
              return _buildErrorState(context, "Unable to load profile", isDark);
            }

            final vendorData = vendorSnapshot.data!.data() as Map<String, dynamic>;

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('shoeOrders')
                  .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, ordersSnapshot) {
                // Calculate order statistics
                int totalOrders = 0;
                int pendingOrders = 0;
                int deliveredOrders = 0;

                if (ordersSnapshot.hasData) {
                  totalOrders = ordersSnapshot.data!.docs.length;
                  for (var order in ordersSnapshot.data!.docs) {
                    final orderData = order.data() as Map<String, dynamic>;
                    if (orderData['delivered'] == true) {
                      deliveredOrders++;
                    } else {
                      pendingOrders++;
                    }
                  }
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header Section
                      _buildProfileHeader(context, vendorData, isDark),
                      
                      const SizedBox(height: TSizes.spaceBtwSections),
                      
                      // Upload Section
                      _buildUploadSection(context, isDark),
                      
                      const SizedBox(height: TSizes.spaceBtwSections),
                      
                      // Overview Section
                      _buildOverviewSection(context, totalOrders, pendingOrders, deliveredOrders, isDark),
                      
                      const SizedBox(height: TSizes.spaceBtwSections),
                      
                      // Logout Button
                      _buildLogoutButton(context, isDark),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Profile Header Widget
  Widget _buildProfileHeader(BuildContext context, Map<String, dynamic> vendorData, bool isDark) {
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
            color: TColors.newBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: TColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: TColors.lightContainer,
              child: Text(
                (vendorData['fullName'] ?? 'V')[0].toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: TColors.newBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: TSizes.spaceBtwItems),
          
          // Vendor Name
          Text(
            vendorData['fullName'] ?? 'Unknown Vendor',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: TColors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          
          // Vendor Email
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.md,
              vertical: TSizes.sm,
            ),
            decoration: BoxDecoration(
              color: TColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.sms,
                  color: TColors.white,
                  size: 16,
                ),
                const SizedBox(width: TSizes.sm),
                Text(
                  vendorData['email'] ?? 'No email',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: TColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Upload Section Widget
  Widget _buildUploadSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TColors.newBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                ),
                child: Icon(
                  Iconsax.box_add,
                  color: TColors.newBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: TSizes.sm),
              Text(
                "Drop Your Shoes Here",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? TColors.white : TColors.textPrimary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: TSizes.spaceBtwItems),
          
          // Description
          Text(
            "Upload your latest shoe collection and start selling to customers worldwide.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: TSizes.spaceBtwItems),
          
          // Upload Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return UploadScreen();
                }));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.newBlue,
                foregroundColor: TColors.white,
                padding: const EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.document_upload5, size: 20),
                  const SizedBox(width: TSizes.sm),
                  Text(
                    "Upload New Product",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Overview Section Widget
  Widget _buildOverviewSection(BuildContext context, int totalOrders, int pendingOrders, int deliveredOrders, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Row(
          children: [
            Icon(
              Iconsax.chart_1,
              color: TColors.newBlue,
              size: 20,
            ),
            const SizedBox(width: TSizes.sm),
            Text(
              "Your Overview",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? TColors.white : TColors.textPrimary,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: TSizes.spaceBtwItems),
        
        // Stats Cards Row
        Row(
          children: [
            // Total Orders Card
            Expanded(
              child: _buildStatsCard(
                context,
                "Total Orders",
                totalOrders.toString(),
                Iconsax.box,
                TColors.newBlue,
                isDark,
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            
            // Pending Orders Card
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
            const SizedBox(width: TSizes.spaceBtwItems),
            
            // Delivered Orders Card
            Expanded(
              child: _buildStatsCard(
                context,
                "Delivered",
                deliveredOrders.toString(),
                Iconsax.tick_circle,
                TColors.success,
                isDark,
              ),
            ),
          ],
        ),
      ],
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          
          const SizedBox(height: TSizes.spaceBtwItems),
          
          // Value
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? TColors.white : TColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Logout Button Widget
  Widget _buildLogoutButton(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        border: Border.all(
          color: TColors.red,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Iconsax.logout,
            color: TColors.red,
            size: 32,
          ),
          
          const SizedBox(height: TSizes.spaceBtwItems),
          
          Text(
            "Ready to Sign Out?",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? TColors.white : TColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          
          Text(
            "You can always sign back in anytime",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: TSizes.spaceBtwItems),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                _showLogoutDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.red,
                foregroundColor: TColors.white,
                padding: const EdgeInsets.symmetric(vertical: TSizes.buttonHeight , horizontal: TSizes.defaultSpace),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.logout_1, size: 20),
                  const SizedBox(width: TSizes.sm),
                  Text(
                    "Sign Out",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        ),
        title: Text(
          "Sign Out",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Are you sure you want to sign out?",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: TColors.darkGrey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Successfully signed out"),
                  backgroundColor: TColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.red,
              foregroundColor: TColors.white,
            ),
            child: Text("Sign Out"),
          ),
        ],
      ),
    );
  }

  // Error State Widget
  Widget _buildErrorState(BuildContext context, String message, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.warning_2,
            size: 60,
            color: TColors.red,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: TColors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
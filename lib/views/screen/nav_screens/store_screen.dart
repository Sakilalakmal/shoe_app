import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/inner_vendor_store.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    final Stream<QuerySnapshot> _vendorsStream = FirebaseFirestore.instance
        .collection('vendors')
        .snapshots();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Only Vendors Section remains
              _buildVendorsSection(context, _vendorsStream, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // Vendors Section
  Widget _buildVendorsSection(BuildContext context, Stream<QuerySnapshot> vendorsStream, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Our Vendors",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? TColors.white : TColors.textPrimary,
                  ),
                ),
                Text(
                  "Discover trusted sellers",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
                  ),
                ),
              ],
            ),
            Icon(
              Iconsax.shop,
              color: TColors.newBlue,
              size: TSizes.iconMd,
            ),
          ],
        ),
        
        const SizedBox(height: TSizes.spaceBtwItems),
        
        // Vendors List
        StreamBuilder<QuerySnapshot>(
          stream: vendorsStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return _buildErrorState(context, "Something went wrong", isDark);
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: TColors.newBlue,
                ),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return _buildEmptyState(context, "No vendors available", isDark);
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final vendor = snapshot.data!.docs[index];
                final vendorData = vendor.data() as Map<String, dynamic>;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
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
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InnerVendorStore(
                            vendorId: vendorData['uid'] ?? '',
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.md),
                      child: Row(
                        children: [
                          // Vendor Avatar
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [TColors.newBlue, TColors.newBlue.withOpacity(0.7)],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: isDark ? TColors.darkContainer : TColors.white,
                              child: Text(
                                (vendorData['fullName'] ?? 'V')[0].toUpperCase(),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: TColors.newBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: TSizes.md),
                          
                          // Vendor Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vendorData['fullName'] ?? 'Unknown Vendor',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Iconsax.verify5,
                                      color: TColors.success,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Verified Seller",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: TColors.success,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  vendorData['email'] ?? 'No email',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          
                          // Arrow Icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: TColors.newBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                            ),
                            child: Icon(
                              Iconsax.arrow_right_3,
                              color: TColors.newBlue,
                              size: TSizes.iconSm,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // Error State Widget
  Widget _buildErrorState(BuildContext context, String message, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.warning_2,
            size: 48,
            color: TColors.error,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: TColors.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
          color: isDark ? TColors.borderDark : TColors.borderLight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.shop,
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
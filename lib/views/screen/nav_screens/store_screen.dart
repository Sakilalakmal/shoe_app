import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/inner_vendor_store.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/widget/vendro_card.dart';

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
            children: [_buildVendorsSection(context, _vendorsStream, isDark)],
          ),
        ),
      ),
    );
  }

  Widget _buildVendorsSection(
    BuildContext context,
    Stream<QuerySnapshot> vendorsStream,
    bool isDark,
  ) {
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
                    color: isDark
                        ? TColors.textDarkSecondary
                        : TColors.textSecondary,
                  ),
                ),
              ],
            ),
            Icon(Iconsax.shop, color: TColors.newBlue, size: TSizes.iconMd),
          ],
        ),

        const SizedBox(height: TSizes.spaceBtwItems),

        // Vendors List using VendorCard
        StreamBuilder<QuerySnapshot>(
          stream: vendorsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return _buildErrorState(
                    context,
                    "Something went wrong",
                    isDark,
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: TColors.newBlue),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState(
                    context,
                    "No vendors available",
                    isDark,
                  );
                }

                return SizedBox(
                  height: TSizes.vendorCardHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final vendor = snapshot.data!.docs[index];
                      final vendorData = vendor.data() as Map<String, dynamic>;

                      // Use the VendorCard widget
                      return VendorCard(
                        fullName: vendorData['fullName'] ?? 'Unknown Vendor',
                        email: vendorData['email'] ?? 'No email',
                        storeImage: vendorData['storeImage'],
                        city: vendorData['city'],
                        locality: vendorData['locality'],
                        streetAddress: vendorData['streetAddress'],
                        isVerified: true,
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
                      );
                    },
                  ),
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
        color: isDark ? TColors.darkerGrey : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.warning_2, size: 48, color: TColors.error),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: TColors.error),
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
        color: isDark ? TColors.darkerGrey : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        border: Border.all(color: isDark ? TColors.darkGrey : TColors.grey),
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
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: TColors.darkGrey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

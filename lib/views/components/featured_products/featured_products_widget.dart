import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/components/product_card_widget/product_card_widget.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/product_details_screen.dart';

class FeaturedProductsWidget extends StatelessWidget {
  const FeaturedProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('shoes')
          .where('featured', isEqualTo: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState(context, isDark);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState(context, isDark);
        }

        if (snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(context, isDark);
        }

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
                      "Featured Products",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? TColors.white : TColors.textPrimary,
                      ),
                    ),
                    Text(
                      "Handpicked for you",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? TColors.textDarkSecondary
                            : TColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(TSizes.xs),
                  decoration: BoxDecoration(
                    color: TColors.newBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusXs),
                  ),
                  child: Icon(
                    Iconsax.star1,
                    color: TColors.newBlue,
                    size: TSizes.iconMd,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: TSizes.spaceBtwItems),
            
            // Featured Products List
            SizedBox(
              height: 300, // Adjust height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final shoe = snapshot.data!.docs[index];
                  final shoeData = shoe.data() as Map<String, dynamic>;
                  
                  return ProductCardWidget(
                    imageUrl: shoeData['shoeImages']?.isNotEmpty == true 
                        ? shoeData['shoeImages'][0] 
                        : '',
                    title: shoeData['shoeName'] ?? 'Unknown Shoe',
                    brand: shoeData['brandName'] ?? 'Unknown Brand',
                    price: (shoeData['shoePrice'] ?? 0).toInt(),
                    discount: shoeData['discount'] ?? 0,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            productData: shoeData,
                          ),
                        ),
                      );
                    },
                    showFavorite: true,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context, bool isDark) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: isDark ? TColors.darkerGrey : TColors.lightContainer,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: TColors.newBlue,
              strokeWidth: 3,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              'Loading featured products...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, bool isDark) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkerGrey : TColors.lightContainer,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        border: Border.all(
          color: TColors.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
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
              'Failed to load featured products',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: TColors.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.xs),
            Text(
              'Please check your connection and try again',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkerGrey : TColors.lightContainer,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        border: Border.all(
          color: isDark ? TColors.darkGrey : TColors.grey,
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.star,
              size: 48,
              color: TColors.darkGrey.withOpacity(0.5),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              'No featured products yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: TColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.xs),
            Text(
              'Check back later for new featured items',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
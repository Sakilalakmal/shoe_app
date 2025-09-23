import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/components/circular_widget/circular_container.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/product_details_screen.dart';

class ProductCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String brand;
  final int price;
  final int discount;
  final VoidCallback? onTap;
  final bool showFavorite;

  const ProductCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.brand,
    required this.price,
    required this.discount,
    this.onTap,
    this.showFavorite = true,
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        margin: const EdgeInsets.only(right: TSizes.spaceBtwItems),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: TColors.darkGrey.withOpacity(0.1),
              blurRadius: 50,
              spreadRadius: 7,
              offset: const Offset(1, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? TColors.dark : TColors.white,
        ),
        child: Column(
          children: [
            // --- Image Section ---
            CircularContainer(
              radius: TSizes.productImageRadius,
              height: 160, // Adjusted image height
              padding: const EdgeInsets.all(TSizes.sm),
              child: Stack(
                children: [
                  // Background color
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: dark
                            ? TColors.darkerGrey.withOpacity(0.9)
                            : TColors.lightContainer,
                        borderRadius: BorderRadius.circular(
                          TSizes.productImageRadius,
                        ),
                      ),
                    ),
                  ),
                  // Main Image
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(TSizes.productImageRadius),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  // Sale/Discount tag
                  if (discount > 0)
                    Positioned(
                      top: 8,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.xs,
                          vertical: TSizes.xs / 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(TSizes.xs),
                          color: TColors.borderPrimary.withOpacity(0.8),
                        ),
                        child: Text(
                          "${discount}%",
                          style: Theme.of(context)
                              .textTheme.labelSmall!
                              .apply(color: TColors.black),
                        ),
                      ),
                    ),
                  // Favorite icon
                  if (showFavorite)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: FavoriteIcon(dark: dark),
                    ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems), // Space between image and text

            // --- Product Info Section ---
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2), // Reduced space

                    // Brand and Verification Icon Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            brand,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(width: TSizes.sm / 2),
                        Icon(
                          Iconsax.verify5,
                          color: TColors.facebookBackgroundColor,
                          size: TSizes.iconXs,
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2), // Reduced space

                    // Price Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$$price",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ,
                        ),
                        // Add button
                        Container(
                          decoration: BoxDecoration(
                            color: dark ? TColors.white : TColors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(TSizes.cardRadiusMd),
                              bottomRight: Radius.circular(
                                TSizes.productImageRadius,
                              ),
                            ),
                          ),
                          child: IconButton(
                            onPressed: (){},
                            icon:Icon(Iconsax.add,size: TSizes.iconLg,
                            color: dark ? TColors.black : TColors.white,),
                            
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({super.key, required this.dark});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: dark
            ? TColors.black.withOpacity(0.9)
            : TColors.white.withOpacity(0.4),
      ),
      child: IconButton(
        onPressed: () {},
        icon: const Icon(Iconsax.heart5, color: Colors.redAccent),
      ),
    );
  }
}

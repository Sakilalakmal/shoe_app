import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/components/circular_widget/circular_container.dart';

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
        height: TSizes.productCardHeight, // FIXED: Set explicit height from sizes.dart (300)
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
            // --- Image Section --- REDUCED HEIGHT
            CircularContainer(
              radius: TSizes.productImageRadius,
              height: 160, // REDUCED: From 180 to 160 to save space
              padding: const EdgeInsets.all(TSizes.sm),
              child: Stack(
                children: [
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
                  // Main image
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        TSizes.productImageRadius,
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  // Sale/discount tag - ONLY SHOW IF DISCOUNT > 0
                  if (discount > 0)
                    Positioned(
                      top: 8, // REDUCED: From 10 to 8
                      left: 6, // REDUCED: From 8 to 6
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.xs, // REDUCED: From TSizes.sm
                          vertical: TSizes.xs / 2, // REDUCED: From TSizes.xs
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(TSizes.xs),
                          color: TColors.borderPrimary.withOpacity(0.8),
                        ),
                        child: Text(
                          "${discount}%",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall! // CHANGED: From labelLarge to labelSmall
                              .apply(color: TColors.black),
                        ),
                      ),
                    ),
                  // Favorite icon - SMALLER
                  if (showFavorite)
                    Positioned(
                      top: 4, // REDUCED: From 0 to 4
                      right: 4, // REDUCED: From 0 to 4
                      child: FavoriteIcon(dark: dark),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: TSizes.spaceBtwItems / 2), // REDUCED: From TSizes.spaceBtwItems

            // --- Info Section --- OPTIMIZED
            Expanded( // ADDED: Expanded to prevent overflow
              child: Padding(
                padding: const EdgeInsets.symmetric( // CHANGED: From only left to symmetric
                  horizontal: TSizes.sm,
                  vertical: TSizes.xs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // ADDED: Space distribution
                  children: [
                    // Title and Brand Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith( // CHANGED: From bodyLarge to bodyMedium
                            fontWeight: FontWeight.w600,
                            fontSize: 14, // EXPLICIT: Set smaller font size
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: TSizes.xs / 2), // REDUCED spacing
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                brand,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith( // CHANGED: From bodyMedium to bodySmall
                                  fontSize: 12, // EXPLICIT: Smaller font
                                  color: dark ? TColors.textDarkSecondary : TColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(width: TSizes.xs / 2),
                            Icon(
                              Iconsax.verify5,
                              color: TColors.facebookBackgroundColor,
                              size: 12, // REDUCED: From TSizes.iconXs to explicit 12
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    // Price and Add Button Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "\$$price",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium! // CHANGED: From headlineMedium to titleMedium
                                .copyWith(
                                  fontSize: 16, // REDUCED: From 20 to 16
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Container(
                          width: 28, // EXPLICIT: Set smaller width
                          height: 28, // EXPLICIT: Set smaller height
                          decoration: BoxDecoration(
                            color: dark ? TColors.white : TColors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(TSizes.cardRadiusSm), // REDUCED: From Md to Sm
                              bottomRight: Radius.circular(
                                TSizes.productImageRadius,
                              ),
                            ),
                          ),
                          child: Icon(
                            Iconsax.add,
                            size: 16, // REDUCED: From TSizes.iconLg to 16
                            color: dark ? TColors.black : TColors.white,
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
      width: 32, // EXPLICIT: Set smaller size
      height: 32, // EXPLICIT: Set smaller size
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: dark
            ? TColors.black.withOpacity(0.9)
            : TColors.white.withOpacity(0.4),
      ),
      child: IconButton(
        onPressed: () {},
        padding: EdgeInsets.zero, // ADDED: Remove default padding
        constraints: const BoxConstraints(), // ADDED: Remove default constraints
        icon: Icon(
          Iconsax.heart5, 
          color: Colors.redAccent,
          size: 16, // REDUCED: Smaller icon size
        ),
      ),
    );
  }
}
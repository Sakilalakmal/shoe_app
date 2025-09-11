import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/provider/favorite_provider.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/components/circular_widget/circular_container.dart';
import 'package:shoe_app_assigment/views/components/recommended_products/recommended_products_widget.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = HelperFunctions.isDarkMode(context);
    final wishItemData = ref.watch(favoriteProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Texts.favoriteText,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: ListView.builder(
        itemCount: wishItemData.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          final wishItem = wishItemData.values.toList()[index];
          return Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),
            child: Container(
              width: 180,
              padding: const EdgeInsets.all(1),
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
                  // --- Circular Image Container with fixed background ---
                  CircularContainer(
                    radius: TSizes.productImageRadius,
                    height: 180,
                    padding: const EdgeInsets.all(TSizes.sm),
                    child: Stack(
                      children: [
                        // Force background color to be visible
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

                        // Shoe image
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              TSizes.productImageRadius,
                            ),
                            child: Image.network(
                              wishItem.imageUrl[0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Sale tag
                        Positioned(
                          top: 10,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.sm,
                              vertical: TSizes.xs,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(TSizes.sm),
                              color: TColors.borderPrimary.withOpacity(0.8),
                            ),
                            child: Text(
                              "${wishItem.discount}%",
                              style: Theme.of(context).textTheme.labelLarge!
                                  .apply(color: TColors.black),
                            ),
                          ),
                        ),

                        // Favorite button
                        Positioned(
                          top: 0,
                          right: 0,
                          child: FavoriteIcon(dark: dark),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // --- Product Info ---
                  Padding(
                    padding: const EdgeInsets.only(left: TSizes.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wishItem.shoeName,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems / 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                wishItem
                                    .brandName, // replace later with dynamic if needed
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            const SizedBox(width: TSizes.sm / 2),
                            Flexible(
                              child: Icon(
                                Iconsax.verify5,
                                color: TColors.facebookBackgroundColor,
                                size: TSizes.iconXs,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems / 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //shoe price
                            Text(
                              "\$${wishItem.shoePrice}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineMedium!
                                  .copyWith(fontSize: 20),
                            ),
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
                              child: Icon(
                                Iconsax.add,
                                size: TSizes.iconLg,
                                color: dark ? TColors.black : TColors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

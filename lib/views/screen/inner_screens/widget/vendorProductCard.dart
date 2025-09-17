import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/components/circular_widget/circular_container.dart';
import 'package:shoe_app_assigment/views/components/product_card_widget/product_card_widget.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/product_details_screen.dart';

class vendorProductCard extends StatelessWidget {
  const vendorProductCard({
    super.key,
    required Stream<QuerySnapshot<Object?>> vendorProductStream,
    required this.dark,
  }) : _vendorProductStream = vendorProductStream;

  final Stream<QuerySnapshot<Object?>> _vendorProductStream;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vendor's Stores Screen",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
            stream: _vendorProductStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
    
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: TColors.buttonDisabled,
                  ),
                );
              }
    
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultSpace,
                ),
                child: SizedBox(
                  height: TSizes.productCardHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final productData = snapshot.data!.docs[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ProductDetailsScreen(
                                  productData: productData,
                                );
                              },
                            ),
                          );
                        },
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
                            borderRadius: BorderRadius.circular(
                              TSizes.productImageRadius,
                            ),
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
                                              ? TColors.darkerGrey.withOpacity(
                                                  0.9,
                                                )
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
                                          productData['shoeImages'][0],
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
                                          borderRadius: BorderRadius.circular(
                                            TSizes.sm,
                                          ),
                                          color: TColors.borderPrimary
                                              .withOpacity(0.8),
                                        ),
                                        child: Text(
                                          "${productData['discount']}%",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
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
                                      productData['shoeName'],
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(
                                      height: TSizes.spaceBtwItems / 2,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            productData['brandName'], // replace later with dynamic if needed
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                          ),
                                        ),
                                        const SizedBox(width: TSizes.sm / 2),
                                        Flexible(
                                          child: Icon(
                                            Iconsax.verify5,
                                            color:
                                                TColors.facebookBackgroundColor,
                                            size: TSizes.iconXs,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: TSizes.spaceBtwItems / 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //shoe price
                                        Text(
                                          "\$${productData['shoePrice']}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(fontSize: 20),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: dark
                                                ? TColors.white
                                                : TColors.black,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                TSizes.cardRadiusMd,
                                              ),
                                              bottomRight: Radius.circular(
                                                TSizes.productImageRadius,
                                              ),
                                            ),
                                          ),
                                          child: Icon(
                                            Iconsax.add,
                                            size: TSizes.iconLg,
                                            color: dark
                                                ? TColors.black
                                                : TColors.white,
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
                ),
              );
            },
          ));
  }
}
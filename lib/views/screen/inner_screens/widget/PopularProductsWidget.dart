import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/model/json_model/shoe_model.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/components/circular_widget/circular_container.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/product_details_screen.dart';

class PopularProductsWidget extends StatelessWidget {
  const PopularProductsWidget({super.key});

  // FIXED: Better conversion with proper type handling and null safety
  Map<String, dynamic> _convertShoeToMap(Shoe shoe) {
    return {
      'shoeId': shoe.id ?? 'unknown',
      'shoeName': shoe.name ?? 'Unknown Shoe',
      'brandName': shoe.brandName ?? 'Unknown Brand',
      'shoePrice': shoe.price?.toDouble() ?? 0.0, // Ensure it's double
      'discount': shoe.discount ?? 0,
      'shoeCategory': shoe.category ?? 'Sneakers',
      'quantity': shoe.stock ?? 0,
      'shoeSizes': shoe.sizes ?? [], // Ensure it's List<String>
      'shoeDescription': shoe.description ?? 'No description available',
      'shoeImages': shoe.images ?? ['assets/images/placeholder.png'], // Ensure it's List<String>
      'vendorId': 'local_json', // Required for cart provider
    };
  }

  // Function to load shoes data from local JSON
  Future<List<Shoe>> loadShoesFromJson() async {
    try {
      final String response = await rootBundle.loadString('assets/data/shoes_data.json');
      final List<dynamic> data = json.decode(response);

      print('Loaded JSON data: $data'); // Debug print

      // Convert the JSON data into a list of Shoe objects
      return data.map((item) {
        try {
          return Shoe.fromJson(item);
        } catch (e) {
          print('Error parsing shoe item: $item, Error: $e');
          rethrow;
        }
      }).toList();
    } catch (e) {
      print('Error loading shoes data: $e'); // Debug print
      throw Exception('Failed to load shoes data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return FutureBuilder<List<Shoe>>(
      future: loadShoesFromJson(),  
      builder: (BuildContext context, AsyncSnapshot<List<Shoe>> snapshot) {
        if (snapshot.hasError) {
          print('FutureBuilder error: ${snapshot.error}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.warning_2,
                  size: 64,
                  color: TColors.error,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  'Failed to load products',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: TColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '${snapshot.error}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: TColors.darkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                ElevatedButton(
                  onPressed: () {
                    (context as Element).markNeedsBuild();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: TColors.buttonDisabled),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.box,
                  size: 64,
                  color: TColors.darkGrey,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  'No products available',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: dark ? TColors.white : TColors.dark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
          child: SizedBox(
            height: TSizes.productCardHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final productData = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.only(right: TSizes.spaceBtwItems),
                  child: InkWell(
                    onTap: () async {
                      try {
                        // Convert Shoe object to Map format and navigate
                        final productMap = _convertShoeToMap(productData);
                        
                        print('Navigating with data: $productMap'); // Debug print
                        
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              productData: productMap, // Pass converted Map
                            ),
                          ),
                        );
                      } catch (e) {
                        print('Navigation error: $e');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error opening product details: $e'),
                              backgroundColor: TColors.error,
                            ),
                          );
                        }
                      }
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
                          // --- Circular Image Container ---
                          CircularContainer(
                            radius: TSizes.productImageRadius,
                            height: 180,
                            padding: const EdgeInsets.all(TSizes.sm),
                            child: Stack(
                              children: [
                                // Background
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

                                // Shoe image with better error handling
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      TSizes.productImageRadius,
                                    ),
                                    child: productData.images != null && productData.images!.isNotEmpty 
                                        ? Image.asset(
                                            productData.images![0],
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              print('Image error: $error');
                                              return Container(
                                                color: dark ? TColors.darkerGrey : TColors.lightContainer,
                                                child: Icon(
                                                  Iconsax.image,
                                                  size: 48,
                                                  color: TColors.darkGrey,
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            color: dark ? TColors.darkerGrey : TColors.lightContainer,
                                            child: Icon(
                                              Iconsax.image,
                                              size: 48,
                                              color: TColors.darkGrey,
                                            ),
                                          ),
                                  ),
                                ),

                                // Sale tag with null safety
                                if (productData.discount != null && productData.discount! > 0)
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
                                        color: TColors.borderPrimary.withOpacity(0.8),
                                      ),
                                      child: Text(
                                        "${productData.discount}%",
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

                          // --- Product Info with null safety ---
                          Padding(
                            padding: const EdgeInsets.only(left: TSizes.sm),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productData.name ?? 'Unknown Shoe',
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
                                        productData.brandName ?? 'Unknown Brand',
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
                                    // Shoe price with null safety
                                    Text(
                                      "\$${(productData.price ?? 0).toStringAsFixed(0)}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(fontSize: 20),
                                    ),
                                    // Add to cart button
                                    Container(
                                      decoration: BoxDecoration(
                                        color: dark
                                            ? TColors.white
                                            : TColors.black,
                                        borderRadius: const BorderRadius.only(
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
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// FavoriteIcon widget (same as before)
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
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Added to favorites'),
              backgroundColor: TColors.success,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        icon: const Icon(Iconsax.heart5, color: Colors.redAccent),
      ),
    );
  }
}
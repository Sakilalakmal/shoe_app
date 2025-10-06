import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
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
    
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultSpace,
                  vertical: TSizes.defaultSpace,
                ),
                child: Column(
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
                              "Vendor Products",
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: dark ? TColors.white : TColors.textPrimary,
                              ),
                            ),
                            Text(
                              "Quality shoes from trusted vendors",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: dark
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
                            Iconsax.shop,
                            color: TColors.newBlue,
                            size: TSizes.iconMd,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: TSizes.spaceBtwItems),
                    
                    // Products Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling, let SingleChildScrollView handle it
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 products per row
                        crossAxisSpacing: TSizes.spaceBtwItems,
                        mainAxisSpacing: TSizes.spaceBtwItems,
                        childAspectRatio: 0.7, // Same as featured products
                      ),
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
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: TColors.darkGrey.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                              color: dark ? TColors.dark : TColors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Image Container
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: dark
                                          ? TColors.darkerGrey.withOpacity(0.9)
                                          : TColors.lightContainer,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(TSizes.cardRadiusMd),
                                        topRight: Radius.circular(TSizes.cardRadiusMd),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        // Product Image
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(TSizes.cardRadiusMd),
                                            topRight: Radius.circular(TSizes.cardRadiusMd),
                                          ),
                                          child: Image.network(
                                            productData['shoeImages'][0],
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        
                                        // Discount Badge
                                        if (productData['discount'] != null && productData['discount'] > 0)
                                          Positioned(
                                            top: TSizes.sm,
                                            left: TSizes.sm,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: TSizes.xs,
                                                vertical: TSizes.xs / 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: TColors.error,
                                                borderRadius: BorderRadius.circular(TSizes.sm),
                                              ),
                                              child: Text(
                                                "${productData['discount']}% OFF",
                                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                  color: TColors.white,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        
                                        // Favorite Button
                                        Positioned(
                                          top: TSizes.sm,
                                          right: TSizes.sm,
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: dark
                                                  ? TColors.black.withOpacity(0.8)
                                                  : TColors.white.withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(100),
                                            ),
                                            child: Icon(
                                              Iconsax.heart,
                                              size: 16,
                                              color: TColors.error,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                
                                // Product Info
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(TSizes.sm),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Product Name
                                            Text(
                                              productData['shoeName'],
                                              style: Theme.of(context).textTheme.titleLarge,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            const SizedBox(height: TSizes.xs / 2),
                                            
                                            // Brand Name
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    productData['brandName'],
                                                    style: Theme.of(context).textTheme.bodyMedium,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                const SizedBox(width: TSizes.xs),
                                                Icon(
                                                  Iconsax.verify5,
                                                  color: TColors.newBlue,
                                                  size: 12,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        
                                        // Price and Add Button Row
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                "\$${productData['shoePrice']}",
                                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: TColors.newBlue,
                                                borderRadius: BorderRadius.circular(TSizes.sm),
                                              ),
                                              child: Icon(
                                                Iconsax.add,
                                                size: 16,
                                                color: TColors.white,
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
                      },
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }
}
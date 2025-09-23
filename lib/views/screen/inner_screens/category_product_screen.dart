import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/model/categoryModel/category_models.dart';
import 'package:shoe_app_assigment/provider/cart_provider.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/components/circular_widget/circular_container.dart';
import 'package:shoe_app_assigment/views/components/notify_message/motion_toast.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/product_details_screen.dart';

class CategoryProductScreen extends ConsumerStatefulWidget {
  final CategoryModels categoryModels;

  const CategoryProductScreen({super.key, required this.categoryModels});

  @override
  _CategoryProductScreenState createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends ConsumerState<CategoryProductScreen> {
  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    final _cartProvider = ref.read(cartProvider.notifier);

    final Stream<QuerySnapshot> _categoryProductStream = FirebaseFirestore
        .instance
        .collection('shoes')
        .where('shoeCategory', isEqualTo: widget.categoryModels.categoryName)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.categoryModels.categoryName} Shoes",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: dark ? TColors.dark : TColors.white,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _categoryProductStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.warning_2, size: 64, color: TColors.error),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    'Something went wrong',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: TColors.error),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: TColors.newBlue),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    'Loading ${widget.categoryModels.categoryName} shoes...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.box, size: 64, color: TColors.darkGrey),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    'No ${widget.categoryModels.categoryName} shoes found',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: TColors.darkGrey),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: TSizes.gridViewSpacing,
                crossAxisSpacing: TSizes.gridViewSpacing,
                childAspectRatio:
                    0.65, // ADJUSTED: Better ratio to prevent overflow
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final shoeCategoryData = snapshot.data!.docs[index];

                // INLINE PRODUCT CARD - EXACT SAME AS RECOMMENDED WIDGET
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ProductDetailsScreen(
                            productData: shoeCategoryData,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(
                      1,
                    ), // SAME: as recommended widget
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
                        // --- Image Section --- EXACT SAME
                        CircularContainer(
                          radius: TSizes.productImageRadius,
                          height:
                              140, // REDUCED: From 180 to 140 for grid layout
                          padding: const EdgeInsets.all(TSizes.sm),
                          child: Stack(
                            children: [
                              // Background container
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
                                    shoeCategoryData['shoeImages'][0],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: TColors.lightContainer,
                                          borderRadius: BorderRadius.circular(
                                            TSizes.productImageRadius,
                                          ),
                                        ),
                                        child: Icon(
                                          Iconsax.image,
                                          color: TColors.darkGrey,
                                          size: 32,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Discount badge - SAME
                              Positioned(
                                top:
                                    8, // REDUCED: From 10 to 8 for smaller layout
                                left: 6, // REDUCED: From 8 to 6
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        TSizes.xs, // REDUCED: From TSizes.sm
                                    vertical: TSizes.xs / 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      TSizes.xs,
                                    ),
                                    color: TColors.borderPrimary.withOpacity(
                                      0.8,
                                    ),
                                  ),
                                  child: Text(
                                    "${shoeCategoryData['discount']}%",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall! // CHANGED: From labelLarge to labelSmall
                                        .apply(color: TColors.black),
                                  ),
                                ),
                              ),

                              // Favorite icon - SAME
                              Positioned(
                                top: 5,
                                right: 5,
                                child: _FavoriteIcon(dark: dark),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: TSizes.defaultSpace,
                        ), // REDUCED: From TSizes.spaceBtwItems
                        // --- Product Info --- OPTIMIZED FOR GRID
                        Expanded(
                          // ADDED: Expanded to prevent overflow
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.sm,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // ADDED: Distribute space
                              children: [
                                // Title and Brand Section
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shoeCategoryData['shoeName'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            // CHANGED: From titleLarge
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                14, // EXPLICIT: Smaller font
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: TSizes.xs),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            shoeCategoryData['brandName'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  // CHANGED: From bodyMedium
                                                  fontSize:
                                                      12, // EXPLICIT: Smaller font
                                                  color: dark
                                                      ? TColors
                                                            .textDarkSecondary
                                                      : TColors.textSecondary,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: TSizes.xs),
                                        Icon(
                                          Iconsax.verify5,
                                          color:
                                              TColors.facebookBackgroundColor,
                                          size: TSizes
                                              .iconSm, // REDUCED: From TSizes.iconXs
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Price and Add Button Section
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Price
                                    Flexible(
                                      child: Text(
                                        "\$${shoeCategoryData['shoePrice']}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium! // CHANGED: From headlineMedium
                                            .copyWith(
                                              fontSize:
                                                  16, // REDUCED: From 20 to 16
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),

                                    // Add button
                                    Container(
                                      width: 28, // REDUCED: From default size
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: dark
                                            ? TColors.white
                                            : TColors.black,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                            TSizes.cardRadiusSm,
                                          ), // REDUCED: From Md
                                          bottomRight: Radius.circular(
                                            TSizes.productImageRadius,
                                          ),
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          // Add to cart functionality
                                          _cartProvider.addShoesToCart(
                                            shoeName:
                                                shoeCategoryData['shoeName'],
                                            brandName:
                                                shoeCategoryData['brandName'],
                                            shoePrice:
                                                shoeCategoryData['shoePrice'],
                                            shoeCategory:shoeCategoryData['shoeCategory'],
                                            imageUrl: List<String>.from(
                                              shoeCategoryData['shoeImages'],
                                            ),
                                            quantity: 1,
                                            inStock:
                                                shoeCategoryData['quantity'],
                                            shoeId:
                                                shoeCategoryData['shoeId'],
                                            shoeSizes: shoeCategoryData['shoeSizes'][0],
                                            discount:
                                                shoeCategoryData['discount'],
                                            shoeDescription: shoeCategoryData['shoeDescription'],
                                            vendorId:
                                                shoeCategoryData['vendorId'],
                                          );

                                          AppToast.success(context, "${shoeCategoryData['shoeName']} added to the box ");
                                        },
                                        icon: Icon(
                                          Iconsax.add,
                                          size: TSizes.iconSm,
                                          color: dark
                                              ? TColors.black
                                              : TColors.white,
                                        ),
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
          );
        },
      ),
    );
  }
}

// INLINE FAVORITE ICON WIDGET
class _FavoriteIcon extends StatelessWidget {
  const _FavoriteIcon({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32, // EXPLICIT: Set size
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: dark
            ? TColors.black.withOpacity(0.9)
            : TColors.white.withOpacity(0.4),
      ),
      child: IconButton(
        onPressed: () {
          // Add favorite functionality
        },
        padding: EdgeInsets.zero, // ADDED: Remove default padding
        constraints:
            const BoxConstraints(), // ADDED: Remove default constraints
        icon: Icon(
          Iconsax.heart5,
          color: Colors.redAccent,
          size: 16, // REDUCED: Smaller icon
        ),
      ),
    );
  }
}

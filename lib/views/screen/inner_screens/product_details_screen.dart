import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/provider/cart_provider.dart';
import 'package:shoe_app_assigment/provider/favorite_provider.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/components/categories/category_chip.dart';
import 'package:shoe_app_assigment/views/components/notify_message/motion_toast.dart';
import 'package:shoe_app_assigment/views/components/product_details_image/product_details_top_image_widget.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/widget/read_more_text_widget.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final dynamic productData;

  const ProductDetailsScreen({super.key, required this.productData});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  String? selectedSize;
  @override
  Widget build(BuildContext context) {
    final _cartProvider = ref.read(cartProvider.notifier);
    final _favoriteProvider = ref.read(favoriteProvider.notifier);
    ref.watch(favoriteProvider);

    /// Get the current theme
    final dark = HelperFunctions.isDarkMode(context);

    return Scaffold(
      /// The app bar for the screen
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _favoriteProvider.addShoesToFavorite(
                shoeName: widget.productData['shoeName'],
                shoeId: widget.productData['shoeId'],
                imageUrl: List<String>.from(widget.productData['shoeImages']),
                shoePrice: widget.productData['shoePrice'],
                shoeSizes: List<String>.from(widget.productData['shoeSizes']),
                discount: widget.productData['discount'],
                brandName: widget.productData['brandName'],
              );
            },
            icon:
                _favoriteProvider.favoriteShoeItem.containsKey(
                  widget.productData['shoeId'],
                )
                ? const Icon(Iconsax.heart5, color: TColors.red)
                : Icon(
                    Icons.favorite_border,
                    color: dark ? TColors.white : TColors.dark,
                  ),
          ),
        ],
        title: Text(
          Texts.detailsScreen,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),

      /// The body of the screen
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// The top image for the product
              ProductDetailsTopImageWidget(
                images: widget.productData['shoeImages'],
              ),

              /// The product name
              Text(
                widget.productData['shoeName'],
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: TSizes.defaultSpace),

              /// The product category
              Text(
                widget.productData['shoeCategory'],
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                ),
              ),

              const SizedBox(height: TSizes.defaultSpace),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: TSizes.sm,
                      right: TSizes.sm,
                      bottom: TSizes.xs,
                      top: TSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: TColors.buttonPrimary,
                      borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                    ),
                    child: Text(
                      "${widget.productData['discount'].toString()}% off",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Text(
                    "\$${widget.productData['shoePrice'].toStringAsFixed(2)}",
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium!.copyWith(fontSize: 22),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.defaultSpace),
              Text(
                "${Texts.inStock} : ${widget.productData['quantity'].toString()}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: TSizes.defaultSpace),
              Row(
                children: [
                  Text(
                    widget.productData['brandName'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(width: TSizes.defaultSpace / 3),
                  Icon(Iconsax.verify5, color: TColors.facebookBackgroundColor),
                ],
              ),
              const SizedBox(height: TSizes.defaultSpace),
              Wrap(
                children: List<String>.from(widget.productData['shoeSizes'])
                    .map(
                      (size) => ShoeSizeChip(
                        sizeLabel: size,
                        isSelected: selectedSize == size,
                        onTap: () {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: TSizes.defaultSpace),
              Text(
                Texts.description,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.defaultSpace / 2),
              ReadMoreTextWidget(
                text: widget.productData['shoeDescription'],
                trimLength: 120,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: selectedSize == null || selectedSize!.isEmpty ? null : () {
            _cartProvider.addShoesToCart(
              shoeName: widget.productData['shoeName'],
              brandName: widget.productData['brandName'],
              shoePrice: widget.productData['shoePrice'],
              shoeCategory: widget.productData['shoeCategory'],
              imageUrl: List<String>.from(widget.productData['shoeImages']),
              quantity: 1,
              inStock: widget.productData['quantity'],
              shoeId: widget.productData['shoeId'],
              shoeSizes: selectedSize ?? "",
              discount: widget.productData['discount'],
              shoeDescription: widget.productData['shoeDescription'],
              vendorId: widget.productData['vendorId'],
            );
      
            AppToast.success(
              context,
              "${widget.productData['shoeName']} added to the box",
            );
          },
          child: Text(
            Texts.addToCart,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: dark ? TColors.black : TColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

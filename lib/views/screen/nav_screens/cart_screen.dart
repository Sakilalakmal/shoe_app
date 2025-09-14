import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/provider/cart_provider.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shoe_app_assigment/views/screen/inner_screens/checkout_screen.dart';
import 'package:shoe_app_assigment/views/screen/main_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final cartData = ref.watch(cartProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final totalAmount = ref.read(cartProvider.notifier).calculateTotalAmount();

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: TSizes.lg),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Iconsax.message),
                  iconSize: TSizes.iconMd,
                  color: dark ? TColors.white : TColors.dark,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: badges.Badge(
                    badgeStyle: badges.BadgeStyle(badgeColor: TColors.red),
                    badgeContent: Text(
                      cartData.length.toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: TColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        title: Text(
          "Your picks",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: cartData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.box,
                    color: TColors.darkGrey,
                    size: TSizes.iconLg,
                  ),
                  const SizedBox(height: TSizes.defaultSpace),
                  Text(
                    textAlign: TextAlign.center,
                    Texts.cartScreenNodata,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge!.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: TSizes.defaultSpace),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MainScreen();
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.lg,
                        vertical: TSizes.xs / 5,
                      ),
                      child: Text(
                        Texts.shopNowButton,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: dark ? TColors.dark : TColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: TColors.secondaryBackground,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: TColors.newBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "You have ${cartData.length} item${cartData.length == 1 ? '' : 's'} in your cart",
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: TColors.dark,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Cart item UI
                  ListView.builder(
                    itemCount: cartData.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final cartItem = cartData.values.toList()[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.defaultSpace,
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: dark ? TColors.dark : TColors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  cartItem.imageUrl[0],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.shoeName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      cartItem.shoeCategory,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: TColors.darkGrey),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          cartItem.brandName,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                        Icon(
                                          Iconsax.verify5,
                                          color:
                                              TColors.facebookBackgroundColor,
                                          size: TSizes.iconSm,
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: TSizes.defaultSpace / 3,
                                    ),
                                    Text(
                                      "\$${cartItem.shoePrice}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      height: TSizes.loadingIndicatorSize,
                                      width: TSizes.productImageSize,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _cartProvider.decrementQuantity(
                                                cartItem.shoeId,
                                                cartItem.shoeSizes,
                                              );
                                            },
                                            icon: Icon(Iconsax.minus5),
                                          ),
                                          Text(
                                            cartItem.quantity.toString(),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _cartProvider.incrementQuantity(
                                                cartItem.shoeId,
                                                cartItem.shoeSizes,
                                              );
                                            },
                                            icon: Icon(Iconsax.add5),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: TSizes.defaultSpace),

                                    IconButton(
                                      onPressed: () {
                                        _cartProvider.removeShoesFromCart(
                                          cartItem.shoeId,
                                          cartItem.shoeSizes,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: TColors.red,
                                      ),
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
                ],
              ),
            ),
      bottomNavigationBar: cartData.isEmpty
          ? Text("")
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: TColors.secondaryBackground,
                    borderRadius: BorderRadius.circular(TSizes.md),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.md,
                      vertical: TSizes.md,
                    ),
                    child: Text(
                      "${Texts.subTotalPrice}${totalAmount.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: dark ? TColors.dark : TColors.dark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.defaultSpace),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CheckoutScreen();
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: TSizes.lg),
                    child: Text(
                      Texts.checkoutButton,
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(color: dark ? TColors.dark : TColors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

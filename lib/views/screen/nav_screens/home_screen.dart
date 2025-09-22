import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/utils/theme/widget_themes/appbar.dart';
import 'package:shoe_app_assigment/utils/theme/widget_themes/device_utility.dart';
import 'package:shoe_app_assigment/views/components/carousel_slider/banner_widget.dart';
import 'package:shoe_app_assigment/views/components/categories/category_item.dart';
import 'package:shoe_app_assigment/views/components/circular_widget/primary_header_container.dart';
import 'package:shoe_app_assigment/views/components/recommended_products/recommended_products_widget.dart';
import 'package:shoe_app_assigment/views/components/reusable_text/reusable_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>?> getCurrentBuyerProfile() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('buyers')
        .doc(uid)
        .get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TAppBar(
                    showActions: true,
                    title: FutureBuilder<Map<String, dynamic>?>(
                      future: getCurrentBuyerProfile(),
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        final String name = data?['fullName'] ?? 'Shopper';
                        final String img = data?['profileImage'] ?? '';

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              backgroundImage: (img.isNotEmpty)
                                  ? NetworkImage(img)
                                  : null,
                              child: (img.isEmpty)
                                  ? Icon(
                                      Icons.person,
                                      size: 28,
                                      color: Colors.grey.shade400,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: TSizes.defaultSpace),
                            Flexible(
                              child: Text(
                                'Good day for shopping,\n $name',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const CustomSearchBar(),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Padding(
                    padding: const EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Texts.categoriesText,
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        CategoryItem(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            BannerWidget(),

            ReusableText(
              title: Texts.recommendedForYou,
              subTitle: Texts.viewAll,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            RecommendedProductsWidget(),
            const SizedBox(height: TSizes.spaceBtwItems),
          ],
        ),
      ),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.controller,
    this.hintText = Texts.searchHintText,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String hintText;
  final IconData icon;
  final bool showBackground, showBorder;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: Container(
        width: TDeviceUtils.getScreenWidth(context),
        padding: EdgeInsets.symmetric(horizontal: TSizes.md),
        decoration: BoxDecoration(
          color: showBackground
              ? (dark ? TColors.dark : TColors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          border: showBorder ? Border.all(color: TColors.grey) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: TColors.darkerGrey),
            const SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: dark ? TColors.darkerGrey : TColors.dark,
                ),
                cursorColor: TColors.primary,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TColors.darkerGrey,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

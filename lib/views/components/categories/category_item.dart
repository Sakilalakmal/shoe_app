import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:shoe_app_assigment/controllers/category_controller/category_controller.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  final CategoryController _categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: TSizes.imageThumbSize,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _categoryController.categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: TSizes.spaceBtwItems),
              child: Column(
                children: [
                  //category icon container
                  Container(
                    width: TSizes.categoryHeight,
                    height: TSizes.categoryHeight,
                    padding: const EdgeInsets.all(TSizes.sm),
                    decoration: BoxDecoration(
                      color: TColors.white,
                      borderRadius: BorderRadius.circular(
                        TSizes.borderRadiusFull,
                      ),
                    ),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl:
                            _categoryController.categories[index].categoryImage,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),

                  const SizedBox(height: TSizes.spaceBtwItems / 2),

                  //category name
                  Text(
                    _categoryController.categories[index].categoryName,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge!.apply(color: TColors.white),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}

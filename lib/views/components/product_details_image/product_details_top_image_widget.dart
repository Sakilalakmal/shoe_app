import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_app_assigment/controllers/product_details_controllers/product_details_image_section.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/components/curved_edge/curved_edge_clipper.dart';

class ProductDetailsTopImageWidget extends StatelessWidget {
  const ProductDetailsTopImageWidget({super.key, required this.images});

  final List<dynamic> images;

  @override
  Widget build(BuildContext context) {
    
    final dark = HelperFunctions.isDarkMode(context);
    final controller = Get.put(ProductDetailsImageController());
    controller.setImages(images);

    return Obx(() {
      return SizedBox(
        height: 400, // adjust this height if needed
        child: ClipPath(
          clipper: CustomCurvedEdge(),
          child: Container(
            color: dark ? TColors.dark : TColors.cardBackgroundColor,
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.defaultSpace,
              vertical: TSizes.spaceBtwItems,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Main Selected Image
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: TColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      controller.selectedImage.value,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwItems),

                /// Image Thumbnails
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.images.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: TSizes.sm),
                    itemBuilder: (context, index) {
                      final imageUrl = controller.images[index];
                      final isSelected =
                          controller.selectedImage.value == imageUrl;

                      return GestureDetector(
                        onTap: () => controller.setSelectedImage(imageUrl),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? TColors.primary
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: TColors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

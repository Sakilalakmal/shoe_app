import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/model/favorite_model/favorite_model.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class FavoriteShoeItemWidget extends StatelessWidget {
  final FavoriteModel favoriteModel;
  final VoidCallback onRemove;

  const FavoriteShoeItemWidget({
    super.key,
    required this.favoriteModel,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TSizes.sm),
      decoration: BoxDecoration(
        color: TColors.lightContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: TColors.darkGrey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image with remove icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    favoriteModel.imageUrl.first,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: onRemove,
                  child: const Icon(
                    Iconsax.heart_remove,
                    color: TColors.error,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.sm),

          /// Name
          Text(
            favoriteModel.shoeName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),

          const SizedBox(height: 4),

          /// Price
          Text(
            "\$${favoriteModel.shoePrice}",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
          ),
        ],
      ),
    );
  }
}

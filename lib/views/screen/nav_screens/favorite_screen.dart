import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/provider/favorite_provider.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = HelperFunctions.isDarkMode(context);
    final wishItemData = ref.watch(favoriteProvider);
    final favoriteData = ref.read(favoriteProvider.notifier);

    return PopScope( // FIXED: Handle back navigation properly for tab screen
      canPop: false, // Prevent default pop behavior
      onPopInvoked: (didPop) {
        // Do nothing - let bottom navigation handle tab switching
        return;
      },
      child: Scaffold(
        backgroundColor: dark ? TColors.darkBackground : TColors.lightGrey,
        appBar: _buildModernAppBar(context, wishItemData, favoriteData, dark),
        body: wishItemData.isEmpty
            ? _buildEmptyFavoritesState(context, dark)
            : _buildFavoritesList(context, wishItemData, favoriteData, dark),
      ),
    );
  }

  // MODERN AppBar Design
  PreferredSizeWidget _buildModernAppBar(
    BuildContext context,
    wishItemData,
    favoriteData,
    bool dark,
  ) {
    return AppBar(
      automaticallyImplyLeading: false, // FIXED: Ensure no back button
      backgroundColor: dark ? TColors.darkBackground : TColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          // Modern Icon Container
          Container(
            padding: const EdgeInsets.all(TSizes.sm),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  TColors.newBlue.withOpacity(0.1),
                  TColors.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
              border: Border.all(
                color: TColors.newBlue.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Icon(
              Iconsax.heart5,
              color: TColors.newBlue,
              size: TSizes.iconMd,
            ),
          ),
          const SizedBox(width: TSizes.md),
          
          // Title and Count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Texts.favoriteText,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
                  ),
                ),
                if (wishItemData.isNotEmpty)
                  Text(
                    '${wishItemData.length} ${wishItemData.length == 1 ? 'item' : 'items'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: TColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (wishItemData.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(right: TSizes.md),
            decoration: BoxDecoration(
              color: dark ? TColors.darkContainer : TColors.lightContainer,
              borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
              border: Border.all(
                color: dark 
                    ? TColors.borderDark.withOpacity(0.1)
                    : TColors.borderLight.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: PopupMenuButton(
              icon: Icon(
                Iconsax.more,
                color: dark ? TColors.iconPrimaryDark : TColors.iconPrimaryLight,
                size: TSizes.iconMd,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
              ),
              color: dark ? TColors.darkContainer : TColors.white,
              elevation: 12,
              shadowColor: TColors.black.withOpacity(0.1),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () {
                    // FIXED: Use Future.delayed to prevent navigation issues
                    Future.delayed(Duration.zero, () {
                      _showClearAllDialog(context, favoriteData);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(TSizes.xs),
                          decoration: BoxDecoration(
                            color: TColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(TSizes.cardRadiusXs),
                          ),
                          child: Icon(
                            Iconsax.trash,
                            color: TColors.error,
                            size: TSizes.iconSm,
                          ),
                        ),
                        const SizedBox(width: TSizes.sm),
                        Text(
                          'Clear All',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: TColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // MODERN Favorites List
  Widget _buildFavoritesList(
    BuildContext context,
    wishItemData,
    favoriteData,
    bool dark,
  ) {
    return ListView.builder(
      itemCount: wishItemData.length,
      padding: const EdgeInsets.all(TSizes.md),
      physics: const BouncingScrollPhysics(), // ENHANCED: Better scroll physics
      itemBuilder: (context, index) {
        final wishItem = wishItemData.values.toList()[index];
        return Container(
          margin: const EdgeInsets.only(bottom: TSizes.md),
          child: _buildModernProductCard(context, wishItem, favoriteData, dark),
        );
      },
    );
  }

  // MODERN Product Card Design
  Widget _buildModernProductCard(
    BuildContext context,
    wishItem,
    favoriteData,
    bool dark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? TColors.darkContainer : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        border: Border.all(
          color: dark 
              ? TColors.borderDark.withOpacity(0.1)
              : TColors.borderLight.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: dark 
                ? TColors.black.withOpacity(0.2)
                : TColors.darkGrey.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: IntrinsicHeight( // FIXED: Use IntrinsicHeight to handle row height properly
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // FIXED: Stretch to full height
          children: [
            // MODERN Image Section
            Container(
              width: 120,
              margin: const EdgeInsets.all(TSizes.md),
              child: Stack(
                children: [
                  // Image Container with Gradient Background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          TColors.newBlue.withOpacity(0.05),
                          TColors.primary.withOpacity(0.02),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                    ),
                    child: AspectRatio( // FIXED: Use AspectRatio instead of fixed height
                      aspectRatio: 1.0, // Square aspect ratio
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                        child: Image.network(
                          wishItem.imageUrl[0],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: dark ? TColors.darkContainer : TColors.lightContainer,
                                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Iconsax.image,
                                      color: TColors.darkGrey,
                                      size: TSizes.iconLg,
                                    ),
                                    const SizedBox(height: TSizes.xs),
                                    Text(
                                      'No Image',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: TColors.darkGrey,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // MODERN Discount Badge
                  if (wishItem.discount > 0)
                    Positioned(
                      top: TSizes.xs,
                      left: TSizes.xs,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.sm,
                          vertical: TSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              TColors.error,
                              TColors.error.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(TSizes.borderRadiusFull),
                          boxShadow: [
                            BoxShadow(
                              color: TColors.error.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          "${wishItem.discount}%",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: TColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // MODERN Product Info Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: TSizes.md,
                  right: TSizes.md,
                  bottom: TSizes.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product Details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          wishItem.shoeName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: TSizes.xs),

                        // Brand with Verification
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                wishItem.brandName,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: TColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: TSizes.xs),
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: TColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(TSizes.cardRadiusXs),
                              ),
                              child: Icon(
                                Iconsax.verify5,
                                color: TColors.success,
                                size: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: TSizes.md),

                    // Price and Action Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Price Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Price',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: TColors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "\$${wishItem.shoePrice}",
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: TColors.newBlue,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),

                        // REPOSITIONED: Delete Button Above Add to Cart Button
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Delete Button - MOVED HERE
                            Container(
                              decoration: BoxDecoration(
                                color: TColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                                border: Border.all(
                                  color: TColors.error.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                                  onTap: () {
                                    _showDeleteConfirmation(
                                      context,
                                      wishItem.shoeName,
                                      () => favoriteData.removeShoeFromFavorite(wishItem.shoeId),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(TSizes.sm),
                                    child: Icon(
                                      Iconsax.trash,
                                      color: TColors.error,
                                      size: TSizes.iconMd,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: TSizes.xs), // Small gap between buttons

                            // Add to Cart Button - BELOW DELETE BUTTON
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    TColors.newBlue,
                                    TColors.newBlue.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                                boxShadow: [
                                  BoxShadow(
                                    color: TColors.newBlue.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                                  onTap: () {
                                    _showAddToCartMessage(context, wishItem.shoeName);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(TSizes.sm + 2),
                                    child: Icon(
                                      Iconsax.add,
                                      color: TColors.white,
                                      size: TSizes.iconMd,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
  }

  // Rest of the methods remain exactly the same...
  Widget _buildEmptyFavoritesState(BuildContext context, bool dark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Modern Empty Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    TColors.newBlue.withOpacity(0.1),
                    TColors.primary.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: TColors.newBlue.withOpacity(0.1),
                  width: 2,
                ),
              ),
              child: Icon(
                Iconsax.heart_slash,
                size: 50,
                color: TColors.darkGrey.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: TSizes.xl),

            // Typography
            Text(
              'No Favorites Yet',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: TSizes.sm),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.lg),
              child: Text(
                'Tap the heart icon on any shoe to add it to your favorites.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: TSizes.xl),

            // CTA Button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TColors.newBlue,
                    TColors.newBlue.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                boxShadow: [
                  BoxShadow(
                    color: TColors.newBlue.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                  onTap: () {
                    // Navigate to home or shop
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.xl,
                      vertical: TSizes.md,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.shop,
                          color: TColors.white,
                          size: TSizes.iconMd,
                        ),
                        const SizedBox(width: TSizes.sm),
                        Text(
                          'Start Shopping',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: TColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String shoeName, VoidCallback onConfirm) {
    final dark = HelperFunctions.isDarkMode(context);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        ),
        backgroundColor: dark ? TColors.darkContainer : TColors.white,
        child: Padding(
          padding: const EdgeInsets.all(TSizes.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: TColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Iconsax.warning_2,
                  color: TColors.error,
                  size: TSizes.iconLg,
                ),
              ),
              const SizedBox(height: TSizes.lg),

              // Title
              Text(
                'Remove Item?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
                ),
              ),
              const SizedBox(height: TSizes.sm),

              // Content
              Text(
                'Are you sure you want to remove "$shoeName" from your favorites?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: TSizes.xl),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: dark ? TColors.darkContainer : TColors.lightContainer,
                        padding: const EdgeInsets.symmetric(vertical: TSizes.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: TColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.sm),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [TColors.error, TColors.error.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(TSizes.xs),
                                    decoration: BoxDecoration(
                                      color: TColors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(TSizes.cardRadiusXs),
                                    ),
                                    child: Icon(
                                      Iconsax.tick_circle,
                                      color: TColors.white,
                                      size: TSizes.iconSm,
                                    ),
                                  ),
                                  const SizedBox(width: TSizes.sm),
                                  Expanded(
                                    child: Text(
                                      '$shoeName removed from favorites',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: TColors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: TColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                              ),
                              margin: const EdgeInsets.all(TSizes.md),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: TSizes.md),
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                            color: TColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, favoriteNotifier) {
    final dark = HelperFunctions.isDarkMode(context);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        ),
        backgroundColor: dark ? TColors.darkContainer : TColors.white,
        child: Padding(
          padding: const EdgeInsets.all(TSizes.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Trash Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: TColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Iconsax.trash,
                  color: TColors.error,
                  size: TSizes.iconLg,
                ),
              ),
              const SizedBox(height: TSizes.lg),

              // Title
              Text(
                'Clear All Favorites?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
                ),
              ),
              const SizedBox(height: TSizes.sm),

              // Content
              Text(
                'This will remove all shoes from your favorites. This action cannot be undone.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: TSizes.xl),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: dark ? TColors.darkContainer : TColors.lightContainer,
                        padding: const EdgeInsets.symmetric(vertical: TSizes.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: TColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.sm),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [TColors.error, TColors.error.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          favoriteNotifier.removeAllFavoriteShoes();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(TSizes.xs),
                                    decoration: BoxDecoration(
                                      color: TColors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(TSizes.cardRadiusXs),
                                    ),
                                    child: Icon(
                                      Iconsax.tick_circle,
                                      color: TColors.white,
                                      size: TSizes.iconSm,
                                    ),
                                  ),
                                  const SizedBox(width: TSizes.sm),
                                  Text(
                                    'All favorites cleared',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: TColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: TColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                              ),
                              margin: const EdgeInsets.all(TSizes.md),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: TSizes.md),
                        ),
                        child: Text(
                          'Clear All',
                          style: TextStyle(
                            color: TColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),]
            ),
          ),
        ),
      );
  }

  void _showAddToCartMessage(BuildContext context, String shoeName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(TSizes.xs),
              decoration: BoxDecoration(
                color: TColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(TSizes.cardRadiusXs),
              ),
              child: Icon(
                Iconsax.shopping_cart,
                color: TColors.white,
                size: TSizes.iconSm,
              ),
            ),
            const SizedBox(width: TSizes.sm),
            Expanded(
              child: Text(
                '$shoeName would be added to cart',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: TColors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: TColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        ),
        margin: const EdgeInsets.all(TSizes.md),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
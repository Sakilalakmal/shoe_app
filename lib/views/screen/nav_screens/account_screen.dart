import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/delivered_orders_screen.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/show_orders_screen.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/widget/profile_picture_widget.dart';
import 'package:shoe_app_assigment/views/screen/nav_screens/favorite_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Please log in to view your account',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header Section
              _ProfileHeaderSection(
                screenWidth: screenWidth,
                dark: dark,
                user: user,
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Account Stats Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account Overview",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dark ? TColors.white : TColors.dark,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Stats Cards Row
                    _AccountStatsRow(dark: dark),

                    const SizedBox(height: TSizes.spaceBtwSections),

                    // Quick Actions Section
                    Text(
                      "Quick Actions",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dark ? TColors.white : TColors.dark,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Action Cards
                    _QuickActionsSection(dark: dark),

                    const SizedBox(height: TSizes.spaceBtwSections),

                    // Profile Actions
                    _ProfileActionsSection(dark: dark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Profile Header Widget
class _ProfileHeaderSection extends StatelessWidget {
  final double screenWidth;
  final bool dark;
  final User user;

  const _ProfileHeaderSection({
    required this.screenWidth,
    required this.dark,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [TColors.dark, TColors.darkContainer]
              : [TColors.newBlue, TColors.newBlue.withOpacity(0.8)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(TSizes.cardRadiusLg),
          bottomRight: Radius.circular(TSizes.cardRadiusLg),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: TSizes.spaceBtwItems),

          // Profile Picture
          ProfilePictureWidget(
            userId: user.uid,
            borderColor: TColors.white,
            backgroundColor: TColors.white,
            showCamera: true,
            radius: 60,
          ),

          const SizedBox(height: TSizes.spaceBtwItems),

          // User Info from Firebase
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('buyers')
                .doc(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    Text(
                      userData['fullName'] ?? 'User Name',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TColors.white,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Text(
                      userData['email'] ?? user.email ?? 'No email',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: TColors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  Text(
                    user.displayName ?? 'User Name',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TColors.white,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(
                    user.email ?? 'No email',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: TColors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// Account Stats Row Widget
class _AccountStatsRow extends StatelessWidget {
  final bool dark;

  const _AccountStatsRow({required this.dark});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    return Row(
      children: [
        // Wishlist Card
        Expanded(
          child: _WishlistStatsCard(dark: dark, userId: user.uid),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        // Processing Orders Card
        Expanded(
          child: _ProcessingOrdersCard(dark: dark, userId: user.uid),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        // Delivered Orders Card
        Expanded(
          child: _DeliveredOrdersCard(dark: dark, userId: user.uid),
        ),
      ],
    );
  }
}

// Wishlist Stats Card Widget
class _WishlistStatsCard extends StatelessWidget {
  final bool dark;
  final String userId;

  const _WishlistStatsCard({required this.dark, required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavoriteScreen()),
        );
      },
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('favorites')
            .where('buyerId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingCard(context, "Wishlist", Iconsax.heart, TColors.error, dark);
          }

          if (snapshot.hasError) {
            return _buildErrorCard(context, "Wishlist", Iconsax.heart, TColors.error, dark);
          }

          int wishlistCount = 0;
          if (snapshot.hasData) {
            wishlistCount = snapshot.data!.docs.length;
          }

          return _buildStatsCard(
            context,
            Iconsax.heart,
            TColors.error,
            "Wishlist",
            wishlistCount.toString(),
            wishlistCount == 0 ? "No items saved yet" : "$wishlistCount item${wishlistCount == 1 ? '' : 's'}",
            dark,
          );
        },
      ),
    );
  }
}

// Processing Orders Card Widget - UPDATED TO USE shoeOrders COLLECTION
class _ProcessingOrdersCard extends StatelessWidget {
  final bool dark;
  final String userId;

  const _ProcessingOrdersCard({required this.dark, required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShowOrdersScreen()),
        );
      },
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('shoeOrders') // CHANGED FROM 'orders' TO 'shoeOrders'
            .where('buyerId', isEqualTo: userId)
            .where('processing', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingCard(context, "Processing", Iconsax.refresh, TColors.warning, dark);
          }

          if (snapshot.hasError) {
            return _buildErrorCard(context, "Processing", Iconsax.refresh, TColors.warning, dark);
          }

          int processingCount = 0;
          if (snapshot.hasData) {
            processingCount = snapshot.data!.docs.length;
          }

          return _buildStatsCard(
            context,
            Iconsax.refresh,
            TColors.warning,
            "Processing",
            processingCount.toString(),
            processingCount == 0 ? "No orders processing" : "$processingCount order${processingCount == 1 ? '' : 's'}",
            dark,
          );
        },
      ),
    );
  }
}

// Delivered Orders Card Widget - UPDATED TO USE shoeOrders COLLECTION
class _DeliveredOrdersCard extends StatelessWidget {
  final bool dark;
  final String userId;

  const _DeliveredOrdersCard({required this.dark, required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DeliveredOrdersScreen()),
        );
      },
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('shoeOrders') // CHANGED FROM 'orders' TO 'shoeOrders'
            .where('buyerId', isEqualTo: userId)
            .where('delivered', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingCard(context, "Delivered", Iconsax.tick_circle, TColors.success, dark);
          }

          if (snapshot.hasError) {
            return _buildErrorCard(context, "Delivered", Iconsax.tick_circle, TColors.success, dark);
          }

          int deliveredCount = 0;
          if (snapshot.hasData) {
            deliveredCount = snapshot.data!.docs.length;
          }

          return _buildStatsCard(
            context,
            Iconsax.tick_circle,
            TColors.success,
            "Delivered",
            deliveredCount.toString(),
            deliveredCount == 0 ? "No delivered orders yet" : "$deliveredCount order${deliveredCount == 1 ? '' : 's'}",
            dark,
          );
        },
      ),
    );
  }
}

// Quick Actions Section Widget
class _QuickActionsSection extends StatelessWidget {
  final bool dark;

  const _QuickActionsSection({required this.dark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                Iconsax.heart,
                "My Wishlist",
                "View saved items",
                TColors.error,
                dark,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
              child: _buildActionCard(
                context,
                Iconsax.box,
                "Order History",
                "Track your orders",
                TColors.newBlue,
                dark,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShowOrdersScreen()),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                Iconsax.location,
                "Addresses",
                "Manage delivery addresses",
                TColors.info,
                dark,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Address management coming soon'),
                      backgroundColor: TColors.info,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
              child: _buildActionCard(
                context,
                Iconsax.support,
                "Help & Support",
                "Get assistance",
                TColors.success,
                dark,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Support coming soon'),
                      backgroundColor: TColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Profile Actions Section Widget
class _ProfileActionsSection extends StatelessWidget {
  final bool dark;

  const _ProfileActionsSection({required this.dark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Edit Profile Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Edit profile coming soon'),
                  backgroundColor: TColors.newBlue,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Iconsax.edit, size: TSizes.iconMd),
            label: Text(
              "Edit Profile",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: TColors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.newBlue,
              foregroundColor: TColors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: TSizes.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TSizes.buttonRadius),
              ),
            ),
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwItems),

        // Logout Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                  ),
                  title: Text(
                    'Logout',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel', style: TextStyle(color: TColors.darkGrey)),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.error,
                        foregroundColor: TColors.white,
                      ),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Successfully logged out'),
                      backgroundColor: TColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Iconsax.logout, size: TSizes.iconMd),
            label: Text(
              "Logout",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: dark ? TColors.white : TColors.dark,
              ),
            ),
            style: OutlinedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: TSizes.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TSizes.buttonRadius),
              ),
              side: BorderSide(
                color: TColors.error,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Reusable Stats Card Builder - ENHANCED VERSION
Widget _buildStatsCard(
  BuildContext context,
  IconData icon,
  Color iconColor,
  String title,
  String count,
  String subtitle,
  bool dark,
) {
  return Container(
    padding: const EdgeInsets.all(TSizes.md),
    decoration: BoxDecoration(
      color: dark ? TColors.darkContainer : TColors.white,
      borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(
        color: dark ? TColors.darkGrey : TColors.grey.withOpacity(0.2),
        width: 1,
      ),
    ),
    child: Column(
      children: [
        // Icon
        Container(
          padding: const EdgeInsets.all(TSizes.sm),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: TSizes.iconMd),
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),

        // Count
        Text(
          count,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: dark ? TColors.white : TColors.dark,
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 4),

        // Title
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: dark ? TColors.white : TColors.dark,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 4),

        // Subtitle
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: dark ? TColors.white.withOpacity(0.7) : TColors.darkGrey,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

// Loading Card Widget
Widget _buildLoadingCard(
  BuildContext context,
  String title,
  IconData icon,
  Color iconColor,
  bool dark,
) {
  return Container(
    padding: const EdgeInsets.all(TSizes.md),
    decoration: BoxDecoration(
      color: dark ? TColors.darkContainer : TColors.white,
      borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(
        color: dark ? TColors.darkGrey : TColors.grey.withOpacity(0.2),
        width: 1,
      ),
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(TSizes.sm),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: TSizes.iconMd),
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: iconColor,
            strokeWidth: 2,
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: dark ? TColors.white : TColors.dark,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

// Error Card Widget
Widget _buildErrorCard(
  BuildContext context,
  String title,
  IconData icon,
  Color iconColor,
  bool dark,
) {
  return Container(
    padding: const EdgeInsets.all(TSizes.md),
    decoration: BoxDecoration(
      color: dark ? TColors.darkContainer : TColors.white,
      borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(
        color: TColors.error.withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(TSizes.sm),
          decoration: BoxDecoration(
            color: TColors.error.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Iconsax.warning_2, color: TColors.error, size: TSizes.iconMd),
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Text(
          "Error",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: TColors.error,
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: dark ? TColors.white.withOpacity(0.7) : TColors.darkGrey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

// Reusable Action Card Builder
Widget _buildActionCard(
  BuildContext context,
  IconData icon,
  String title,
  String subtitle,
  Color iconColor,
  bool dark,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: dark ? TColors.darkContainer : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: dark ? TColors.darkGrey : TColors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(TSizes.xs),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TSizes.sm),
            ),
            child: Icon(icon, color: iconColor, size: TSizes.iconMd),
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),

          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: dark ? TColors.white : TColors.dark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 4),

          // Subtitle
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: dark ? TColors.white.withOpacity(0.7) : TColors.darkGrey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
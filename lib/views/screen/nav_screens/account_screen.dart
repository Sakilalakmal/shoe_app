import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/show_orders_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Section with Background
              Container(
                width: screenWidth,
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                decoration: BoxDecoration(
                  color: dark ? TColors.darkContainer : TColors.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(TSizes.cardRadiusLg),
                    bottomRight: Radius.circular(TSizes.cardRadiusLg),
                  ),
                ),
                child: Column(
                  children: [
                    // Top Space for Status Bar
                    SizedBox(height: statusBarHeight + 10),

                    // Profile Image
                    // Profile Image
                    Stack(
                      children: [
                        // Existing profile image container
                        Container(
                          decoration: BoxDecoration(
                            color: TColors.white,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: TColors.primary,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.transparent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                'assets/images/account.jpg',
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              ),
                            ),
                          ),
                        ),

                        // Camera icon button overlay
                        Positioned(
                          right: 5,
                          bottom: 5,
                          child: GestureDetector(
                            onTap: () {
                              // Add your image picker logic here
                              print("Change profile picture");
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: TColors.newBlue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: dark
                                      ? TColors.darkContainer
                                      : TColors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Iconsax.camera,
                                color: TColors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: TSizes.spaceBtwItems),

                    // User Name
                    Text(
                      "John Doe",
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: TSizes.lg,
                            color: dark ? TColors.white : TColors.dark,
                          ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwItems / 2),

                    // User Email
                    Text(
                      "johndoe@example.com",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: dark ? TColors.white : TColors.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Stats Section
              Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Stats",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Stat Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatsCard(
                            context,
                            Iconsax.heart,
                            TColors.facebookBackgroundColor,
                            "Wishlist",
                            "12",
                            dark,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              // Navigate to Orders Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ShowOrdersScreen();
                                  },
                                ),
                              );
                            },
                            child: _buildStatsCard(
                              context,
                              Iconsax.refresh,
                              TColors.primary,
                              "Processing",
                              "3",
                              dark,
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: _buildStatsCard(
                            context,
                            Iconsax.box_tick,
                            TColors.newBlue,
                            "Delivered",
                            "8",
                            dark,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: TSizes.spaceBtwSections + 30),

                    // Edit Profile Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to edit profile
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: dark
                              ? TColors.buttonPrimary
                              : TColors.newBlue,
                          foregroundColor: TColors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            vertical: TSizes.buttonHeight / 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              TSizes.buttonRadius,
                            ),
                          ),
                        ),
                        child: Text(
                          "Edit Profile",
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: TColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // Logout logic
                        },
                        style: OutlinedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            vertical: TSizes.buttonHeight / 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              TSizes.buttonRadius,
                            ),
                          ),
                          side: BorderSide(
                            color: dark ? TColors.white : TColors.dark,
                          ),
                        ),
                        child: Text(
                          "Logout",
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: dark ? TColors.white : TColors.dark,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Reusable Card Builder ---
  Widget _buildStatsCard(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String title,
    String count,
    bool dark,
  ) {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: dark ? TColors.darkContainer : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(TSizes.md),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: TSizes.iconLg),
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
            ),
          ),
        ],
      ),
    );
  }
}

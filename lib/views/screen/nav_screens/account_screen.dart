import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section with Background
            Container(
              width: HelperFunctions.screenWidth(),
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              decoration: BoxDecoration(
                color: dark ? TColors.darkContainer : TColors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(TSizes.cardRadiusLg),
                  bottomRight: Radius.circular(TSizes.cardRadiusLg),
                ),
              ),
              child: Column(
                children: [
                  // Top Space for Status Bar
                  const SizedBox(height: 40),

                  // Profile Image
                  Container(
                    decoration: BoxDecoration(
                      color: TColors.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: TColors.primary, width: 4),
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
                          'assets/images/account.png',
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ),
                  ),

                  // User Name
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    "John Doe",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: TSizes.lg,
                      color: dark ? TColors.white : TColors.dark,
                    ),
                  ),

                  // User Email
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
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
                  // Stats Title
                  Text(
                    "My Stats",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Three Cards Row
                  Row(
                    children: [
                      // Wishlist Card
                      Expanded(
                        child: _buildStatsCard(
                          context,
                          'assets/icons/wishlist.png',
                          TColors.facebookBackgroundColor,
                          "Wishlist",
                          "12",
                          dark,
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),

                      // Processing Card
                      Expanded(
                        child: _buildStatsCard(
                          context,
                          'assets/icons/delivered.png',
                          TColors.primary,
                          "Processing",
                          "3",
                          dark,
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),

                      // Delivered Card
                      Expanded(
                        child: _buildStatsCard(
                          context,
                          'assets/icons/automation.png',
                          TColors.newBlue,
                          "Delivered",
                          "8",
                          dark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: TSizes.spaceBtwSections + 50),

                  // Edit Profile Button
                  const SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to edit profile screen
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: TColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Logout Button
                  const SizedBox(height: TSizes.spaceBtwItems),
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
    );
  }

  // Helper method to build stat cards
  Widget _buildStatsCard(
    BuildContext context,
    String imagePath,
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
            child: Image.asset(imagePath),
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

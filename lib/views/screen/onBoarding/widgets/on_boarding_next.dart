import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/controllers/onBoard_Controller/onboarding_controller.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: TSizes.defaultSpace,
      bottom: TSizes.spaceBtwSections,
      child: ElevatedButton(
        onPressed: ()=> OnboardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(TSizes.defaultSpace),
        ),
        child: Icon(Iconsax.arrow_right_3),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/controllers/onBoard_Controller/onboarding_controller.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: TSizes.spaceBtwItems,
      right: TSizes.defaultSpace,
      child: TextButton(onPressed: () =>OnboardingController.instance.skipPage(), child: Text("Skip")),
    );
  }
}

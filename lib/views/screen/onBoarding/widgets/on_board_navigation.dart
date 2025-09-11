import 'package:flutter/widgets.dart';
import 'package:shoe_app_assigment/controllers/onBoard_Controller/onboarding_controller.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final controller = OnboardingController.instance;
    final dark = HelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: TSizes.spaceBtwSections + 20,
      left: TSizes.defaultSpace,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3,
        effect: ExpandingDotsEffect(
          activeDotColor: dark ? TColors.cardBackgroundColor : TColors.dark,
          dotHeight: 6,
        ),
      ),
    );
  }
}

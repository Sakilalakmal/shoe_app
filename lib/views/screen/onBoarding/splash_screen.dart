import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_app_assigment/controllers/onBoard_Controller/onboarding_controller.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/views/screen/onBoarding/widgets/on_board_navigation.dart';
import 'package:shoe_app_assigment/views/screen/onBoarding/widgets/on_boarding.dart';
import 'package:shoe_app_assigment/views/screen/onBoarding/widgets/on_boarding_next.dart';
import 'package:shoe_app_assigment/views/screen/onBoarding/widgets/on_boarding_skip.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            //horizontal scrollable pages
            PageView(
              controller: controller.pageController,
              onPageChanged:controller.updatePageIndicator,
              children: [
                OnBoardingPage(
                  image: "assets/animations/chatbot.json",
                  title: Texts.tOnBoardingTitle1,
                  subTitle: Texts.tOnBoardingSubTitle1,
                ),

                OnBoardingPage(
                  image: "assets/animations/ecommerce.json",
                  title: Texts.tOnBoardingTitle2,
                  subTitle: Texts.tOnBoardingSubTitle2,
                ),

                OnBoardingPage(
                  image: "assets/animations/delivery.json",
                  title: Texts.tOnBoardingTitle3,
                  subTitle: Texts.tOnBoardingSubTitle3,
                ),
              ],
            ),
            //skip button
            OnBoardingSkip(),
            //dot navigation smooth page indicator
            OnBoardingDotNavigation(),
            //circular next button
            OnBoardingNextButton(),
          ],
        ),
      ),
    );
  }
}


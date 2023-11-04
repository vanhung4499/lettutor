import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lettutor/app/config/app_colors.dart';
import 'package:lettutor/app/config/app_constants.dart';
import 'package:lettutor/app/config/app_text_styles.dart';
import 'package:lettutor/app/routes/routes.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'Welcome to Lettutor',
            body: 'The best app for learning English',
            image: Center(
              child: Image.asset('assets/images/onboard1.png'),
            ),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Learn English with Lettutor',
            body: 'The best app for learning English',
            image: Center(
              child: Image.asset('assets/images/onboard2.png'),
            ),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Learn English with Lettutor',
            body: 'The best app for learning English',
            image: Center(
              child: Image.asset('assets/images/onboard3.png'),
            ),
            decoration: getPageDecoration(),
          ),
        ],
        done: Text(
          AppConstants.begin.tr,
          style: AppTextStyles.lableOnboadringBlack500,
        ),
        onDone: () async {
          Get.offAllNamed(AppRoutes.HOME);
        },
        showSkipButton: true,
        skip: Text('Skip'.tr),
        next: Text('Next'.tr),
        dotsDecorator: getDotDecoration(),
      ),
    );
  }

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 360));

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: AppTextStyles.lableOnboadringBlack500,
        bodyTextStyle: AppTextStyles.lableOnboadringBlack400,
        imagePadding: const EdgeInsets.all(24),
        pageColor: Colors.white,
      );

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: AppColors.greyColor,
        activeColor: AppColors.kPrimaryColor,
        size: const Size(10, 10),
        activeSize: const Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lettutor/app/config/app_colors.dart';
import './controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.start();

    return const Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: Center(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: FlutterLogo(),
        ),
      ),
    );
  }
}

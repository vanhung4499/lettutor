import 'dart:async';

import 'package:get/get.dart';
import 'package:lettutor/app/routes/app_pages.dart';
import 'package:lettutor/data/providers/local/local_storage.dart';

class SplashController extends GetxController {
  final localStorage = Get.find<LocalStorage>();

  Future start() async {
    Timer(
      const Duration(seconds: 1),
      () async {
        final accessToken = await localStorage.userAccessToken;
        Get.offAllNamed(accessToken == null ? AppRoutes.HOME : AppRoutes.LOGIN);
      },
    );
  }
}

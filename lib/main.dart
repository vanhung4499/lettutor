import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/config/app_colors.dart';
import 'package:lettutor/app/utils/di.dart';
import 'package:lettutor/data/providers/local/local_storage.dart';
import 'package:lettutor/presentation/modules/main/app.dart';

void main() async {
  DenpendencyInjection.init();
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(App(Get.find()));
  configLoading();
}

initServices() async {
  print('starting services ...');
  await GetStorage.init();
  Get.put(LocalStorage(), permanent: true);
  print('All services started...');
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    // ..indicatorSize = 45.0
    ..radius = 10.0
    // ..progressColor = Colors.yellow
    ..backgroundColor = AppColors.lightGray
    ..indicatorColor = AppColors.kPrimaryColor
    ..textColor = AppColors.kPrimaryColor
    // ..maskColor = Colors.red
    ..userInteractions = false
    ..dismissOnTap = false
    ..animationStyle = EasyLoadingAnimationStyle.scale;
}

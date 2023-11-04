import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/config/app_colors.dart';
import 'package:lettutor/app/lang/translation_service.dart';
import 'package:lettutor/app/routes/app_pages.dart';
import 'package:lettutor/data/providers/local/local_storage.dart';
import 'package:lettutor/presentation/modules/main/controllers/app_binding.dart';
import './controllers/app_controller.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  final LocalStorage _localStorage;
  final AppController controller;

  App(this._localStorage, {super.key}) : controller = Get.put(AppController());

  final mainTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundColor,
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
    ),
  );

  final darkTheme = ThemeData.dark();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        navigatorKey: navigatorKey,
        title: 'Lettutor',
        debugShowCheckedModeBanner: false,
        enableLog: true,
        initialRoute: AppRoutes.SPLASH,
        defaultTransition: Transition.fade,
        getPages: AppPages.routes,
        initialBinding: AppBinding(),
        darkTheme: darkTheme,
        theme: controller.isDarkModeOn.value ? darkTheme : mainTheme,
        locale: TranslationService.locale,
        fallbackLocale: TranslationService.fallbackLocale,
        translations: TranslationService(),
      ),
    );
  }
}

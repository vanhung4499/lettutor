import 'package:get/get.dart';

class AppController extends GetxController {
  RxBool isDarkModeOn = false.obs;
  RxBool isNotificationOn = true.obs;
  RxString currentRoute = ''.obs;

  AppController();

  void updateCurrentRoute() {
    currentRoute.value = Get.currentRoute;
  }

  void toggleDarkMode() {
    isDarkModeOn.toggle();
  }

  void toggleNotificationMode() {
    isNotificationOn.toggle();
  }
}

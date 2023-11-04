import 'package:get/get.dart';
import 'package:lettutor/presentation/modules/auth/login/controllers/login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => LoginController(),
    );
  }
}

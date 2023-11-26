import 'package:get/get.dart';
import 'package:lettutor/presentation/main/app_controller.dart';

class DenpendencyInjection {
  static Future<void> init() async {
    Get.put(() => AppController());
  }
}

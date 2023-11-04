import 'package:get/get.dart';
import 'package:lettutor/presentation/modules/main/controllers/app_controller.dart';

class DenpendencyInjection {
  static Future<void> init() async {
    Get.put(() => AppController());
  }
}

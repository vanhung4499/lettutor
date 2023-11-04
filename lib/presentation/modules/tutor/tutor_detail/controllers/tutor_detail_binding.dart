import 'package:get/get.dart';

import 'tutor_detail_controller.dart';

class TutorDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TutorDetailController());
  }
}

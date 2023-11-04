import 'package:get/get.dart';

import 'tutor_list_controller.dart';

class TutorListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TutorListController());
  }
}

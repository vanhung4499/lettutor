import 'package:get/get.dart';

class CourseDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseDetailBinding());
  }
}

import 'package:get/get.dart';
import 'package:lettutor/presentation/modules/course/course_list/controllers/course_list_controller.dart';
import 'package:lettutor/presentation/modules/home/controllers/home_controller.dart';
import 'package:lettutor/presentation/modules/tutor/tutor_list/controllers/tutor_list_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => CourseListController());
    Get.lazyPut(() => TutorListController());
  }
}

import 'package:get/get.dart';
import 'package:lettutor/data/models/course.dart';

class CourseDetailController extends GetxController {
  late Rx<Course> course;

  CourseDetailController(Course course) {
    this.course = course.obs;
  }

  var isLoading = true.obs;
  var isJoining = false.obs;
  var isSharing = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }
}

import 'package:get/get.dart';
import 'package:lettutor/data/models/course.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CourseListController extends GetxController {
  var courses = <Course>[].obs;
  var isFetching = false.obs;
  final RefreshController refreshController = RefreshController();

  @override
  void onInit() {
    super.onInit();
    courses.addAll([Course.getMockCourse(), Course.getMockCourse()]);
  }

  fetchCourses() async {
    print('fetching');
    isFetching.value = true;
    // TODO: fetch courses from api

    isFetching.value = false;
  }
}

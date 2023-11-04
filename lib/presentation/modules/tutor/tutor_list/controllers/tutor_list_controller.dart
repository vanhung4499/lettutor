import 'package:get/get.dart';
import 'package:lettutor/data/models/tutor/tutor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TutorListController extends GetxController {
  var tutors = <Tutor>[].obs;
  var isFetching = false.obs;
  final RefreshController refreshController = RefreshController();

  @override
  void onInit() {
    super.onInit();
    fetchTutors();
  }

  fetchTutors() async {
    print('fetching tutors');
    isFetching.value = true;

    tutors.add(Tutor.getMockTutor());
    // TODO: fetch tutors from api

    refreshController.refreshCompleted();
    isFetching.value = false;
  }
}

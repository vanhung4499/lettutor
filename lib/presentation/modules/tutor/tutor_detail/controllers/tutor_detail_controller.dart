import 'package:get/get.dart';
import 'package:lettutor/data/models/tutor/tutor.dart';

class TutorDetailController extends GetxController {

  var isFetching = false.obs;
  late Tutor tutor;

  @override
  void onInit() {
    final userId = Get.parameters;
    fetchTutor(userId);
    super.onInit();
  }

  fetchTutor(id) async {
    isFetching.value = true;

    // TODO: fetch tutor from api
    print('fetching tutor $id');

    tutor = Tutor.getMockTutor();

    isFetching.value = true;

  }
}
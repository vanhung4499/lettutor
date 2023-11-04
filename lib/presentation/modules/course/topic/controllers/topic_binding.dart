import 'package:get/get.dart';

import 'topic_controller.dart';

class TopicBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TopicController>(() => TopicController());
  }
}

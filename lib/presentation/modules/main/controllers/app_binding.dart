import 'package:get/get.dart';
import 'package:lettutor/data/providers/local/local_storage.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() async {
    injectStorageProvider();
  }

  void injectStorageProvider() {
    Get.put(LocalStorage(), permanent: true);
  }
}

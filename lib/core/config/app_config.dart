import 'package:lettutor/core/constants/image_constant.dart';

class AppConfig {
  // Splash
  String imageUrl = ImageConstant.defaultImage;
  // Onboard

  // Constructor
  AppConfig({
    this.imageUrl = ImageConstant.defaultImage,
  });

  AppConfig.fromJson(dynamic data) {
    imageUrl = data['image_url'].toString();
  }
}

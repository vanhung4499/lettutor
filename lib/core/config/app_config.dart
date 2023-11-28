import 'package:lettutor/core/constants/image_constant.dart';

class AppConfig {
  // Splash
  String imageUrl = ImageConstant.baseImageView;
  // Onboard

  // Constructor
  AppConfig({
    this.imageUrl = ImageConstant.baseImageView,
  });

  AppConfig.fromJson(dynamic data) {
    imageUrl = data['image_url'].toString();
  }
}

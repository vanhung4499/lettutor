import 'package:get/get.dart';
import 'package:lettutor/data/models/topic.dart';
import 'package:lettutor/presentation/modules/course/course_detail/controllers/course_detail_binding.dart';
import 'package:lettutor/presentation/modules/course/course_detail/course_detail_screen.dart';
import 'package:lettutor/presentation/modules/course/topic/controllers/topic_binding.dart';
import 'package:lettutor/presentation/modules/course/topic/topic_screen.dart';
import 'package:lettutor/presentation/modules/home/controllers/home_binding.dart';
import 'package:lettutor/presentation/modules/home/home_screen.dart';
import 'package:lettutor/presentation/modules/splash/controllers/splash_binding.dart';
import 'package:lettutor/presentation/modules/splash/splash_screen.dart';
import 'package:lettutor/presentation/modules/tutor/tutor_detail/controllers/tutor_detail_binding.dart';
import 'package:lettutor/presentation/modules/tutor/tutor_detail/tutor_detail_screen.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.COURSE_DETAIL,
      page: () => CourseDetailScreen(),
      binding: CourseDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.TUTOR_DETAIL,
      page: () => TutorDetailScreen(),
      binding: TutorDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.TOPIC,
      page: () => TopicScreen(),
      binding: TopicBinding(),
    ),
  ];
}

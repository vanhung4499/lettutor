part of 'app_pages.dart';

abstract class AppRoutes {
  static const SPLASH = '/splash';

  static const AUTH = '/auth';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const RESET_PASSWORD = '/reset-password';
  static const VERIFY_EMAIL = '/verify-email';

  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const SETTING = '/setting';

  static const COURSES = '/courses';
  static const COURSE_DETAIL = '/course-detail';

  static const TUTORS = '/tutors';
  static const TUTOR_DETAIL = '/tutor-detail';

  static const SCHEDULE = '/schedule';
  static const LESSON = '/lesson';
  static const SEARCH = '/search';
  static const CHAT = '/chat';
  static const NOTIFICATION = '/notification';
  static const TOPIC = '/topic';
}

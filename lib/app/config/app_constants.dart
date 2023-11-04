import 'package:flutter/material.dart';

class AppConstants {
  static const String someThingWrongPlsTryAgain = 'someThingWrongPlsTryAgain';
  static const String tittleExitApp = 'tittleExitApp';
  static const String home = 'home';
  static const String news = 'news';
  static const String search = 'search';
  static const String more = 'more';
  static const String begin = 'begin';
  static const String event = 'event';
  static const String reward = 'reward';
  static const String profile = 'profile';
  static const String forgotPasswordInLogin = 'forgotPassword?';
  static const String dontHaveAnAcount = 'donHaveAnAcount';
  static const String alreadyHaveAnAccount = 'alreadyHaveAnAccount';
  static const String btnSignUp = 'btnSignUp';
  static const String btnSignIn = 'btnSignIn';
  static const String enterYourPhone = 'enterYourPhone';
  static const String enterYourEmail = 'enterYourEmail';
  static const String enterYourPassword = 'enterYourPassword';
  static const String passwordIsRequired = 'passwordIsRequired';
  static const String emailIsRequired = 'emailIsRequired';
  static const String textErrorPassword = 'textErrorPassword';
  static const String textErrorEmail = 'textErrorEmail';
  static const String courseDetail = 'courseDetail';
  static const String overview = 'overview';
  static const String courseReasonTitle = 'courseReasonTitle';
  static const String coursePurposeTitle = 'coursePurposeTitle';
  static const String courseLevelTitle = 'courseLevelTitle';
  static const String courseLengthTitle = 'courseLengthTitle';
  static const String courseFeeTitle = 'courseFeeTitle';
  static const String topic = 'topic';
  static const String topics = 'topics';
  static const String list = 'list';
  static const String tutor = 'tutor';
  static const String tutors = 'tutors';
  static const String tutorDetail = 'tutorDetail';
  static const String schedule = 'schedule';
  static const String lesson = 'lesson';
  static const String chat = 'chat';
  static const String notification = 'notification';
  static const String setting = 'setting';
  static const String logout = 'logout';
  static const String forgotPassword = 'forgotPassword';
  static const String resetPassword = 'resetPassword';
  static const String verifyEmail = 'verifyEmail';
  static const String phoneNumber = 'phoneNumber';
  static const String phoneNumberIsInvalid = 'phoneNumberIsInvalid';
  static const String bookNow = 'bookNow';


  static const String or = 'or';
  static const String ok = 'ok';
  static const String phoneNumberIsRequired = 'phoneNumberIsRequired';

  static const double largeText = 40.0;
  static const double normalText = 22.0;
  static const double smallText = 16.0;
  static const double tinyText = 12.0;

  static const double smallPadding = 6.0;
  static const double defaultPadding = 16.0;
  static const double height25 = 25.0;

  static const kTitleTextStyle =
      TextStyle(fontSize: 35, fontWeight: FontWeight.bold);
  static final kSecondaryTextStyle = TextStyle(
    color: Colors.grey.shade400,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    fontFamily: "Varela",
  );
  final kDonutCardTextStyle = const TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  double baseHeight = 650.0;

  double screenAwareSize(double size, BuildContext context) {
    return size * MediaQuery.of(context).size.height / baseHeight;
  }
}

const double baseHeight = 650.0;

double screenAwareSize(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.height / baseHeight;
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}

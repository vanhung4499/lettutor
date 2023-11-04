import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/routes/app_pages.dart';
import 'package:lettutor/app/utils/focus.dart';
import 'package:lettutor/app/utils/regex.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isHidePassword = true.obs;
  final isDisableButton = true.obs;
  final errorMessage = ''.obs;

  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  String get _email => emailController.text;
  String get _password => passwordController.text;

  @override
  void onInit() {
    super.onInit();
    emailController.text = 'test@gmail.com';
    passwordController.text = '12345678';
  }

  void hideKeyboard() {
    emailFocus.unfocus();
    passwordFocus.unfocus();
  }

  bool isEmailRegrex(String input) {
    return Regex.isEmail(input);
  }

  void hideErrorMessage() {
    errorMessage.value = '';
  }

  void toggleHidePassword(RxBool isVisible) {
    isVisible.value = !isVisible.value;
  }

  void updateLoginButtonState() {
    isDisableButton.value = _email.isEmpty || _password.isEmpty;
  }

  void onTapLogin(BuildContext context) {
    AppFocus.unfocus(context);
    if (loginFormKey.currentState!.validate()) {
      Get.offAllNamed(AppRoutes.HOME);
      //TODO: call api login
    }
  }
}

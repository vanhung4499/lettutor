import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/config/app_colors.dart';
import 'package:lettutor/app/utils/size_utils.dart';
import 'package:lettutor/app/widgets/normal_button.dart';
import 'package:lettutor/presentation/modules/auth/login/controllers/login_controller.dart';

import 'widgets/login_form.dart';

class LoginScreen extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: NormalButton(
        onPressed: () => controller.hideKeyboard(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.backgroundColor,
            body: Padding(
              padding: getPadding(
                left: 20,
                right: 20,
                top: 105,
              ),
              child: LoginForm(),
            )),
      ),
    );
  }
}

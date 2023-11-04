import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/config/app_constants.dart';
import 'package:lettutor/app/config/app_images.dart';
import 'package:lettutor/app/config/app_text_styles.dart';
import 'package:lettutor/app/theme/theme_helper.dart';
import 'package:lettutor/app/utils/regex.dart';
import 'package:lettutor/app/utils/size_utils.dart';
import 'package:lettutor/app/widgets/custom_icon_button.dart';
import 'package:lettutor/app/widgets/input_field.dart';
import 'package:lettutor/app/widgets/primary_button.dart';
import '../../widgets/or_devider.dart';
import '../../widgets/social_auth.dart';
import '../controllers/login_controller.dart';

class LoginForm extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.loginFormKey,
      child: Column(
        children: [
          Text(
            AppConstants.btnSignIn.tr,
            style: AppTextStyles.titleSignInBlack700,
          ),
          const SizedBox(
            height: AppConstants.defaultPadding / 0.5,
          ),
          Padding(
            padding: getPadding(top: 36),
            child: InputField(
                controller: controller.emailController,
                hintText: AppConstants.enterYourEmail.tr,
                icon: AppImages.iconMail,
                focusNode: controller.emailFocus,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppConstants.emailIsRequired.tr;
                  }
                  if (!Regex.isEmail(value)) {
                    return AppConstants.textErrorEmail.tr;
                  }
                  return null;
                }),
          ),
          Padding(
            padding: getPadding(top: 16),
            child: Obx(
              () => InputField(
                controller: controller.passwordController,
                hintText: AppConstants.enterYourPassword.tr,
                suffixIcon: CustomIconButton(
                  onPressed: () =>
                      controller.toggleHidePassword(controller.isHidePassword),
                  child: Padding(
                    padding: getPadding(all: 5),
                    child: SvgPicture.asset(
                      controller.isHidePassword.value
                          ? AppImages.imgHiddenPassWord
                          : AppImages.icShowPassWord,
                      color: appTheme.gray500,
                    ),
                  ),
                ),
                icon: AppImages.iconPassword,
                obscureText: controller.isHidePassword.value,
                focusNode: controller.passwordFocus,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppConstants.passwordIsRequired.tr;
                  }
                  if (!Regex.isPasswordAtLeast6Characters(value)) {
                    return AppConstants.textErrorPassword.tr;
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding + 18),
          PrimaryButton(
            text: AppConstants.btnSignIn.tr,
            onPressed: () => controller.onTapLogin(context),
          ),
          SizedBox(height: getSize(120)),
          OrDivider(),
          SizedBox(height: getSize(40)),
          SocialAuth(),
          SizedBox(height: getSize(40)),
        ],
      ),
    );
  }
}

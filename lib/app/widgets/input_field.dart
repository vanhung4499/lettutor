import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/config/app_colors.dart';
import 'package:lettutor/app/config/app_constants.dart';
import 'package:lettutor/app/config/app_text_styles.dart';
import 'package:lettutor/app/theme/theme_helper.dart';
import 'package:lettutor/app/utils/size_utils.dart';
import 'package:lettutor/presentation/main/app_controller.dart';

class InputField extends StatelessWidget {
  final void Function(String?)? onSaved;

  final String hintText;
  final String? icon;
  final bool obscureText;
  final bool? enableTexfield;
  final bool? isBorder;
  final Color? leadingIconColor;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final IconButton? iconButton;
  final Widget? suffixIcon;
  final String? initValue;
  final void Function(String)? onChanged;
  final bool digitsOnly;
  final double? paddingIcon;
  bool validate = false;
  bool checkBackgroundColorTextfield;

  List<TextInputFormatter>? inputFormatters;
  InputField({
    Key? key,
    required this.hintText,
    this.icon,
    this.leadingIconColor,
    this.obscureText = false,
    this.enableTexfield = true,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.onSaved,
    this.focusNode,
    this.isBorder,
    this.validator,
    this.iconButton,
    this.suffixIcon,
    this.initValue,
    this.inputFormatters,
    this.onChanged,
    this.digitsOnly = false,
    this.paddingIcon,
    this.checkBackgroundColorTextfield = false,
  }) : super(key: key);

  PrimaryColors get appTheme => ThemeHelper().themeColor();
  final AppController appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      validator: validator,
      keyboardType: digitsOnly ? TextInputType.number : keyboardType,
      textInputAction: textInputAction,
      cursorColor: AppColors.kPrimaryColor,
      controller: controller,
      onSaved: onSaved,
      focusNode: focusNode,
      obscureText: obscureText,
      initialValue: initValue,
      style: TextStyle(
        color: checkBackgroundColorTextfield == true
            ? appController.isDarkModeOn.value
                ? AppColors.white
                : AppColors.black
            : AppColors.black,
      ),
      decoration: InputDecoration(
        suffixIconConstraints:
            const BoxConstraints(maxHeight: 60, maxWidth: 60),
        contentPadding: getPadding(all: 10),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: AppTextStyles.lableTextInput500,
        prefixIcon: Padding(
          padding: paddingIcon != null
              ? EdgeInsets.all(paddingIcon!)
              : const EdgeInsets.all(AppConstants.defaultPadding),
          child: SizedBox(
            height: getSize(20),
            width: getSize(20),
            child: icon != null
                ? SvgPicture.asset(
                    icon ?? "",
                    color: leadingIconColor ?? AppColors.grey,
                  )
                : null,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: isBorder ?? false
              ? BorderSide(color: appTheme.gray400)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(5.0),
        ),
        filled: true,
        fillColor: checkBackgroundColorTextfield == true
            ? appController.isDarkModeOn.value
                ? AppColors.grey800
                : AppColors.white
            : AppColors.white,
      ),
      enabled: enableTexfield,
    );
  }
}

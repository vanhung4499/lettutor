import 'package:flutter/material.dart';
import 'package:lettutor/app/config/app_text_styles.dart';
import 'package:lettutor/app/theme/theme_helper.dart';
import 'package:lettutor/app/utils/size_utils.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getSize(46),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.blue400,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.titleMediumWhiteA700,
        ),
      ),
    );
  }
}

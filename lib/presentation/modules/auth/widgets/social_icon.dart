import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lettutor/app/config/app_colors.dart';
import 'package:lettutor/app/utils/size_utils.dart';
import 'package:lettutor/app/widgets/custom_icon_button.dart';

class SocialIcon extends StatelessWidget {
  final String? iconSrc;
  final Function? press;
  final double? width;
  final double? height;
  const SocialIcon({
    Key? key,
    this.iconSrc,
    this.press,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getSize(56),
      width: getSize(108),
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.only(
        right: 30,
        left: 30,
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.nearlyWhite,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.01),
            spreadRadius: 3,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CustomIconButton(
        onPressed: press as void Function()?,
        child: SvgPicture.asset(
          iconSrc!,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

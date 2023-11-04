import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lettutor/app/config/app_images.dart';

import 'social_icon.dart';

class SocialAuth extends StatelessWidget {
  const SocialAuth({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isIOS = Platform.isIOS;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        if (isIOS) ...[
          SocialIcon(iconSrc: AppImages.iconApple, press: () async {}),
          Spacer(),
        ],
        SocialIcon(iconSrc: AppImages.iconGoogle, press: () {}),
        Spacer(),
        SocialIcon(iconSrc: AppImages.iconZalo, press: () {}),
        Spacer(),
      ],
    );
  }
}

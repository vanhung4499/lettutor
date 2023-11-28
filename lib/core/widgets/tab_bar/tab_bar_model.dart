import 'package:flutter/material.dart';
import 'package:lettutor/core/constants/image_constant.dart';


class TabBarModel{
  final IconData iconData;
  final String svgAsset;
  final String title;
  final Widget screen;
  TabBarModel({
    this.iconData = Icons.home,
    this.svgAsset = ImageConstant.homeIcon,
    this.title = '',
    this.screen = const SizedBox(),
  });
}
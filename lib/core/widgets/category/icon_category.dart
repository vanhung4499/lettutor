import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lettutor/core/constants/image_constant.dart';

import '../image_custom.dart';
import 'category_custom.dart';

class IconCategory extends StatelessWidget {
  const IconCategory({
    super.key,
    required this.category,
  });

  final CategoryStyle category;

  @override
  Widget build(BuildContext context) {
    String imageUrl = category.iconUrl ??
        switch (category.typeImage) {
          TypeImage.assetImage => '', // add assets image,
          TypeImage.assetSvg => ImageConstant.homeIcon,
          _ => ImageConstant.baseImageView,
        };
    if (category.isIcon) {
      return Icon(
        category.iconWidget,
        color: category.color,
        size: category.iconSize,
      );
    }
    return category.typeImage == TypeImage.assetSvg
        ? SvgPicture.asset(
      imageUrl,
      color: category.color,
      width: category.iconSize,
      height: category.iconSize,
    )
        : ImageCustom(
      imageUrl: imageUrl,
      isNetworkImage: false,
      color: category.color,
      width: category.iconSize,
      height: category.iconSize,
    );
  }
}

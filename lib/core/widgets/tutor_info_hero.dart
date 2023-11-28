import 'package:flutter/material.dart';
import 'package:lettutor/core/constants/constants.dart';
import 'package:lettutor/core/constants/image_constant.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/utils/country.dart';
import 'package:lettutor/core/widgets/image_custom.dart';
import 'package:lettutor/core/widgets/rating_bar_custom.dart';
import 'package:lettutor/domain/entities/tutor/tutor.dart';

class TutorInfoHero extends StatelessWidget {
  const TutorInfoHero({
    super.key,
    required this.tutor,
    this.onFavoriteTap,
    this.showRatting = true,
    this.showFavorite = true,
    this.isLiked,
  }) : assert(showFavorite ? isLiked != null : true);

  final Tutor tutor;
  final Function()? onFavoriteTap;
  final bool? isLiked;
  final bool showRatting;
  final bool showFavorite;

  Widget get favoriteIcon => (isLiked ?? false)
      ? const Icon(Icons.favorite, color: Colors.red)
      : const Icon(Icons.favorite_outline, color: Colors.red);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: ImageCustom(
            imageUrl: tutor.avatar ?? ImageConstant.defaultImage,
            isNetworkImage: true,
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tutor.name ?? '',
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2.0),
              if (tutor.country?.isNotEmpty ?? false) ...[
                Text(
                  '${countryCodeToEmoji(tutor.country!)} ${Constant.countries[tutor.country!.toUpperCase()]!}',
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(height: 2.0),
              ],
              if (showRatting) RatingBarCustom(rating: tutor.rating ?? 0.0)
            ],
          ),
        ),
        if (showFavorite && (isLiked != null))
          IconButton(onPressed: onFavoriteTap, icon: favoriteIcon)
      ],
    );
  }
}

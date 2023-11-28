import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/core/constants/image_constant.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/utils/country.dart';
import 'package:lettutor/core/utils/validator.dart';
import 'package:lettutor/core/widgets/image_custom.dart';
import 'package:lettutor/core/widgets/rating_bar_custom.dart';
import 'package:lettutor/domain/entities/tutor/tutor.dart';
import 'package:lettutor/routes/routes.dart';

class SimpleTutorCard extends StatelessWidget {
  const SimpleTutorCard({
    super.key,
    required this.tutor,
    required this.isFirstItem,
  });
  final bool isFirstItem;

  final Tutor tutor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.openPageWithRouteAndParams(Routes.tutorDetail, tutor.userId),
      child: Container(
        width: context.widthDevice * 0.55,
        margin: EdgeInsets.only(
            left: isFirstItem ? 10 : 0, right: 10.0, top: 10.0, bottom: 10.0),
        height: double.infinity,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 5.0,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: ImageCustom(
                      imageUrl: tutor.avatar ?? ImageConstant.defaultImage,
                      isNetworkImage: true,
                      width: 50.0,
                      height: 50.0,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(tutor.name ?? '', style: context.titleMedium),
                        RatingBarCustom(
                            rating: tutor.rating ?? 0.0, itemSize: 15.0)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            Expanded(
              flex: 2,
              child: Text(
                tutor.bio ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.titleSmall
                    .copyWith(fontWeight: FontWeight.w400, fontSize: 12.0),
              ),
            ),
            Divider(color: Theme.of(context).primaryColor, thickness: 0.3),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        tutor.targetStudent ?? '',
                        style: context.titleSmall
                            .copyWith(color: Colors.white, fontSize: 12.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Validator.countryCodeValid(tutor.country)
                        ? Text(
                      // CountryCode.fromCountryCode(
                      //   data.country!.toUpperCase(),
                      // ).name ??
                      countryCodeToEmoji(tutor.country!) ?? '',
                      style: context.titleSmall.copyWith(fontSize: 24.0),
                    )
                        : const SizedBox(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

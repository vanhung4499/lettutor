import 'package:flutter/material.dart';
import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/domain/entities/tutor/tutor.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/widgets/button_custom.dart';
import 'package:lettutor/core/widgets/tutor_info_hero.dart';
import 'package:lettutor/generated/l10n.dart';
import 'package:lettutor/routes/routes.dart';

class TutorCard extends StatelessWidget {
  final Tutor tutor;
  final bool isLiked;
  final Function()? onFavoriteTap;
  final Function()? onTap;
  const TutorCard({
    super.key,
    this.onFavoriteTap,
    this.onTap,
    this.isLiked = false,
    required this.tutor,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.1),
                blurRadius: 5.0)
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TutorInfoHero(
                tutor: tutor, onFavoriteTap: onFavoriteTap, isLiked: isLiked),
            if (tutor.specialties != null)
              Wrap(
                children: [
                  ...tutor.specialties!.split(',').map(
                        (e) => Container(
                      margin: const EdgeInsets.all(2.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: primaryColor.withOpacity(0.2),
                      ),
                      child: Text(
                        e.replaceAll('-', ' '),
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            if (tutor.bio != null)
              Text(
                tutor.bio ?? '',
                maxLines: 4,
                style: context.titleSmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).hintColor,
                  overflow: TextOverflow.fade,
                ),
              ),
            // const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonCustom(
                  borderColor: primaryColor,
                  color: Theme.of(context).cardColor,
                  enableWidth: false,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.credit_card, color: primaryColor),
                      const SizedBox(width: 5.0),
                      Text(
                        S.of(context).book,
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  onPress: () {
                    // context.openPageWithRouteAndParams(
                    //   Routes.tutorSchedule,
                    //   tutor.id,
                    // );
                  },
                ),
              ],
            )
          ].expand((e) => [e, const SizedBox(height: 5.0)]).toList()
            ..removeLast(),
        ),
      ),
    );
  }
}
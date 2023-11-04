import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/config/app_colors.dart';
import 'package:lettutor/app/config/app_constants.dart';
import 'package:lettutor/app/config/app_text_styles.dart';
import 'package:lettutor/app/routes/app_pages.dart';
import 'package:lettutor/app/theme/app_decoration.dart';
import 'package:lettutor/data/models/tutor/tutor.dart';
import 'package:lettutor/presentation/modules/tutor/widgets/tutor_hero.dart';

class TutorCard extends StatelessWidget {
  final Tutor tutor;
  const TutorCard({required this.tutor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 2,
        child: Container(
          decoration: AppDecorations.fill,
          child: InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.TUTOR_DETAIL, arguments: tutor.id);
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: <Widget>[
                        TutorHero(
                          tutorDetail: tutor.tutorDetail,
                          height: 100,
                          showRating: true,
                          rating: tutor.rating,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Wrap(
                            spacing: 0.0,
                            runSpacing: 0.0,
                            alignment: WrapAlignment.start,
                            clipBehavior: Clip.none,
                            children: [
                              ...tutor.specialties.split(',')
                                  .map((e) => Chip(label: Text(e))).toList(),
                            ],
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Text(
                            tutor.bio ?? '',
                            style: AppTextStyles.bodyMediumGray600,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            textAlign: TextAlign.justify,

                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}

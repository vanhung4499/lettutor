import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lettutor/app/config/app_images.dart';
import 'package:lettutor/app/config/app_text_styles.dart';
import 'package:lettutor/data/models/tutor/tutor_detail.dart';

class TutorHero extends StatelessWidget {
  const TutorHero({
    required this.tutorDetail,
    required this.height,
    required this.showRating,
    required this.rating,
  });

  final TutorDetail tutorDetail;
  final double height;
  final bool showRating;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(900.0),
            child: FadeInImage.assetNetwork(
              image: tutorDetail.avatar,
              width: 70,
              height: 70,
              fit: BoxFit.fitWidth,
              placeholder: AppImages.iconBottomProfile,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  AppImages.iconBottomProfile,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      tutorDetail.name ?? 'N/A',
                      style: AppTextStyles.labelBlack500Size24Fw700,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.flag,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                        Text(
                          tutorDetail.country ?? 'N/A',
                          style: AppTextStyles.labelBlack500Size18Fw500,
                        ),
                      ],
                    ),
                    showRating
                        ?  RatingBar.builder(
                              initialRating: rating,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                              },
                            )
                        : SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

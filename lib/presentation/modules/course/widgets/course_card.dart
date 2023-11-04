import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/config/app_constants.dart';
import 'package:lettutor/app/config/app_images.dart';
import 'package:lettutor/app/config/app_text_styles.dart';
import 'package:lettutor/app/routes/app_pages.dart';
import 'package:lettutor/data/models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 4.0,
        child: Container(
          height: 400,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(150, 229, 222, 222),
                Colors.white10,
                Colors.white
              ],
            ),
          ),
          child: InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.COURSE_DETAIL, arguments: course);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Hero(
                          tag: course.id,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: FadeInImage.assetNetwork(
                              image: course.imageUrl,
                              fit: BoxFit.fitWidth,
                              placeholder: AppImages.logo,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  AppImages.logo,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          course.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelBlack500Size24Fw600,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          course.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleSmallBlack700,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${course.topics.length} ${course.topics.length > 1 ? 'topics' : 'topic'}',
                          style: AppTextStyles.labelBlack500Size18Fw500,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/config/app_constants.dart';
import 'package:lettutor/app/config/app_images.dart';
import 'package:lettutor/app/config/app_text_styles.dart';
import 'package:lettutor/app/routes/routes.dart';
import 'package:lettutor/data/models/course.dart';
import './controllers/course_detail_controller.dart';

class CourseDetailScreen extends GetView<CourseDetailController> {
  final Course course = Get.arguments;

  CourseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.courseDetail.tr,
          overflow: TextOverflow.fade,
          style: AppTextStyles.labelBlack500Size24Fw700,
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.grey[100],
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  Hero(
                    tag: course.id,
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
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      course.name,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelBlack500Size24Fw700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      course.description,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMediumGray400,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(AppConstants.defaultPadding),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppConstants.overview.tr,
                      style: AppTextStyles.labelBlack500Size24Fw700,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppConstants.courseReasonTitle.tr,
                      style: AppTextStyles.labelBlack500Size24Fw600,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      course.reason,
                      style: AppTextStyles.bodySmallGray600,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppConstants.coursePurposeTitle.tr,
                      style: AppTextStyles.labelBlack500Size24Fw600,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      course.purpose,
                      style: AppTextStyles.bodySmallGray600,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(AppConstants.defaultPadding),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppConstants.courseLevelTitle.tr,
                      style: AppTextStyles.labelBlack500Size24Fw700,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      course.level,
                      style: AppTextStyles.labelBlack500Size24Fw600,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppConstants.courseLengthTitle.tr,
                      style: AppTextStyles.labelBlack500Size24Fw700,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${course.topics.length} ${course.topics.length > 1 ? AppConstants.topics.tr : AppConstants.topic.tr}',
                      style: AppTextStyles.labelBlack500Size24Fw600,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(AppConstants.defaultPadding),
                alignment: Alignment.centerLeft,
                child: Column(children: <Widget>[
                  Text(
                    '${AppConstants.list.tr} ${AppConstants.topics.tr}',
                    style: AppTextStyles.labelBlack500Size24Fw700,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: course.topics.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.TOPIC,
                              arguments: course.topics[index],
                            );
                          },
                          title: Text(
                            '${index + 1}. ${course.topics[index].name}',
                            style: AppTextStyles.labelBlack500Size24Fw600,
                          ),
                          trailing: const Icon(Icons.more_vert),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

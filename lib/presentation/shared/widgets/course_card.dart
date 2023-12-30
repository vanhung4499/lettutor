import 'package:flutter/material.dart';
import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/core/constants/image_constant.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/extensions/string_extension.dart';
import 'package:lettutor/core/widgets/image_custom.dart';
import 'package:lettutor/core/widgets/skeleton_custom.dart';
import 'package:lettutor/domain/entities/course/course.dart';
import 'package:lettutor/routes/routes.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () =>
        context.openPageWithRouteAndParams(Routes.courseDetail, course.id),
    child: Stack(
      children: [
        Container(
          width: double.infinity,
          margin:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.3),
                blurRadius: 5.0,
              )
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: ImageCustom(
                  imageUrl: course.imageUrl ?? ImageConstant.defaultImage,
                  isNetworkImage: true,
                  width: 120,
                  height: 120,
                  loadingWidget: SkeletonContainer.rounded(
                    width: 120,
                    height: 120,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: context.titleMedium
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      course.description,
                      style: context.titleSmall
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    Row(
                      children: [
                        Text(
                          '${(course.level ?? '0').renderExperienceText} - ${course.topics.length} lessons',
                          style: context.titleSmall.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      ],
                    ),
                  ].expand((e) => [e, const SizedBox(height: 5.0)]).toList()
                    ..removeLast(),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 5.0,
          left: 10.0,
          child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: Text(
              (course.level ?? '0').renderExperienceText,
              style: context.titleSmall.copyWith(color: Colors.white),
            ),
          ),
        )
      ],
    ),
  );
}

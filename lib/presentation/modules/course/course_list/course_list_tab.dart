import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lettutor/presentation/modules/course/widgets/course_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './controllers/course_list_controller.dart';

class CourseListTab extends GetView<CourseListController> {
  const CourseListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        Flexible(
          child: Obx(
            () => SmartRefresher(
              physics: const BouncingScrollPhysics(),
              controller: controller.refreshController,
              onRefresh: () async {
                await controller.fetchCourses();
              },
              child: (controller.courses.isEmpty)
                  ? AnimatedOpacity(
                      opacity: (controller.courses.isNotEmpty ||
                              controller.isFetching.value)
                          ? 0.5
                          : 1,
                      duration: const Duration(milliseconds: 500),
                      child: const Center(
                        child: Text('No courses found'),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.courses.length,
                      itemBuilder: (context, index) {
                        return CourseCard(
                          course: controller.courses[index],
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

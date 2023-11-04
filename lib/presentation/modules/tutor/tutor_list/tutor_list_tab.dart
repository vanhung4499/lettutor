import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lettutor/presentation/modules/tutor/tutor_list/controllers/tutor_list_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widgets/tutor_card.dart';

class TutorListTab extends GetView<TutorListController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Flexible(
          child: Obx(
            () => SmartRefresher(
              physics: const BouncingScrollPhysics(),
              controller: controller.refreshController,
              onRefresh: () async {
                await controller.fetchTutors();
              },
              child:
                  (controller.tutors.isEmpty || controller.isFetching.value)
                      ? AnimatedOpacity(
                          opacity: (controller.tutors.isNotEmpty ||
                                  controller.isFetching.value)
                              ? 0.5
                              : 1,
                          duration: const Duration(milliseconds: 500),
                          child: const Center(
                            child: Text('No tutors found'),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.tutors.length,
                          itemBuilder: (context, index) {
                            return TutorCard(
                              tutor: controller.tutors[index],
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

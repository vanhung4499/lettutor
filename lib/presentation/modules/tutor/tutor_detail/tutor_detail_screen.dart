import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/config/app_constants.dart';
import 'package:lettutor/app/config/app_text_styles.dart';
import 'package:lettutor/app/routes/app_pages.dart';
import 'package:lettutor/app/widgets/primary_button.dart';
import 'package:lettutor/presentation/modules/tutor/tutor_detail/controllers/tutor_detail_controller.dart';
import 'package:lettutor/presentation/modules/tutor/widgets/tutor_hero.dart';

class TutorDetailScreen extends GetView<TutorDetailController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.tutorDetail.tr,
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
        child: Container(
          child:SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      TutorHero(
                          tutorDetail: controller.tutor.tutorDetail,
                          height: 100,
                          showRating: true,
                          rating: controller.tutor.rating
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        controller.tutor.bio,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      PrimaryButton(
                          text: AppConstants.bookNow.tr,
                          onPressed: () {
                            Get.toNamed(AppRoutes.SCHEDULE, arguments: controller.tutor);
                          },
                      ),
                      SizedBox(
                        height: 10,
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
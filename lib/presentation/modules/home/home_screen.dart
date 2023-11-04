import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/config/app_colors.dart';
import 'package:lettutor/app/config/app_constants.dart';
import 'package:lettutor/app/config/app_text_styles.dart';
import 'package:lettutor/app/config/app_widgets.dart';
import 'package:lettutor/app/routes/app_pages.dart';
import 'package:lettutor/app/widgets/custom_bottom_navigation_bar.dart';
import 'package:lettutor/presentation/modules/course/course_list/course_list_tab.dart';
import 'package:lettutor/presentation/modules/home/controllers/home_controller.dart';
import 'package:lettutor/presentation/modules/main/controllers/app_controller.dart';
import 'package:lettutor/presentation/modules/tutor/tutor_list/tutor_list_tab.dart';

class HomeScreen extends GetView<HomeController> {
  final AppController appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.tabpageIndex.value != 0) {
          controller.setValueBottomIndex(0);
          return false;
        }
        return controller.onWillPop();
      },
      child: Obx(
        () => Scaffold(
          backgroundColor: AppColors.kPrimaryColor,
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: _bottomNav(controller),
          appBar: AppBar(
            toolbarHeight: 65,
            backgroundColor: AppColors.kPrimaryColor,
            shadowColor: Colors.transparent,
            leading: Builder(
              builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: AppColors.nearlyWhite,
                    size: 30,
                  )),
            ),
            title: SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: TextField(
                  style: AppTextStyles.labelBlack500Size12Fw600,
                  readOnly: true,
                  decoration: searchTextfieldDecoration,
                  onTap: () => Get.toNamed(AppRoutes.SEARCH),
                ),
              ),
            ),
            actions: [
              Stack(
                children: [
                  Center(
                    child: IconButton(
                      onPressed: () => Get.toNamed(AppRoutes.CHAT),
                      icon: const Icon(
                        Icons.chat_rounded,
                        color: AppColors.nearlyWhite,
                        size: 28,
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 15,
                    right: 10,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 280),
                      opacity: 1,
                      child: Icon(Icons.brightness_1,
                          size: 12.0, color: Colors.green),
                    ),
                  )
                ],
              ),
            ],
          ),
          body: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: Container(
              height: Get.height - 25 - kBottomNavigationBarHeight,
              width: Get.width,
              decoration: const BoxDecoration(
                color: AppColors.nearlyWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: PageView(
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) =>
                    {controller.setValueBottomIndex(index)},
                controller: controller.pageController,
                children: _widgetOptions(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomNav(HomeController controller) {
    return Obx(
      () => CustomBottomNavigationBar(
        selectedIndex: controller.tabpageIndex.value,
        color: appController.isDarkModeOn.value
            ? Colors.white
            : AppColors.grey.withOpacity(.6),
        backgroundColor: appController.isDarkModeOn.value
            ? Colors.grey[800]
            : AppColors.white,
        selectedColor: appController.isDarkModeOn.value
            ? AppColors.colorDarkModeBlue
            : AppColors.kPrimaryColor,
        notchedShape: const CircularNotchedRectangle(),
        onTabSelected: (index) =>
            controller.onBottomNavigationBarChanged(index),
        items: [
          BottomBarItem(
            iconData: controller.tabpageIndex.value == 0
                ? controller.bottomNavSelectedIconPaths[0]
                : controller.imagePaths[0],
            text: AppConstants.home.tr,
          ),
          BottomBarItem(
            iconData: controller.tabpageIndex.value == 1
                ? controller.bottomNavSelectedIconPaths[1]
                : controller.imagePaths[1],
            text: AppConstants.event.tr,
          ),
          BottomBarItem(
            iconData: controller.tabpageIndex.value == 2
                ? controller.bottomNavSelectedIconPaths[2]
                : controller.imagePaths[2],
            text: AppConstants.reward.tr,
          ),
          BottomBarItem(
            iconData: controller.tabpageIndex.value == 3
                ? controller.bottomNavSelectedIconPaths[3]
                : controller.imagePaths[3],
            text: AppConstants.profile.tr,
          ),
        ],
      ),
    );
  }

  List<Widget> _widgetOptions() {
    return [
      CourseListTab(),
      TutorListTab(),
      Center(child: Text("Screen 3")),
      Center(child: Text("Screen 4")),
    ];
  }
}

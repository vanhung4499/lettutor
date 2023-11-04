import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/config/app_constants.dart';
import 'package:lettutor/app/config/app_images.dart';
import 'package:lettutor/app/lang/language.dart';
import 'package:lettutor/app/lang/translation_service.dart';
import 'package:lettutor/app/widgets/comon_widget.dart';
import 'package:lettutor/data/providers/local/local_storage.dart';
import 'package:lettutor/presentation/modules/home/controllers/tabs/tab_icon_data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  DateTime? currentBackPressTime;
  int tabIndex = 0;
  var targetPage = 0;
  var childTabIndex = 0.obs;
  var tabpageIndex = 0.obs;
  var needChangeNavigator = true;

  late TabController tabController;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  PageController pageController = PageController();
  final RefreshController refreshController = RefreshController();

  oncChildTabChanged(int index) {
    childTabIndex.value = index;
  }

  onPageChanged(int index) {
    if (index == targetPage && needChangeNavigator) {
      tabpageIndex.value = index;
      switch (index) {
        case 1:
          break;
        default:
          break;
      }
    }
  }

  final store = Get.find<LocalStorage>();

  final List<String> bottomNavSelectedIconPaths = [
    AppImages.iconBottomHomeBold,
    AppImages.iconBottomEventBold,
    AppImages.iconBottomRewardBold,
    AppImages.iconBottomProfileBold,
  ];

  final List<String> imagePaths = [
    AppImages.iconBottomHome,
    AppImages.iconBottomEvent,
    AppImages.iconBottomReward,
    AppImages.iconBottomProfile,
  ];

  @override
  void onInit() async {
    super.onInit();

    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      tabIndex = tabController.index;
    });
  }

  var _selectedLanguage = Language(1, "🇺🇸", "English", "en").obs;
  Language get selectedLanguage => _selectedLanguage.value;

  void handleLanguageSelection(Language? language) {
    if (language != null) {
      _selectedLanguage.value = language;
      String code = language.code;

      if (code == 'vi') {
        TranslationService.changeLocale('vi');
      } else if (code == 'en') {
        TranslationService.changeLocale('en');
      }

      print("You choose: ${language.name}");
    }
  }

  void resetState() => tabpageIndex.value = 0;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime ?? DateTime.now()) >
            const Duration(seconds: 2)) {
      currentBackPressTime = now;
      CommonWidget.toast(AppConstants.tittleExitApp.tr);
      return Future.value(false);
    }
    return Future.value(true);
  }

  void changeTabIndex(int index) {
    tabIndex = index;
  }

  void setValueBottomIndex(int index) {
    tabpageIndex.value = index;
  }

  onBottomNavigationBarChanged(int index) async {
    tabpageIndex.value = index;
    needChangeNavigator = false;
    await pageController.animateToPage(
      tabpageIndex.value,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    switch (index) {
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      default:
        break;
    }
    targetPage = index;
    needChangeNavigator = true;
  }

  @override
  void onClose() {
    super.dispose();
  }
}

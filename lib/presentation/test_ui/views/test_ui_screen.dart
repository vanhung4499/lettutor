import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/core/config/app_config.dart';
import 'package:lettutor/core/constants/image_constant.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/extensions/string_extension.dart';
import 'package:lettutor/core/layouts/search_layout/models/filter_model.dart';
import 'package:lettutor/core/layouts/search_layout/views/search_layout.dart';
import 'package:lettutor/core/layouts/setting_layout/views/setting_screen.dart';
import 'package:lettutor/core/mixins/app_mixin.dart';
import 'package:lettutor/core/widgets/button_custom.dart';
import 'package:lettutor/core/widgets/category/category_model.dart';
import 'package:lettutor/core/widgets/custom_text_field.dart';
import 'package:lettutor/core/widgets/pagination_view/pagination_list_view.dart';
import 'package:lettutor/core/config/setting_config.dart';
import 'package:lettutor/core/widgets/progress_button.dart';
import 'package:lettutor/core/widgets/tab_bar/tab_bar_custom.dart';
import 'package:lettutor/core/widgets/tab_bar/tab_bar_model.dart';
import 'package:lettutor/core/widgets/tab_bar/tab_bar_type.dart';
import 'package:lettutor/core/widgets/tree_view_custom/tree_view.dart';
import 'package:lettutor/core/widgets/video_player.dart';


class ModelTest {
  final String userName;
  final String bio;
  ModelTest({required this.userName, required this.bio});
}

class ModelImageTest {
  final String imageUrl;
  final String title;
  final String subTitle;
  ModelImageTest({
    required this.imageUrl,
    required this.title,
    required this.subTitle,
  });
}

class TestUi extends StatefulWidget {
  const TestUi({super.key});

  @override
  State<TestUi> createState() => _TestUiState();
}

class _TestUiState extends State<TestUi> with AppMixin {
  final ValueNotifier<int> _index = ValueNotifier<int>(0);

  final dashboardItem = <TabBarModel>[
    TabBarModel(
      svgAsset: ImageConstant.documentIcon,
      title: 'Favorite',
      screen: const PageTest5(),
    ),
    TabBarModel(
      svgAsset: ImageConstant.personIcon,
      title: 'Profile',
      screen: const PageTest6(),
    )
  ];

  @override
  void onComplete() async {
    await Future.delayed(const Duration(seconds: 3));
    log("hahahah");
  }

  @override
  AppConfig? get appConfig => AppConfig();

  @override
  Widget build(BuildContext context) {
    // onComplete.call();
    // return Scaffold(
    //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //   body: Column(
    //     children: [
    //       const Spacer(),
    //       imageShowWidget(splashType: SplashType.normalSplash),
    //       const SizedBox(height: 10.0),
    //       textApp(
    //         title: <String>['Weather', ' App'],
    //         style: [
    //           context.titleMedium.copyWith(fontWeight: FontWeight.w700),
    //           context.titleMedium.copyWith(
    //             color: Theme.of(context).primaryColor,
    //             fontWeight: FontWeight.w700,
    //           )
    //         ],
    //       ),
    //       const SizedBox(height: 20.0),
    //       loadingWidget(LoadingType.jumpingDot),
    //       const Spacer(),
    //     ],
    //   ),
    // );
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: TabBarCustom(
        radius: 15,
        elevation: 0.1, // => elevation
        tabBarType: TabBarType
            .dotTabBar, //if you want display test change to textTabBar
        // tabBarColor: Colors.black,
        iconSize: 23.0,
        iconSelectedColor: Theme.of(context).primaryColor,
        duration: 200, // => set animation when change tab
        isSvgIcon: true,
        animatedTabStyle: const AnimatedTabStyle(posHeight: 5),
        items: <TabBarItemStyle>[
          ...dashboardItem.map(
                (e) => TabBarItemStyle(
              title: e.title,
              assetIcon: e.svgAsset,
              iconData: e.iconData,
              screen: e.screen,
            ),
          ),
        ],
        onChangeTab: (index) => _index.value = index,
      ),
      body: ValueListenableBuilder(
        valueListenable: _index,
        builder: (context, index, child) {
          return IndexedStack(
            index: index,
            sizing: StackFit.expand,
            children: dashboardItem.map((e) => e.screen).toList(),
          );
        },
      ),
    );
  }
}

class PageTest6 extends StatelessWidget {
  const PageTest6({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingScreen(
      settingConfig: SettingConfig.fromJson({
        'enable_user': true,
        'setting_layout': 'view1',
        'app_bar_color': '07AEAF',
        'hPadding': 10.0,
        'vPadding': 10.0,
        'shadow_elevation': 0.2,
        'behindBackground':
        'https://wallpapers.com/images/featured/panda-background-ymceqx76sixgb2ni.jpg',
        'list_view': [
          'security',
          'lang',
          'currencies',
          'appearance',
          'notifications',
          'about',
        ],
      }),
    );
  }
}

class PageTest5 extends StatelessWidget {
  const PageTest5({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SearchLayout<ModelImageTest>(
      searchCall: (text, filters, currentPage) async {
        // log('hhdhdhdhhhh');
        await Future.delayed(const Duration(seconds: 3));
        return <ModelImageTest>[
          for (int t = 0; t < 10; t++)
            ModelImageTest(
              imageUrl: ImageConstant.baseImageView,
              title: 'Product t$text',
              subTitle: 'This is product $t of page $currentPage',
            ),
        ];
      },
      itemBuilder: (_, data) {
        return _itemBuilder(data);
      },
      groupHeaderStyle: GroupHeaderStyle(
        contentHeaderSearchPadding: const EdgeInsets.all(10.0),
        listFilter: _listFilter,
      ),
    );
  }

  Padding _itemBuilder(ModelImageTest data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(data.imageUrl),
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title),
                Text(data.subTitle),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<FilterModel> get _listFilter {
    return [
      PriceModel(
        header: 'By price',
        maxPrice: 10000,
        minPrice: 0.0,
      ),
      PriceModel(
        header: 'By Sale',
        maxPrice: 10000,
        minPrice: 0.0,
      ),
      CompareModel(compares: [
        Compare(
          headerCategory: 'Date',
          left: 'Latest',
          right: 'Oldest',
        ),
        Compare(
          headerCategory: 'Price',
          left: 'Low to Hight',
          right: 'Hight to Low',
        ),
      ], header: 'Compares'),
      CategoryModelSearch(
        header: 'Categories',
        categories: const [
          'Hahaha',
          'Hihihihihi',
          'Hohohoho',
          'Hehehe',
          'Huhuhu'
        ],
      )
    ];
  }
}

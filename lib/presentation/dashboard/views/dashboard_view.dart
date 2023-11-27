import 'package:flutter/material.dart';
import 'package:lettutor/presentation/dashboard/blocs/dashboard_bloc.dart';
import 'package:lettutor/presentation/home/blocs/home_bloc.dart';
import 'package:lettutor/presentation/home/views/home_screen.dart';
import 'package:lettutor/presentation/main/blocs/main_bloc.dart';
import 'package:lettutor/presentation/main/views/main_view.dart';
import 'package:lettutor/presentation/schedule/blocs/schedule_bloc.dart';
import 'package:lettutor/presentation/schedule/views/schedule_screen.dart';
import 'package:lettutor/presentation/tutor_list/blocs/tutor_list_bloc.dart';
import 'package:lettutor/presentation/tutor_list/views/tutor_list_screen.dart';
import 'package:lettutor/core/config/setting_config.dart';
import 'package:lettutor/core/constants/image_constant.dart';
import 'package:lettutor/core/layouts/setting_layout/views/setting_screen.dart';
import 'package:lettutor/core/widgets/tab_bar/tab_bar_model.dart';
import 'package:lettutor/core/widgets/tab_bar/tab_bar_type.dart';
import 'package:lettutor/core/widgets/tab_bar/tab_bar_custom.dart';
import 'package:lettutor/core/di/di.dart';
import 'package:lettutor/routes/routes.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DashboardBloc get _bloc => BlocProvider.of<DashboardBloc>(context);

  Object? listen;
  @override
  void initState() {
    super.initState();
    listen ??= _bloc.state$.flatMap(handleState).collect();
  }

  final dashboardItem = <TabBarModel>[
    TabBarModel(
      svgAsset: ImageConstant.homeIcon,
      title: 'Home',
      screen: BlocProvider<MainBloc>(
        initBloc: (_) => injector.get(),
        child: const MainView(),
      ),
    ),
    TabBarModel(
      svgAsset: ImageConstant.documentIcon,
      title: 'Home',
      screen: BlocProvider<TutorListBloc>(
        initBloc: (_) => injector.get(),
        child: const TutorListScreen(),
      ),
    ),
    TabBarModel(
      svgAsset: ImageConstant.searchIcon,
      title: 'Search',
      screen: BlocProvider<HomeBloc>(
        initBloc: (_) => injector.get(),
        child: const HomeScreen(),
      ),
    ),
    TabBarModel(
      svgAsset: ImageConstant.calendarIcon,
      title: 'Favorite',
      screen: BlocProvider<ScheduleBloc>(
        initBloc: (_) => injector.get(),
        child: const ScheduleScreen(),
      ),
    ),
    TabBarModel(
      svgAsset: ImageConstant.personIcon,
      title: 'Profile',
      screen: SettingScreen(
        settingConfig: SettingConfig.fromJson({
          'enable_user': true,
          'setting_layout': 'view1',
          'app_bar_color': '07AEAF',
          'hPadding': 10.0,
          'vPadding': 10.0,
          'shadow_elevation': 0.2,
          'pop_up_route': Routes.splash,
          'behindBackground':
          'https://wallpapers.com/images/featured/panda-background-ymceqx76sixgb2ni.jpg',
          'list_view': [
            'security',
            'lang',
            'appearance',
            'about',
            'becomeTutor',
          ],
        }),
      ),
    )
  ];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: TabBarCustom(
        radius: 15,
        elevation: 0.1, // => elevation
        tabBarType: TabBarType
            .dotTabBar, //if you want display test change to textTabBar
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
        onChangeTab: (index) {
          _bloc.changeTabView(index);
        },
      ),
      body: StreamBuilder<int>(
        stream: _bloc.tabIndex$,
        builder: (ctx, sS) {
          final currentIndex = sS.data ?? 0;
          return IndexedStack(
            index: currentIndex,
            sizing: StackFit.expand,
            children: dashboardItem.map((e) => e.screen).toList(),
          );
        },
      ),
    );
  }

  Stream handleState(state) async* {}
}

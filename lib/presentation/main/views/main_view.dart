
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/core/constants/image_constant.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/utils/handle_time.dart';
import 'package:lettutor/core/widgets/header_custom.dart';
import 'package:lettutor/core/widgets/skeleton_custom.dart';
import 'package:lettutor/presentation/main/blocs/main_state.dart';
import 'package:lettutor/presentation/main/views/widgets/course_horizontal_item.dart';
import 'package:lettutor/presentation/main/views/widgets/tutor_horizontal_item.dart';
import 'package:lettutor/routes/routes.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../blocs/main_bloc.dart';
import 'widgets/ebook_horizontal_item.dart';
import 'widgets/welcome_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  Color get _primaryColor => Theme.of(context).primaryColor;

  MainBloc get _bloc => BlocProvider.of<MainBloc>(context);

  Object? listen;

  @override
  void initState() {
    super.initState();

    listen ??= _bloc.state$.flatMap(handleState).collect();

    _bloc.getTopTutors();
    _bloc.getTopCourse();
    _bloc.getTopEbooks();
  }

  Stream handleState(state) async* {
    if (state is GetTopTutorFailed) {
      context.showSnackBar("🐛[Get top tutors error] ${state.toString()}");
      return;
    }
    if (state is GetTopTutorSuccess) {
      log("🌟[Get top tutors] Get top tutors success");
      return;
    }
    if (state is GetTopCourseFailed) {
      context.showSnackBar("🐛[Get top Courses error] ${state.toString()}");
      return;
    }
    if (state is GetTopCourseSuccess) {
      log("🌟[Get top Courses] Get top courses success");
      return;
    }
    if (state is GetTopEbookFailed) {
      context.showSnackBar("🐛[Get top Ebooks error] ${state.toString()}");
      return;
    }
    if (state is GetTopEbookSuccess) {
      log("🌟[Get top Ebooks] Get top Ebooks success");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.school, color: _primaryColor),
            Text(
              ' letTutor',
              style: context.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _bloc.getTopTutors();
          _bloc.getTopCourse();
          _bloc.getTopEbooks();
        },
        child: ListView(children: [
          const WelcomeText(),
          _bannerField(context),
          const SizedBox(height: 15.0),
          ...['👨‍🏫 Top tutors', '💻 Recommend courses', '📖 Free ebook']
              .mapIndexed(
                (index, e) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderTextCustom(
                  headerText: e,
                  isShowSeeMore: true,
                  onPress: () {
                    if (index == 0) {
                      context.openListPageWithRoute(Routes.tutorList);
                      return;
                    }
                    if (index == 1) {
                      context.openListPageWithRoute(Routes.home);
                      return;
                    }
                    if (index == 2) {
                      context.openListPageWithRoute(Routes.ebook);
                      return;
                    }
                  },
                  textStyle: context.titleMedium
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 17.0),
                ),
                switch (index) {
                  0 => _renderTutorField(),
                  1 => _renderCourseField(),
                  2 => _renderEbookField(),
                  _ => const SizedBox(),
                },
                const SizedBox(height: 5.0),
              ],
            ),
          ),
        ]
          // .expand((e) => [e, const SizedBox(height: 10.0)]).toList(),
        ),
      ),
    );
  }

  Padding _bannerField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(15.0),
              width: double.infinity,
              height: context.heightDevice * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: _primaryColor.withOpacity(0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getMMMMEEEd(DateTime.now()),
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  ...[
                    "Free ebook material",
                    "Free one to one with tutors",
                    "Free courses with pdf material",
                  ].map(
                        (e) => Text(
                      '🐼 $e',
                      style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                ].expand((e) => [e, const SizedBox(height: 2.0)]).toList()
                  ..removeLast(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              ImageConstant.bannerImage,
              height: context.heightDevice * 0.20,
            ),
          )
        ],
      ),
    );
  }

  Widget _renderEbookField() {
    return StreamBuilder(
      stream: _bloc.loadingGetEbooks,
      builder: (ctx, sS) {
        final loading = sS.data ?? false;
        if (loading) {
          return RenderWaitToFetchData(
            expandIndicator: const <int>[1],
            height: 180,
            widthItem: context.widthDevice * 0.7,
          );
        }
        return StreamBuilder(
          stream: _bloc.ebooks$,
          builder: (ctx1, sS1) {
            final ebookS = sS1.data;
            if (ebookS?.isNotEmpty ?? false) {
              return SizedBox(
                width: double.infinity,
                height: 180.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ebookS!.length + 1,
                  itemBuilder: (_, index) {
                    if (index == ebookS.length) {
                      return const SizedBox();
                    }
                    final data = ebookS[index];
                    return EbookHorizontalItem(
                        ebook: data, isFirstItem: index == 0);
                  },
                ),
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget _renderCourseField() {
    return StreamBuilder(
      stream: _bloc.loadingGetCourse,
      builder: (ctx, sS) {
        final loading = sS.data ?? false;
        if (loading) {
          return RenderWaitToFetchData(
            expandIndicator: const <int>[1],
            height: 220,
            widthItem: context.widthDevice * 0.4,
          );
        }
        return StreamBuilder(
          stream: _bloc.courses$,
          builder: (ctx1, sS1) {
            final courses = sS1.data;
            if (courses?.isNotEmpty ?? false) {
              return SizedBox(
                width: double.infinity,
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: courses!.length + 1,
                  itemBuilder: (_, index) {
                    if (index == courses.length) {
                      return const SizedBox();
                    }
                    final data = courses[index];
                    return CourseHorizontalItem(
                        course: data, isFirstItem: index == 0);
                  },
                ),
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget _renderTutorField() {
    return StreamBuilder(
      stream: _bloc.loadingGetTutors,
      builder: (ctx, sS) {
        final loading = sS.data ?? false;
        if (loading) {
          return RenderWaitToFetchData(
            expandIndicator: const <int>[1, 3, 1],
            height: 210,
            widthItem: context.widthDevice * 0.55,
          );
        }
        return StreamBuilder(
          stream: _bloc.tutors$,
          builder: (ctx1, sS1) {
            final tutors = sS1.data;
            if (tutors?.isNotEmpty ?? false) {
              return SizedBox(
                width: double.infinity,
                height: 210,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tutors!.length + 1,
                    itemBuilder: (_, index) {
                      if (index == tutors.length) {
                        return const SizedBox();
                      }
                      final data = tutors[index];
                      return TutorHorizontalItem(
                          data: data, isFirstItem: index == 0);
                    }),
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }
}

class RenderWaitToFetchData extends StatelessWidget {
  final List<int> expandIndicator;
  final double height;
  final double widthItem;
  const RenderWaitToFetchData({
    super.key,
    required this.expandIndicator,
    required this.height,
    required this.widthItem,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: 10.0),
          for (var i = 0; i < 4; i++)
            Container(
              width: widthItem,
              height: double.infinity,
              padding: const EdgeInsets.all(5.0),
              margin:
              const EdgeInsets.only(right: 10.0, top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.2),
                    blurRadius: 5.0,
                  )
                ],
              ),
              child: Column(
                children: [
                  ...expandIndicator
                      .map(
                        (e) => Expanded(
                      flex: e,
                      child: SkeletonContainer.circular(
                        borderRadius: BorderRadius.circular(5.0),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  )
                      .expand((e) => [e, const SizedBox(height: 5.0)])
                      .toList()
                    ..removeLast()
                ],
              ),
            ),
        ],
      ),
    );
  }
}

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
import 'package:lettutor/generated/l10n.dart';
import 'package:lettutor/presentation/shared/widgets/simple_course_card.dart';
import 'package:lettutor/presentation/shared/widgets/simple_tutor_card.dart';
import 'package:lettutor/routes/routes.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../blocs/home_bloc.dart';
import '../../shared/widgets/simple_ebook_card.dart';
import '../../shared/widgets/welcome_text.dart';
import '../blocs/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Color get _primaryColor => Theme.of(context).primaryColor;

  HomeBloc get _bloc => BlocProvider.of<HomeBloc>(context);

  Object? listen;

  @override
  void initState() {
    super.initState();

    listen ??= _bloc.state$.flatMap(handleState).collect();

    _bloc.listTopTutor();
    _bloc.listTopCourse();
    _bloc.listTopEbook();
  }

  Stream handleState(state) async* {
    if (state is ListTopTutorFailed) {
      context.showSnackBar("🐛[Get top tutors error] ${state.toString()}");
      return;
    }
    if (state is ListTopTutorSuccess) {
      log("🌟[List top tutors] Get top tutors success");
      return;
    }
    if (state is ListTopCourseFailed) {
      context.showSnackBar("🅱️[List top Courses error] ${state.toString()}");
      return;
    }
    if (state is ListTopCourseSuccess) {
      log("🌟[List top Courses] List top courses success");
      return;
    }
    if (state is ListTopEbookFailed) {
      context.showSnackBar("🅱️[List top Ebooks error] ${state.toString()}");
      return;
    }
    if (state is ListTopEbookSuccess) {
      log("🌟[List top Ebooks] Get top Ebooks success");
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
              ' LetTutor',
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
          _bloc.listTopTutor();
          _bloc.listTopCourse();
          _bloc.listTopEbook();
        },
        child: ListView(children: [
          const WelcomeText(),
          _buildBannerWidget(context),
          const SizedBox(height: 15.0),
          ...[
            S.of(context).topTutors,
            S.of(context).recommendCourses,
            S.of(context).recommendEbooks
          ]
              .mapIndexed(
                (index, e) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderTextCustom(
                  headerText: e,
                  isShowSeeMore: true,
                  onPress: () {
                    if (index == 0) {
                      context.openPageWithRoute(Routes.tutorList);
                      return;
                    }
                    if (index == 1) {
                      context.openPageWithRoute(Routes.courseList);
                      return;
                    }
                    if (index == 2) {
                      context.openPageWithRoute(Routes.ebook);
                      return;
                    }
                  },
                  textStyle: context.titleMedium
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 17.0),
                ),
                switch (index) {
                  0 => _buildTutorListView(),
                  1 => _buildCourseListView(),
                  2 => _buildEbookListView(),
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

  Padding _buildBannerWidget(BuildContext context) {
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
                    "💯Learn one to one with tutors",
                    "📔A lot of courses for any level",
                    "📚Many ebook material",
                  ].map((e) =>
                      Text(
                        e,
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

  Widget _buildEbookListView() {
    return StreamBuilder(
      stream: _bloc.loadingListEbook,
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
                    return SimpleEbookCard(
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

  Widget _buildCourseListView() {
    return StreamBuilder(
      stream: _bloc.loadingListCourse,
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
                    return SimpleCourseCard(
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

  Widget _buildTutorListView() {
    return StreamBuilder(
      stream: _bloc.loadingListTutor,
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
                height: 220,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tutors!.length + 1,
                    itemBuilder: (_, index) {
                      if (index == tutors.length) {
                        return const SizedBox();
                      }
                      final data = tutors[index];
                      return SimpleTutorCard(
                          tutor: data, isFirstItem: index == 0);
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

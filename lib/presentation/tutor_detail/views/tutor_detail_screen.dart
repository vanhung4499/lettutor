import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/app_coordinator.dart';

import 'package:lettutor/domain/entities/tutor/tutor_detail.dart';
import 'package:lettutor/domain/entities/tutor/tutor_user_detail.dart';
import 'package:lettutor/core/constants/constants.dart';
import 'package:lettutor/core/constants/image_constant.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/widgets/button_custom.dart';
import 'package:lettutor/core/widgets/header_custom.dart';
import 'package:lettutor/core/widgets/image_custom.dart';
import 'package:lettutor/core/widgets/loading_page.dart';
import 'package:lettutor/core/widgets/rating_bar_custom.dart';
import 'package:lettutor/core/widgets/video_player.dart';
import 'package:lettutor/core/di/di.dart';
import 'package:lettutor/generated/l10n.dart';
import 'package:lettutor/presentation/shared/widgets/tutor_report_bottom.dart';
import 'package:lettutor/routes/routes.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:readmore/readmore.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../blocs/tutor_detail_bloc.dart';
import '../blocs/tutor_detail_state.dart';
import '../blocs/tutor_report_bloc.dart';
import '../../shared/widgets/bottom_review_list.dart';


class TutorDetailScreen extends StatefulWidget {
  const TutorDetailScreen({super.key});

  @override
  State<TutorDetailScreen> createState() => _TutorDetailScreenState();
}

class _TutorDetailScreenState extends State<TutorDetailScreen> {
  TutorDetailBloc get _bloc => BlocProvider.of<TutorDetailBloc>(context);

  Object? listen;

  Color get _primaryColor => Theme.of(context).primaryColor;

  Color get _backgroundColor => Theme.of(context).scaffoldBackgroundColor;

  EdgeInsets get _horizontalEdgeInsets =>
      const EdgeInsets.symmetric(horizontal: 10.0);

  Widget favIcon(bool isLiked) =>
      Icon(Icons.favorite, color: isLiked ? Colors.red : Colors.white);
  @override
  void initState() {
    super.initState();

    listen ??= _bloc.state$.flatMap(handleState).collect();

    _bloc.getTutor();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _viewMoreReviews() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return BottomReviewList(tutorDetailBloc: _bloc);
      },
    );
  }

  void _reportTutorBottomSheet({required String userId}) async {
    final report = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14.0)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isDismissible: true,
      enableDrag: false,
      builder: (context) {
        return BlocProvider(
          initBloc: (_) => injector.get<TutorReportBloc>(param1: userId),
          child: const TutorReportBottom(),
        );
        // return const SizedBox();
      },
    );
    if ((report is bool) && report) {
      log("🐼[Report tutor] success");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: _backgroundColor,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: ButtonCustom(
            height: 45.0,
            onPress: () => _bloc.openTutorSchedulePage(),
            child: Text(
              S.of(context).bookTutor,
              style: context.titleMedium
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: context.titleLarge.color),
        ),
        title: Text(
          S.of(context).tutorDetail,
          style: context.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<bool?>(
          stream: _bloc.loading$,
          builder: (ctx, sS) {
            final loading = sS.data ?? false;
            if (loading) {
              return _loading();
            }
            return StreamBuilder<TutorDetail>(
              stream: _bloc.tutor$,
              builder: (ctx1, sS1) {
                final tutor = sS1.data;
                if (tutor == null) {
                  return const SizedBox();
                }
                return StreamBuilder(
                  stream: _bloc.loadingFav$,
                  builder: (ctx2, sS2) {
                    final loadingFav = sS.data ?? false;
                    return Stack(
                      children: [
                        _tutorView(tutor),
                        if (loadingFav)
                          Container(
                            color: Colors.black45,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: _loading(),
                          )
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Center _loading() {
    return Center(
      child: StyleLoadingWidget.fadingCube
          .renderWidget(size: 40.0, color: _primaryColor),
    );
  }

  ListView _tutorView(TutorDetail tutor) {
    final tutorUser = tutor.user;
    return ListView(
      children: <Widget>[
        Padding(
          padding: _horizontalEdgeInsets,
          child: _rowTutorInformation(tutorUser, tutor),
        ),
        Padding(
          padding: _horizontalEdgeInsets,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...<String>[
                (tutor.isFavorite ?? false)
                    ? S.of(context).isFavorite
                    : S.of(context).favorite,
                S.of(context).report,
              ].mapIndexed(
                    (index, e) => Expanded(
                  child: ButtonCustom(
                    color: switch (index) {
                      0 => Colors.blueGrey.withOpacity(0.3),
                      _ => Colors.red.withOpacity(0.8)
                    },
                    radius: 5.0,
                    child: Row(
                      children: [
                        Expanded(child: Text(e, style: context.titleMedium.copyWith(color: Colors.white))),
                        switch (index) {
                          0 => favIcon(tutor.isFavorite ?? false),
                          _ => const Icon(Icons.report, color: Colors.white)
                        }
                      ],
                    ),
                    onPress: () {
                      if (index == 0) {
                        _bloc.favTutor();
                      } else {
                        _bloc.reportTutor();
                      }
                    },
                  ),
                ),
              ),
            ].expand((e) => [e, const SizedBox(width: 5.0)]).toList()
              ..removeLast(),
          ),
        ),
        if ((tutor.video?.isNotEmpty ?? false) ||
            (tutor.youtubeVideoId?.isNotEmpty ?? false))
          Container(
            width: double.infinity,
            height: context.heightDevice * 0.3,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 1, color: _primaryColor),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.2),
                  blurRadius: 5.0,
                )
              ],
            ),
            child: VideoPlayerUI(
              url: tutor.video!,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ...{
          S.of(context).description: tutor.bio,
          S.of(context).education: tutor.education,
          S.of(context).languages: tutor.languages,
          S.of(context).specialties: tutor.specialties,
        }.entries.mapIndexed(
              (index, e) => (e.value?.isNotEmpty ?? false)
              ? _informationWithHeaderField(e, index)
              : const SizedBox(),
        ),
        HeaderTextCustom(
          headerText: S.of(context).suggestedCourses,
          textStyle: context.titleMedium.copyWith(fontWeight: FontWeight.w500),
          padding: _horizontalEdgeInsets,
        ),
        if (tutorUser?.courses != null)
          ...tutorUser!.courses!.map(
                (e) => Padding(
              padding: _horizontalEdgeInsets,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      e.name,
                      style: context.titleMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(S.of(context).view,
                        style:
                        context.titleSmall.copyWith(color: _primaryColor)),
                  )
                ],
              ),
            ),
          ),
        HeaderTextCustom(
          headerText: S.of(context).review,
          padding: _horizontalEdgeInsets,
          textStyle: context.titleMedium.copyWith(fontWeight: FontWeight.w500),
          isShowSeeMore: true,
          onPress: _viewMoreReviews,
        ),
      ].expand((e) => [e, const SizedBox(height: 10.0)]).toList(),
    );
  }

  Column _informationWithHeaderField(MapEntry<String, String?> e, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderTextCustom(
          headerText: e.key,
          padding: _horizontalEdgeInsets,
          textStyle: context.titleMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5.0),
        if (index < 2)
          Padding(
            padding: _horizontalEdgeInsets,
            child: ReadMoreText(
              e.value!,
              trimLines: 3,
              trimCollapsedText: S.of(context).showMore,
              trimExpandedText: S.of(context).showLess,
              lessStyle: context.titleSmall.copyWith(color: _primaryColor),
              moreStyle: context.titleSmall.copyWith(color: _primaryColor),
              style: context.titleSmall.copyWith(
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.w500),
            ),
          )
        else
          Padding(
            padding: _horizontalEdgeInsets,
            child: Wrap(
              children: [
                ...e.value!.split(',').map(
                      (e) => Container(
                    margin: const EdgeInsets.all(2.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: _primaryColor.withOpacity(0.2),
                    ),
                    child: Text(
                      e.replaceAll('-', ' '),
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: _primaryColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }

  Widget _rowTutorInformation(TutorUserDetail? tutorUser, TutorDetail tutor) {
    if (tutorUser == null) {
      return const SizedBox();
    }
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: ImageCustom(
            imageUrl: tutorUser.avatar ?? ImageConstant.defaultImage,
            isNetworkImage: true,
            width: 70.0,
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tutorUser.name ?? '',
                style: context.titleLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(height: 1.0),
              if (tutorUser.country?.isNotEmpty ?? false) ...[
                Text(
                  Constants.countries[tutorUser.country!.toUpperCase()] ??
                      'Unknown',
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(height: 1.0),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RatingBarCustom(
                      rating: tutor.rating ?? 0.0, itemSize: 17.0),
                  Text(
                    ' ${tutor.rating?.toStringAsFixed(1) ?? ''} . ${tutor.totalFeedback}',
                    style: context.titleSmall.copyWith(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: _primaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Stream handleState(state) async* {
    if (state is GetTutorSuccess) {
      log("🌟[Get tutor by id] Success");
      return;
    }
    if (state is GetTutorFailed) {
      log("🌟[Get tutor by id] Failed ${state.toString()}");
      return;
    }
    if (state is FavTutorFailed) {
      log("🌟[Fav tutor] Failed ${state.toString()}");
      return;
    }
    if (state is FavTutorSuccess) {
      log("🌟[Fav tutor] Success");
      return;
    }
    if (state is ListReviewFailed) {
      log("🌟 [Get reviews] Failed ${state.toString()}");
      return;
    }
    if (state is ListReviewSuccess) {
      log("🌟 [Get reviews] Success");
      return;
    }
    if (state is OpenReportTutorSuccess) {
      log("🌟 [Open report tutor view] Success");
      _reportTutorBottomSheet(userId: state.userId);
      return;
    }
    if (state is OpenTutorScheduleSuccess) {
      log("🌟 [Open tutor schedule view] Success");
      context.openPageWithRouteAndParams(Routes.tutorSchedule, state.userId);
      return;
    }
  }
}

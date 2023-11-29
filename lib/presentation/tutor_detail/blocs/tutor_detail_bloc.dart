import 'package:flutter/material.dart';
import 'package:disposebag/disposebag.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/tutor/review.dart';
import 'package:lettutor/core/utils/stream_extension.dart';
import 'package:lettutor/core/utils/validator.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:lettutor/domain/entities/tutor/tutor_detail.dart';
import 'package:lettutor/domain/usecases/tutor_detail_usecase.dart';
import 'package:lettutor/core/utils/type_defs.dart';

import '../blocs/tutor_detail_state.dart';

@injectable
class TutorDetailBloc extends DisposeCallbackBaseBloc {
  ///[Functions] input
  final Function0<void> getTutor;

  final Function0<void> favTutor;

  final Function0<void> listReview;

  final Function0<void> reportTutor;

  final Function0<void> openTutorSchedulePage;

  ///[Streams]

  final Stream<TutorDetailState> state$;

  final Stream<bool?> loading$;

  final Stream<bool?> loadingFav$;

  final Stream<bool?> loadingReview$;

  final Stream<TutorDetail> tutor$;

  final Stream<Pagination<Review>> reviews$;

  TutorDetailBloc._({
    required Function0<void> dispose,
    required this.openTutorSchedulePage,
    required this.getTutor,
    required this.reportTutor,
    required this.loadingFav$,
    required this.loadingReview$,
    required this.listReview,
    required this.favTutor,
    required this.loading$,
    required this.reviews$,
    required this.state$,
    required this.tutor$,
  }) : super(dispose);

  factory TutorDetailBloc(@factoryParam String userId,
      {required TutorDetailUseCase tutorDetailUseCase}) {
    ///[Define value]

    final getTutorController = PublishSubject<void>();

    final favTutorController = PublishSubject<void>();

    final listReviewController = PublishSubject<void>();

    final reportTutorController = PublishSubject<void>();

    final openTutorSchedulePageController = PublishSubject<void>();

    final loadingController = BehaviorSubject<bool>.seeded(false);

    final loadingFavController = BehaviorSubject<bool>.seeded(false);

    final loadingRevController = BehaviorSubject<bool>.seeded(false);

    final tutorController =
    BehaviorSubject<TutorDetail>.seeded(const TutorDetail());

    final reviewsController = BehaviorSubject<Pagination<Review>>.seeded(
        const Pagination<Review>(
            rows: <Review>[], count: 0, perPage: 10, currentPage: 1));

    ///[Handle]

    final favTutor$ = favTutorController.stream
        .withLatestFrom(loadingFavController.stream, (_, loading) => !loading)
        .share();

    final favTutorState$ = Rx.merge<TutorDetailState>([
      favTutor$
          .where((isValid) => isValid)
          .debug(log: debugPrint)
          .exhaustMap((_) {
        try {
          return tutorDetailUseCase
              .addTutorToFavorite(userId: userId)
              .doOn(
            listen: () => loadingFavController.add(true),
            cancel: () => loadingFavController.add(false),
          )
              .map((data) => data.fold(
              ifLeft: (error) =>
                  FavTutorFailed(message: error.message, error: error.code),
              ifRight: (add) {
                if (add) {
                  final currentTutor = tutorController.value;
                  tutorController.add(
                    currentTutor.copyWith(
                        isFavorite: !(currentTutor.isFavorite ?? false)),
                  );
                  return const FavTutorSuccess();
                }
                return FavTutorFailed(message: 'Failed');
              }));
        } catch (e) {
          return Stream<TutorDetailState>.error(
            const InvalidTutorDetail(),
          );
        }
      }),
      favTutor$
          .where((isValid) => !isValid)
          .map((_) => const InvalidTutorDetail()),
    ]).whereNotNull().share();

    ///[Get tutors]
    final getTutor$ = getTutorController.stream
        .withLatestFrom(loadingController.stream, (_, loading) => !loading)
        .share();

    final getTutorState$ = Rx.merge<TutorDetailState>([
      getTutor$
          .where((isValid) => isValid)
          .debug(log: debugPrint)
          .exhaustMap((_) {
        try {
          return tutorDetailUseCase
              .getTutorById(userId: userId)
              .doOn(
            listen: () => loadingController.add(true),
            cancel: () => loadingController.add(false),
          )
              .map(
                (data) => data.fold(
                ifLeft: (error) => GetTutorFailed(
                    error: error.code, message: error.message),
                ifRight: (tData) {
                  if (tData != null) {
                    tutorController.add(tData);
                    return const GetTutorSuccess();
                  }
                  return GetTutorFailed(message: "Data null");
                }),
          );
        } catch (e) {
          return Stream<TutorDetailState>.error(
            GetTutorFailed(message: e.toString()),
          );
        }
      }),
      getTutor$.where((isValid) => !isValid).map(
            (_) => const InvalidTutorDetail(),
      )
    ]).whereNotNull().share();

    ///[Reviews]
    final isValid$ = Rx.combineLatest2(
        reviewsController.stream.map(Validator.paginationValid),
        loadingRevController.stream,
            (paginationValid, loading) => paginationValid || !loading)
        .shareValueSeeded(false);

    final listReview$ = listReviewController.stream
        .withLatestFrom(isValid$, (_, isValid) => isValid)
        .share();

    final listReviewState$ = Rx.merge<TutorDetailState>([
      listReview$
          .where((isValid) => isValid)
          .debug(log: debugPrint)
          .withLatestFrom(reviewsController.stream,
              (_, Pagination<Review> pagination) => pagination)
          .exhaustMap((pagination) {
        try {
          return tutorDetailUseCase
              .getReviews(
              userId: userId,
              perPage: pagination.perPage,
              currentPage: pagination.currentPage + 1)
              .doOn(
            listen: () => loadingRevController.add(true),
            cancel: () => loadingRevController.add(false),
          )
              .map(
                (data) => data.fold(
              ifLeft: (error) => ListReviewFailed(
                  message: error.message, error: error.code),
              ifRight: (rData) {
                final currentData = reviewsController.value;
                reviewsController.add(Pagination(
                  rows: [...currentData.rows, ...rData.rows],
                  count: rData.count,
                  currentPage: rData.currentPage,
                  perPage: rData.perPage,
                ));
                return const ListReviewSuccess();
              },
            ),
          );
        } catch (e) {
          return Stream<TutorDetailState>.error(
            ListReviewFailed(message: e.toString()),
          );
        }
      }),
      listReview$
          .where((isValid) => !isValid)
          .map((_) => const InvalidTutorDetail()),
    ]).whereNotNull().share();

    final openReportTutorState$ = reportTutorController.stream
        .map((_) => OpenReportTutorSuccess(userId: userId))
        .share();

    final openTutorSchedulePageState$ = openTutorSchedulePageController.stream
        .map((_) => OpenTutorScheduleSuccess(userId: userId))
        .share();

    final state$ = Rx.merge<TutorDetailState>([
      getTutorState$,
      favTutorState$,
      listReviewState$,
      openReportTutorState$,
      openTutorSchedulePageState$,
    ]).whereNotNull().share();

    final subscriptions = <String, Stream>{
      'state': state$,
      'loadingController': loadingController,
      'isValid': isValid$,
    }.debug();

    return TutorDetailBloc._(
      dispose: () async => await DisposeBag([
        getTutorController,
        reportTutorController,
        tutorController,
        loadingController,
        loadingFavController,
        favTutorController,
        loadingRevController,
        listReviewController,
        reviewsController,
        openTutorSchedulePageController,
        ...subscriptions,
      ]).dispose(),
      favTutor: () => favTutorController.add(null),
      listReview: () => listReviewController.add(null),
      reportTutor: () => reportTutorController.add(null),
      getTutor: () => getTutorController.add(null),
      openTutorSchedulePage: () => openTutorSchedulePageController.add(null),
      state$: state$,
      tutor$: tutorController,
      reviews$: reviewsController,
      loading$: loadingController,
      loadingFav$: loadingFavController,
      loadingReview$: loadingRevController,
    );
  }
}

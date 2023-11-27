import 'package:disposebag/disposebag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/core/utils/stream_extension.dart';
import 'package:lettutor/core/utils/type_defs.dart';
import 'package:lettutor/domain/entities/common/ebook.dart';
import 'package:lettutor/domain/entities/course/course.dart';
import 'package:lettutor/domain/entities/tutor/tutor.dart';
import 'package:lettutor/domain/usecases/main_usecase.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import 'main_state.dart';

@injectable
class MainBloc extends DisposeCallbackBaseBloc {
  ///[Input function]

  final Function0<void> getTopCourse;

  final Function0<void> getTopEbooks;

  final Function0<void> getTopTutors;

  ///[State]

  final Stream<MainState> state$;

  ///[loading stream]

  final Stream<bool?> loadingGetTutors;

  final Stream<bool?> loadingGetCourse;

  final Stream<bool?> loadingGetEbooks;

  ///[data stream]
  final Stream<List<Tutor>> tutors$;

  final Stream<List<Course>> courses$;

  final Stream<List<Ebook>> ebooks$;

  MainBloc._({
    required Function0<void> dispose,
    required this.getTopCourse,
    required this.getTopEbooks,
    required this.getTopTutors,
    //-----------------------------
    required this.state$,
    required this.loadingGetCourse,
    required this.loadingGetEbooks,
    required this.loadingGetTutors,
    //----------------------------
    required this.tutors$,
    required this.courses$,
    required this.ebooks$,
  }) : super(dispose);

  factory MainBloc({required MainUseCase mainUseCase}) {
    ///[Data controller]

    final loadingGetTutorController = BehaviorSubject<bool>.seeded(false);

    final loadingGetCourseController = BehaviorSubject<bool>.seeded(false);

    final loadingGetEbookController = BehaviorSubject<bool>.seeded(false);

    ///[Data controller]

    final tutorController =
    BehaviorSubject<List<Tutor>>.seeded(List.empty(growable: true));

    final courseController =
    BehaviorSubject<List<Course>>.seeded(List.empty(growable: true));

    final ebookController =
    BehaviorSubject<List<Ebook>>.seeded(List.empty(growable: true));

    ///[Function controller]

    final getTutorController = PublishSubject<void>();

    final getCourseController = PublishSubject<void>();

    final getEbookController = PublishSubject<void>();

    ///[Get tutor handle]

    final getTutor$ = getTutorController.stream
        .withLatestFrom(
        loadingGetTutorController.stream, (_, loading) => !loading)
        .share();

    final getTutorState$ = Rx.merge<MainState>([
      getTutor$
          .where((isValid) => isValid)
          .debug(log: debugPrint)
          .exhaustMap((_) {
        try {
          return mainUseCase
              .getTopTutors()
              .doOn(
            listen: () => loadingGetTutorController.add(true),
            cancel: () => loadingGetTutorController.add(false),
          )
              .map((data) => data.fold(
            ifLeft: (error) =>
                GetTopTutorFailed(message: error.message, error: error),
            ifRight: (cData) {
              tutorController.add(cData.tutors.rows as List<Tutor>);
              return const GetTopTutorSuccess();
            },
          ));
        } catch (e) {
          return Stream.error(GetTopTutorFailed(message: e.toString()));
        }
      }),
      getTutor$
          .where((isValid) => !isValid)
          .map((_) => const GetTopTutorFailed(message: "Data is loading"))
    ]).whereNotNull().share();

    ///[Get course handler]

    final getCourse$ = getCourseController.stream
        .withLatestFrom(
        loadingGetCourseController.stream, (_, loading) => !loading)
        .share();

    final getCourseState$ = Rx.merge<MainState>([
      getCourse$
          .where((isValid) => isValid)
          .debug(log: debugPrint)
          .exhaustMap((_) {
        try {
          return mainUseCase
              .getTopCourse()
              .doOn(
            listen: () => loadingGetCourseController.add(true),
            cancel: () => loadingGetCourseController.add(false),
          )
              .map(
                (data) => data.fold(
                ifLeft: (error) => GetTopCourseFailed(
                    message: error.message, error: error),
                ifRight: (cData) {
                  courseController.add(cData?.rows as List<Course>);
                  return const GetTopCourseSuccess();
                }),
          );
        } catch (e) {
          return Stream.error(GetTopCourseFailed(message: e.toString()));
        }
      }),
      getCourse$
          .where((isValid) => !isValid)
          .map((_) => const GetTopCourseFailed(message: "Data is loading"))
    ]).whereNotNull().share();

    ///[Get eBoo handle]

    final getEbook$ = getEbookController.stream
        .withLatestFrom(
        loadingGetEbookController.stream, (_, loading) => !loading)
        .share();

    final getEbookState$ = Rx.merge<MainState>([
      getEbook$.where((isValid) => isValid).debug(log: debugPrint).exhaustMap(
            (_) => mainUseCase
            .getListEbook()
            .doOn(
          listen: () => loadingGetEbookController.add(true),
          cancel: () => loadingGetEbookController.add(false),
        )
            .map(
              (data) => data.fold(
            ifLeft: (error) =>
                GetTopEbookFailed(message: error.message, error: error),
            ifRight: (cData) {
              ebookController.add(cData.rows as List<Ebook>);
              return const GetTopEbookSuccess();
            },
          ),
        ),
      ),
      getEbook$
          .where((isValid) => !isValid)
          .map((_) => const GetTopEbookFailed(message: "Data is loading"))
    ]).whereNotNull().share();

    final state$ =
    Rx.merge<MainState>([getTutorState$, getCourseState$, getEbookState$])
        .whereNotNull()
        .share();

    final subscriptions = <String, Stream>{
      'state': state$,
      'loadingTutorController': loadingGetTutorController,
      'loadingCourseController': loadingGetCourseController,
      'loadingEbookController': loadingGetEbookController,
    }.debug();

    return MainBloc._(
      state$: state$,
      loadingGetTutors: loadingGetTutorController,
      loadingGetCourse: loadingGetCourseController,
      loadingGetEbooks: loadingGetEbookController,
      courses$: courseController,
      tutors$: tutorController,
      ebooks$: ebookController,
      getTopEbooks: () => getEbookController.add(null),
      getTopCourse: () => getCourseController.add(null),
      getTopTutors: () => getTutorController.add(null),
      dispose: () async => await DisposeBag([
        loadingGetTutorController,
        tutorController,
        getTutorController,
        //----------------------------
        loadingGetCourseController,
        courseController,
        getCourseController,
        //----------------------------
        loadingGetEbookController,
        ebookController,
        getEbookController,
        ...subscriptions,
      ]).dispose(),
    );
  }
}

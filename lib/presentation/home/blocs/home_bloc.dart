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

import 'home_state.dart';

@injectable
class HomeBloc extends DisposeCallbackBaseBloc {
  ///[Input function]

  final Function0<void> listTopCourse;

  final Function0<void> listTopEbook;

  final Function0<void> listTopTutor;

  ///[State]

  final Stream<HomeState> state$;

  ///[loading stream]

  final Stream<bool?> loadingListTutor;

  final Stream<bool?> loadingListCourse;

  final Stream<bool?> loadingListEbook;

  ///[data stream]
  final Stream<List<Tutor>> tutors$;

  final Stream<List<Course>> courses$;

  final Stream<List<Ebook>> ebooks$;

  HomeBloc._({
    required Function0<void> dispose,
    required this.listTopCourse,
    required this.listTopEbook,
    required this.listTopTutor,
    //-----------------------------
    required this.state$,
    required this.loadingListCourse,
    required this.loadingListEbook,
    required this.loadingListTutor,
    //----------------------------
    required this.tutors$,
    required this.courses$,
    required this.ebooks$,
  }) : super(dispose);

  factory HomeBloc({required MainUseCase mainUseCase}) {
    ///[Data controller]

    final loadingListTutorController = BehaviorSubject<bool>.seeded(false);

    final loadingListCourseController = BehaviorSubject<bool>.seeded(false);

    final loadingListEbookController = BehaviorSubject<bool>.seeded(false);

    ///[Data controller]

    final tutorController =
    BehaviorSubject<List<Tutor>>.seeded(List.empty(growable: true));

    final courseController =
    BehaviorSubject<List<Course>>.seeded(List.empty(growable: true));

    final ebookController =
    BehaviorSubject<List<Ebook>>.seeded(List.empty(growable: true));

    ///[Function controller]

    final listTutorController = PublishSubject<void>();

    final listCourseController = PublishSubject<void>();

    final listEbookController = PublishSubject<void>();

    ///[List tutor handle]

    final listTutor$ = listTutorController.stream
        .withLatestFrom(
        loadingListTutorController.stream, (_, loading) => !loading)
        .share();

    final listTutorState$ = Rx.merge<HomeState>([
      listTutor$
          .where((isValid) => isValid)
          .debug(log: debugPrint)
          .exhaustMap((_) {
        try {
          return mainUseCase
              .getTopTutors()
              .doOn(
            listen: () => loadingListTutorController.add(true),
            cancel: () => loadingListTutorController.add(false),
          )
              .map((data) => data.fold(
            ifLeft: (error) =>
                ListTopTutorFailed(message: error.message, error: error),
            ifRight: (cData) {
              tutorController.add(cData.tutors.rows as List<Tutor>);
              return const ListTopTutorSuccess();
            },
          ));
        } catch (e) {
          return Stream.error(ListTopTutorFailed(message: e.toString()));
        }
      }),
      listTutor$
          .where((isValid) => !isValid)
          .map((_) => const ListTopTutorFailed(message: "Data is loading"))
    ]).whereNotNull().share();

    ///[Get course handler]

    final listCourse$ = listCourseController.stream
        .withLatestFrom(
        loadingListCourseController.stream, (_, loading) => !loading)
        .share();

    final listCourseState$ = Rx.merge<HomeState>([
      listCourse$
          .where((isValid) => isValid)
          .debug(log: debugPrint)
          .exhaustMap((_) {
        try {
          return mainUseCase
              .getTopCourse()
              .doOn(
            listen: () => loadingListCourseController.add(true),
            cancel: () => loadingListCourseController.add(false),
          )
              .map(
                (data) => data.fold(
                ifLeft: (error) => ListTopCourseFailed(
                    message: error.message, error: error),
                ifRight: (cData) {
                  courseController.add(cData?.rows as List<Course>);
                  return const ListTopCourseSuccess();
                }),
          );
        } catch (e) {
          return Stream.error(ListTopCourseFailed(message: e.toString()));
        }
      }),
      listCourse$
          .where((isValid) => !isValid)
          .map((_) => const ListTopCourseFailed(message: "Data is loading"))
    ]).whereNotNull().share();


    final listEbook$ = listEbookController.stream
        .withLatestFrom(
        loadingListEbookController.stream, (_, loading) => !loading)
        .share();

    final listEbookState$ = Rx.merge<HomeState>([
      listEbook$.where((isValid) => isValid).debug(log: debugPrint).exhaustMap(
            (_) => mainUseCase
            .getListEbook()
            .doOn(
          listen: () => loadingListEbookController.add(true),
          cancel: () => loadingListEbookController.add(false),
        )
            .map(
              (data) => data.fold(
            ifLeft: (error) =>
                ListTopEbookFailed(message: error.message, error: error),
            ifRight: (cData) {
              ebookController.add(cData.rows as List<Ebook>);
              return const ListTopEbookSuccess();
            },
          ),
        ),
      ),
      listEbook$
          .where((isValid) => !isValid)
          .map((_) => const ListTopEbookFailed(message: "Data is loading"))
    ]).whereNotNull().share();

    final state$ =
    Rx.merge<HomeState>([listTutorState$, listCourseState$, listEbookState$])
        .whereNotNull()
        .share();

    final subscriptions = <String, Stream>{
      'state': state$,
      'loadingTutorController': loadingListTutorController,
      'loadingCourseController': loadingListCourseController,
      'loadingEbookController': loadingListEbookController,
    }.debug();

    return HomeBloc._(
      state$: state$,
      loadingListTutor: loadingListTutorController,
      loadingListCourse: loadingListCourseController,
      loadingListEbook: loadingListEbookController,
      courses$: courseController,
      tutors$: tutorController,
      ebooks$: ebookController,
      listTopEbook: () => listEbookController.add(null),
      listTopCourse: () => listCourseController.add(null),
      listTopTutor: () => listTutorController.add(null),
      dispose: () async => await DisposeBag([
        loadingListTutorController,
        tutorController,
        listTutorController,
        //----------------------------
        loadingListCourseController,
        courseController,
        listCourseController,
        //----------------------------
        loadingListEbookController,
        ebookController,
        listEbookController,
        ...subscriptions,
      ]).dispose(),
    );
  }
}

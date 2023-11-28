import 'package:disposebag/disposebag.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/data/models/request/search_tutor_request.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/tutor/tutor.dart';
import 'package:lettutor/domain/entities/tutor/tutor_fav.dart';
import 'package:lettutor/core/utils/type_defs.dart';
import 'package:lettutor/core/utils/validator.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/domain/usecases/search_tutor_usecase.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import 'tutor_search_result_state.dart';

@injectable
class TutorSearchResultBloc extends DisposeCallbackBaseBloc {
  ///[functions] input
  final Function0<void> searchTutor;

  ///[streams]

  final Stream<bool?> loading$;

  final Stream<TutorFav> tutor$;

  final Stream<TutorSearchResultState> state$;

  TutorSearchResultBloc._({
    required Function0<void> dispose,
    required this.searchTutor,
    required this.loading$,
    required this.tutor$,
    required this.state$,
  }) : super(dispose);

  factory TutorSearchResultBloc(
      @factoryParam SearchTutorRequest request,
      {required SearchTutorUseCase searchTutorUseCase}) {
    final loadingController = BehaviorSubject<bool>.seeded(false);

    final tutorController = BehaviorSubject<TutorFav>.seeded(TutorFav());

    final searchTutorController = PublishSubject<void>();

    final isValid$ = Rx.combineLatest2(
        tutorController.stream.map((e) => Validator.paginationValid(e.tutors)),
        loadingController.stream,
            (paginationValid, loading) =>
        paginationValid || !loading).shareValueSeeded(false);

    final searchTutor$ = searchTutorController.stream
        .withLatestFrom(isValid$, (_, isValid) => isValid)
        .share();

    final searchTutorState$ = Rx.merge<TutorSearchResultState>([
      searchTutor$
          .where((isValid) => isValid)
          .debug(log: debugPrint)
          .withLatestFrom(
          tutorController.stream, (_, TutorFav tutorFav) => tutorFav)
          .exhaustMap((value) {
        final pagination = value.tutors;
        try {
          return searchTutorUseCase
              .searchTutor(
            request: SearchTutorRequest(
              perPage: pagination.perPage,
              page: pagination.currentPage + 1,
              search: request.search,
              topics: request.topics,
              nationality: request.nationality,
            ),
          )
              .doOn(
            listen: () => loadingController.add(true),
            cancel: () => loadingController.add(false),
          )
              .map((data) => data.fold(
              ifLeft: (error) => TutorSearchFailed(
                  error: error.code, message: error.message),
              ifRight: (pData) {
                if (pData != null) {
                  tutorController.add(
                    TutorFav(
                      tutors: Pagination<Tutor>(
                        count: pData.tutors.count,
                        perPage: pData.tutors.perPage,
                        currentPage: pData.tutors.currentPage,
                        rows: [...pagination.rows, ...pData.tutors.rows],
                      ),
                    ),
                  );
                  return const TutorSearchSuccess();
                }
                return const TutorSearchFailed();
              }));
        } catch (e) {
          return Stream<TutorSearchResultState>.error(
            TutorSearchFailed(message: e.toString()),
          );
        }
      }),
      searchTutor$.where((isValid) => !isValid).map((_) => const STRInvalid())
    ]).whereNotNull().share();

    final state$ = Rx.merge<TutorSearchResultState>([searchTutorState$])
        .whereNotNull()
        .share();

    return TutorSearchResultBloc._(
      dispose: () async => DisposeBag(
          [loadingController, tutorController, searchTutorController])
          .dispose(),
      searchTutor: () => searchTutorController.add(null),
      loading$: loadingController,
      tutor$: tutorController,
      state$: state$,
    );
  }
}

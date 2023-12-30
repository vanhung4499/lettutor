import 'package:disposebag/disposebag.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/data/models/request/ebook_request.dart';
import 'package:lettutor/domain/entities/common/ebook.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/course/course_category.dart';
import 'package:lettutor/domain/usecases/ebook_usecase.dart';
import 'package:lettutor/core/utils/stream_extension.dart';
import 'package:lettutor/core/utils/type_defs.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import 'ebook_state.dart';

@injectable
class EbookBloc extends DisposeCallbackBaseBloc {
  ///[Functions]

  final Function2<String?, String?, void> listEbook;

  final Function0<void> refreshData;

  final Function0<void> listCourseCategory;

  ///[Streams]

  final Stream<bool?> loading$;

  final Stream<Pagination<Ebook>> ebooks$;

  final Stream<List<CourseCategory>> courseCategories$;

  final Stream<EbookState> state$;

  EbookBloc._({
    required Function0<void> dispose,
    required this.courseCategories$,
    required this.listCourseCategory,
    required this.refreshData,
    required this.loading$,
    required this.listEbook,
    required this.state$,
    required this.ebooks$,
  }) : super(dispose);

  factory EbookBloc({required EbookUseCase ebookUseCase}) {
    final listBooController = PublishSubject<void>();

    final loadingController = BehaviorSubject<bool>.seeded(false);

    final searchTextController = BehaviorSubject<String>.seeded("");

    final categoryIdController = BehaviorSubject<String>.seeded("");

    final ebookController = BehaviorSubject<Pagination<Ebook>>.seeded(
      const Pagination<Ebook>(
          rows: <Ebook>[], count: 0, currentPage: 0, perPage: 10),
    );

    final courseCategoriesController =
    BehaviorSubject.seeded(List<CourseCategory>.empty(growable: true));

    final listCourseCategoryController = PublishSubject<void>();

    void refreshPaginationController() {
      ebookController.add(
        const Pagination<Ebook>(
            rows: <Ebook>[], count: 0, currentPage: 0, perPage: 10),
      );
    }

    final getEbook$ = listBooController.stream
        .withLatestFrom(loadingController.stream, (_, loading) => !loading)
        .share();

    final getEbookState$ = Rx.merge<EbookState>([
      getEbook$
          .where((isValid) => isValid)
          .debug(log: debugPrint)
          .withLatestFrom(
          Rx.combineLatest3(
            searchTextController.stream,
            categoryIdController.stream,
            ebookController.stream,
                (search, categoryId, ebook) =>
                ListEbookRequest(search, categoryId, ebook),
          ),
              (_, request) => request)
          .exhaustMap((request) {
        final query = request.query;
        final categoryId = request.categoryId;
        final pagination = request.ebooks;
        try {
          return ebookUseCase
              .listEbook(
            page: pagination.currentPage + 1,
            size: pagination.perPage,
            categoryId: categoryId,
            q: query,
          )
              .doOn(
            listen: () => loadingController.add(true),
            cancel: () => loadingController.add(false),
          )
              .map(
                (data) => data.fold(
              ifLeft: (error) =>
                  GetEbookFailed(message: error.message, error: error.code),
              ifRight: (eData) {
                ebookController.add(Pagination<Ebook>(
                  count: eData.count,
                  perPage: eData.perPage,
                  currentPage: eData.currentPage,
                  rows: [...pagination.rows, ...eData.rows],
                ));
                return const GetEbookSuccess();
              },
            ),
          );
        } catch (e) {
          return Stream.error(GetEbookFailed(message: e.toString()));
        }
      }),
      getEbook$
          .where((isValid) => !isValid)
          .map((_) => const GetEbookFailed(message: "Invalid"))
    ]).whereNotNull().share();

    final getCourseCategories$ = listCourseCategoryController.stream.share();

    final state$ = Rx.merge<EbookState>([
      getCourseCategories$.exhaustMap((value) {
        try {
          ///[🐛🐛] Dumb code
          return ebookUseCase.listCourseCategory().map((data) => data.fold(
              ifLeft: (error) =>
                  GetEbookFailed(message: error.message, error: error.code),
              ifRight: (pData) {
                courseCategoriesController.add(pData);
                return const GetEbookSuccess();
              }));
        } catch (e) {
          return Stream.error(
            GetEbookFailed(message: e.toString()),
          );
        }
      }),
      getEbookState$
    ]).whereNotNull().share();

    final subscriptions = <String, Stream>{
      'state': state$,
      'loadingController': loadingController,
    }.debug();

    return EbookBloc._(
      dispose: () async => await DisposeBag([
        ebookController,
        listBooController,
        loadingController,
        searchTextController,
        categoryIdController,
        courseCategoriesController,
        listCourseCategoryController,
        ...subscriptions,
      ]).dispose(),
      courseCategories$: courseCategoriesController,
      listCourseCategory: () => listCourseCategoryController.add(null),
      refreshData: () {
        refreshPaginationController();
        listBooController.add(null);
      },
      listEbook: (query, category) {
        final currentSearchText = searchTextController.value;
        final currentCategoryId = categoryIdController.value;
        final checkSearchText = (query != null) && currentSearchText != query;
        final checkCategoryId =
            (category != null) && currentCategoryId != category;
        if (checkSearchText) {
          searchTextController.add(query);
        }
        if (checkCategoryId) {
          categoryIdController.add(category);
        }
        if (checkSearchText || checkCategoryId) {
          refreshPaginationController();
        }

        listBooController.add(null);
      },
      loading$: loadingController,
      ebooks$: ebookController,
      state$: state$,
    );
  }
}

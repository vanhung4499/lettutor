import 'package:disposebag/disposebag.dart';
import 'package:flutter/foundation.dart';
import 'package:lettutor/data/models/request/search_tutor_request.dart';
import 'package:lettutor/data/models/request/tutor_nationality.dart';
import 'package:lettutor/domain/entities/common/topic.dart';
import 'package:lettutor/core/utils/stream_extension.dart';
import 'package:lettutor/core/utils/type_defs.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/domain/usecases/search_tutor_usecase.dart';
import 'package:lettutor/presentation/tutor_search/blocs/tutor_search_state.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

@injectable
class TutorSearchBloc extends DisposeCallbackBaseBloc {
  ///[functions] input
  final Function0<void> listTopic;

  final Function1<Topic, void> selectedTopic;

  final Function1<String, void> openSearchResultPage;

  final Function1<TutorNationality, void> selectedTutorNationality;

  ///[Streams]

  final Stream<List<Topic>> topics$;

  final Stream<List<Topic>> selectedTopic$;

  final Stream<bool?> loading$;

  final Stream<TutorSearchState> state$;

  final Stream<TutorNationality> tutorNationality;

  TutorSearchBloc._({
    required Function0<void> dispose,
    required this.selectedTutorNationality,
    required this.openSearchResultPage,
    required this.tutorNationality,
    required this.listTopic,
    required this.selectedTopic$,
    required this.selectedTopic,
    required this.loading$,
    required this.topics$,
    required this.state$,
  }) : super(dispose);

  factory TutorSearchBloc({required SearchTutorUseCase searchTutorUseCase}) {
    final topicController =
    BehaviorSubject<List<Topic>>.seeded(List<Topic>.empty(growable: true));

    final selectTopicController =
    BehaviorSubject<List<Topic>>.seeded(List<Topic>.empty(growable: true));

    final tutorNationalityController =
    BehaviorSubject<TutorNationality>.seeded(nationalityConstants.first);

    final loadingController = BehaviorSubject<bool>.seeded(false);

    final selectedNationalityTutorController =
    PublishSubject<TutorNationality>();

    final fetchTopicsController = PublishSubject<void>();

    final selectedTopicController = PublishSubject<Topic>();

    final openSearchResultPageController = PublishSubject<String>();

    ///🌟[Actions]

    final fetchTopics$ = fetchTopicsController
        .withLatestFrom(loadingController.stream, (_, loading) => !loading)
        .share();

    final selectedTopicState$ = selectedTopicController.stream.map((topic) {
      final currentSelectedTopics = selectTopicController.value;
      if (currentSelectedTopics.contains(topic)) {
        selectTopicController.add(
          currentSelectedTopics.where((element) => element != topic).toList(),
        );
      } else {
        selectTopicController.add([...currentSelectedTopics, topic]);
      }
      return const SelectTopicSuccess();
    }).share();

    final selectedNationalityTutorState$ =
    selectedNationalityTutorController.stream.map((nTutor) {
      tutorNationalityController.add(nTutor);
      return const SelectNationalitySuccess();
    }).share();

    final openSearchResultPageState$ = openSearchResultPageController.stream
        .map((searchText) => OpenSearchTutorResultPageSuccess(
      searchTutorRequest: SearchTutorRequest(
        perPage: 0,
        page: 10,
        search: searchText,
        topics: selectTopicController.value
            .map((e) => e.key?.toLowerCase().trim() ?? '')
            .toList(),
        nationality: {
          'isVietNamese': tutorNationalityController.value.isVietNamese,
          'isNative': tutorNationalityController.value.isNative,
        },
      ),
    ))
        .share();

    final fetchTopicState$ = Rx.merge([
      fetchTopics$
          .where((isValid) => isValid)
          .debug(log: debugPrint)
          .exhaustMap((_) {
        try {
          return searchTutorUseCase
              .listTopic()
              .doOn(
            listen: () => loadingController.add(true),
            cancel: () => loadingController.add(false),
          )
              .map(
                (data) => data.fold(
                ifLeft: (error) => ListTopicFailed(
                    message: error.message, error: error.code),
                ifRight: (List<Topic> listTopic) {
                  if (listTopic.isNotEmpty) {
                    topicController.add(
                      [const Topic(name: 'All'), ...listTopic],
                    );
                  }
                  return const ListTopicSuccess();
                }),
          );
        } catch (e) {
          return Stream<TutorSearchState>.error(
            ListTopicFailed(message: e.toString()),
          );
        }
      }),
      fetchTopics$.where((isValid) => !isValid).map(
            (_) => const InvalidSearch(),
      )
    ]).whereNotNull().share();

    final state$ = Rx.merge<TutorSearchState>([
      fetchTopicState$,
      selectedTopicState$,
      openSearchResultPageState$,
      selectedNationalityTutorState$,
    ]).whereNotNull().share();

    final subscriptions = <String, Stream>{
      'state': state$,
      'loadingController': loadingController,
    }.debug();

    return TutorSearchBloc._(
      dispose: () async => await DisposeBag([
        topicController,
        loadingController,
        fetchTopicsController,
        selectedTopicController,
        selectTopicController,
        tutorNationalityController,
        openSearchResultPageController,
        selectedNationalityTutorController,
        ...subscriptions,
      ]).dispose(),
      listTopic: () => fetchTopicsController.add(null),
      selectedTopic$: selectTopicController,
      selectedTopic: (topic) => selectedTopicController.add(topic),
      selectedTutorNationality: (tutorString) =>
          selectedNationalityTutorController.add(tutorString),
      loading$: loadingController,
      topics$: topicController,
      tutorNationality: tutorNationalityController,
      openSearchResultPage: (searchText) =>
          openSearchResultPageController.add(searchText.trim()),
      state$: state$,
    );
  }
}

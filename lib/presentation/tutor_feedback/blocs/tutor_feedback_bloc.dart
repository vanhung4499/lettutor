import 'package:disposebag/disposebag.dart';
import 'package:lettutor/core/utils/stream_extension.dart';
import 'package:lettutor/core/utils/type_defs.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/request/tutor_feedback_request.dart';
import 'package:lettutor/domain/usecases/feedback_tutor_usecase.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import 'tutor_feedback_state.dart';

@injectable
class TutorFeedbackBloc extends DisposeCallbackBaseBloc {
  ///[function call]
  final Function3<String, String, double, void> rattingTutor;

  ///[Stream]

  final Stream<bool> loading$;

  final Stream<TutorFeedbackState> state$;

  TutorFeedbackBloc._({
    required Function0<void> dispose,
    required this.rattingTutor,
    required this.loading$,
    required this.state$,
  }) : super(dispose);

  factory TutorFeedbackBloc(@factoryParam String booId,
      {required TutorFeedbackUseCase tutorFeedbackUseCase}) {
    final rattingTutorController = PublishSubject<void>();

    final loadingController = BehaviorSubject<bool>.seeded(false);

    final userIdController = BehaviorSubject<String>.seeded("");

    final rattingController = BehaviorSubject<double>.seeded(1.0);

    final contentController = BehaviorSubject<String>.seeded("");

    final rattingTutor$ = rattingTutorController.stream
        .withLatestFrom(loadingController.stream, (_, loading) => !loading)
        .share();

    final state$ = Rx.merge<TutorFeedbackState>([
      rattingTutor$
          .where((isValid) => isValid)
          .withLatestFrom(
          Rx.combineLatest3(
              userIdController.stream,
              rattingController.stream,
              contentController.stream,
                  (userId, ratting, content) => TutorFeedbackRequest(
                booId: booId,
                userId: userId,
                ratting: ratting,
                content: content,
              )),
              (_, request) => request)
          .exhaustMap((request) {
        try {
          return tutorFeedbackUseCase
              .feedbackTutor(request: request)
              .doOn(
            listen: () => loadingController.add(true),
            cancel: () => loadingController.add(false),
          )
              .map(
                (data) => data.fold(
                ifLeft: (error) => FeedbackFailed(
                    message: error.message, error: error.code),
                ifRight: (cData) => const FeedbackSuccess()),
          );
        } catch (e) {
          return Stream.error(FeedbackFailed(message: e.toString()));
        }
      }),
      rattingTutor$
          .where((isValid) => !isValid)
          .map((_) => FeedbackFailed(message: "Invalid value"))
    ]).whereNotNull().share();

    final subscriptions = <String, Stream>{
      'state': state$,
      'loadingController': loadingController,
    }.debug();

    return TutorFeedbackBloc._(
      dispose: () async => await DisposeBag([
        rattingTutorController,
        loadingController,
        userIdController,
        rattingController,
        contentController,
        ...subscriptions,
      ]).dispose(),
      rattingTutor: (userId, content, ratting) {
        userIdController.add(userId);
        rattingController.add(ratting);
        contentController.add(content);
        rattingTutorController.add(null);
      },
      state$: state$,
      loading$: loadingController,
    );
  }
}

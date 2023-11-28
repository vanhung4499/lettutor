
import 'package:disposebag/disposebag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/core/utils/stream_extension.dart';
import 'package:lettutor/core/utils/type_defs.dart';
import 'package:lettutor/core/utils/validator.dart';
import 'package:lettutor/domain/usecases/reset_password_usecase.dart';
import 'package:lettutor/presentation/auth/blocs/reset_password/reset_password_state.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

@injectable
class ResetPasswordBloc extends DisposeCallbackBaseBloc {
  ///[Functions]
  final Function0<void> submitReset;

  final Function1<String, void> emailedChanged;

  ///[Streams]
  final Stream<String?> emailError$;

  final Stream<bool?> loading$;

  final Stream<ResetPasswordState> state$;

  ResetPasswordBloc._({
    required Function0<void> dispose,
    required this.submitReset,
    required this.emailedChanged,
    //-----------------------------------
    required this.emailError$,
    required this.loading$,
    required this.state$,
  }) : super(dispose);

  factory ResetPasswordBloc({required ResetPasswordUseCase resetPasswordUseCase}) {
    final loadingController = BehaviorSubject<bool>.seeded(false);

    //----------------------------------------

    final emailController = PublishSubject<String>();

    final submitResetController = PublishSubject<void>();

    ///[Handle actions]

    final isValidSubmit$ = Rx.combineLatest2(
      emailController.stream.map(Validator.isValidEmail),
      loadingController.stream,
          (isValidEmail, loading) => isValidEmail && !loading,
    ).shareValueSeeded(false);

    final submit$ = submitResetController.stream
        .withLatestFrom(isValidSubmit$, (_, isValid) => isValid)
        .share();

    final state$ = Rx.merge<ResetPasswordState>([
      submit$
          .where((isValid) => isValid)
          .debug(log: debugPrint)
          .withLatestFrom(emailController.stream, (_, email) => email)
          .exhaustMap((email) {
        try {
          return resetPasswordUseCase
              .resetPassword(email: email)
              .doOn(
            listen: () => loadingController.add(true),
            cancel: () => loadingController.add(false),
          )
              .map(
                (data) => data.fold(
              ifLeft: (error) => ResetPasswordFailed(message: error.message),
              ifRight: (_) => const ResetPasswordSuccess(),
            ),
          );
        } catch (e) {
          return Stream.error(ResetPasswordFailed(message: e.toString()));
        }
      }),
      submit$
          .where((isValid) => !isValid)
          .map((_) => ResetPasswordFailed(message: "Invalid format"))
    ]).whereNotNull().share();

    final emailError$ = emailController.stream
        .map((email) {
      if (Validator.isValidEmail(email)) return null;
      return "Invalid email address";
    })
        .distinct()
        .share();
    final subscriptions = <String, Stream>{
      'state': state$,
      'emailError': emailError$,
      'loading': loadingController,
      'isValidSubmit': isValidSubmit$,
    }.debug();

    return ResetPasswordBloc._(
      state$: state$,
      dispose: () async => await DisposeBag([
        emailController,
        loadingController,
        submitResetController,
        ...subscriptions,
      ]).dispose(),
      submitReset: () => submitResetController.add(null),
      emailError$: emailError$,
      loading$: loadingController,
      emailedChanged: trim.pipe(emailController.add),
    );
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:disposebag/disposebag.dart';
import 'package:lettutor/data/models/user/user_token_model.dart';
import 'package:lettutor/presentation/auth/blocs/login/login_state.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:lettutor/core/utils/type_defs.dart';
import 'package:lettutor/core/utils/validator.dart';
import 'package:lettutor/core/utils/stream_extension.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/domain/usecases/login_usecase.dart';

@injectable
class LoginBloc extends DisposeCallbackBaseBloc {
  ///[functions] input

  final Function0<void> submitLogin;

  final Function0<void> submitRegister;

  final Function0<void> submitGoogleLogin;

  final Function1<String, void> emailedChanged;

  final Function1<String, void> passwordChanged;

  ///[Streams] response

  final Stream<bool?> loading$;

  final Stream<LoginState> message$;

  final Stream<String?> emailError$;

  final Stream<String?> passwordError$;

  LoginBloc._({
    required Function0<void> dispose,

    ///[Event functions]
    required this.submitLogin,
    required this.emailedChanged,
    required this.submitRegister,
    required this.passwordChanged,
    required this.submitGoogleLogin,

    ///[States]
    required this.message$,
    required this.loading$,
    required this.emailError$,
    required this.passwordError$,
  }) : super(dispose);

  factory LoginBloc({required LoginUseCase login}) {
    ///[controllers]
    final emailController = PublishSubject<String>();

    final passwordController = PublishSubject<String>();

    final submitLoginController = PublishSubject<void>();

    final submitGoogleLoginController = PublishSubject<void>();

    final loadingController = BehaviorSubject<bool>.seeded(false);

    final controllers = [
      emailController,
      passwordController,
      submitLoginController,
      loadingController,
      submitGoogleLoginController,
    ];

    ///
    ///[Streams]
    ///

    ///[check function] check input is in format
    final isValidSubmit$ = Rx.combineLatest3(
      emailController.stream.map(Validator.isValidEmail),
      passwordController.stream.map(Validator.isValidPassword),
      loadingController.stream,
          (isValidEmail, isValidPassword, loading) =>
      isValidEmail && isValidPassword && !loading,
    ).shareValueSeeded(false);

    final credential$ = Rx.combineLatest2(
      emailController.stream,
      passwordController.stream,
          (String email, String password) =>
          Credential(email: email, password: password),
    );

    final submit$ = submitLoginController.stream
        .withLatestFrom(isValidSubmit$, (_, isValid) => isValid)
        .share();

    ///[Google Login]
    final submitGoogleLogin$ = submitGoogleLoginController.stream
        .withLatestFrom(loadingController.stream, (_, loading) => !loading)
        .share();

    final message$ = Rx.merge<LoginState>([
      submit$
          .where((isValid) => isValid)
          .withLatestFrom(credential$, (_, Credential credential) => credential)
          .exhaustMap((credential) {
        try {
          return login
              .login(
            email: credential.email,
            password: credential.password,
          )
              .doOn(
            ///[loading state] set loading after submit
            listen: () => loadingController.add(true),
            cancel: () => loadingController.add(false),
          )
              .map(_responseToMessage);
        } catch (e) {
          return Stream<LoginState>.error(
            LoginErrorMessage(message: e.toString()),
          );
        }
      }),
      submit$
          .where((isValid) => !isValid)
          .map((_) => const InvalidFormatMessage()),
      submitGoogleLogin$.where((isValid) => isValid).exhaustMap((_) {
        try {
          return login
              .googleLogin()
              .doOn(
              listen: () => loadingController.add(true),
              cancel: () => loadingController.add(false))
              .map(
                (data) => data.fold(
                ifLeft: (error) => LoginErrorMessage(
                    message: error.message, error: error.code),
                ifRight: (_) => const LoginErrorMessage()),
          );
        } catch (e) {
          return Stream.error(LoginErrorMessage(message: e.toString()));
        }
      })
    ]).whereNotNull().share();

    final emailError$ = emailController.stream
        .map((email) {
      if (Validator.isValidEmail(email)) return null;
      return 'Invalid email address';
    })
        .distinct()
        .share();

    final passwordError$ = passwordController.stream
        .map((password) {
      if (Validator.isValidPassword(password)) return null;
      return 'Invalid password address';
    })
        .distinct()
        .share();

    final subscriptions = <String, Stream>{
      'message': message$,
      'emailError': emailError$,
      'loading': loadingController,
      'isValidSubmit': isValidSubmit$,
      'passwordError': passwordError$,
    }.debug();

    subscriptions;

    return LoginBloc._(
      dispose: () async {
        try {
          await DisposeBag([...controllers, ...subscriptions]).dispose();
        } catch (exceptions) {
          log('[Login exceptions] ${exceptions.toString()}');
        } finally {
          // super.dispose();
        }
      },
      message$: message$,
      emailError$: emailError$,
      loading$: loadingController,
      passwordError$: passwordError$,
      emailedChanged: trim.pipe(emailController.add),
      passwordChanged: trim.pipe(passwordController.add),
      submitLogin: () => submitLoginController.add(null),
      submitRegister: () => submitLoginController.add(null),
      submitGoogleLogin: () => submitGoogleLoginController.add(null),
    );
  }

  static LoginState _responseToMessage(SResult<UserTokenModel?> data) {
    return data.fold(
      ifRight: (_) => const LoginSuccessMessage(),
      ifLeft: (error) =>
          LoginErrorMessage(error: error.code, message: error.message),
    );
  }
}

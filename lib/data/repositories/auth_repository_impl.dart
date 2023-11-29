import 'package:dart_either/dart_either.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/core/config/app_env.dart';
import 'package:lettutor/core/network/app_exception.dart';
import 'package:lettutor/core/services/google_sign_in_service.dart';
import 'package:lettutor/core/utils/validator.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/user/user_token_model.dart';
import 'package:lettutor/data/providers/network/apis/auth_api.dart';
import 'package:lettutor/data/providers/network/base_api.dart';
import 'package:lettutor/data/providers/network/data_state.dart';
import 'package:lettutor/domain/repositories/auth_repository.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl extends BaseApi implements AuthRepository {
  final AuthApi _authApi;
  final GoogleSignInService _googleSignInService;
  AuthRepositoryImpl(this._authApi, this._googleSignInService);

  @override
  SingleResult<UserTokenModel?> login(
      {required String email, required String password}) {
    final body = {'email': email, 'password': password};
    return authFunction(functionCall: _authApi.login(body: body));
  }

  @override
  SingleResult<UserTokenModel?> register(
      {required String email, required String password}) {
    final body = {
      'email': email,
      'password': password,
      'source': null,
    };
    return authFunction(functionCall: _authApi.register(body: body));
  }

  @override
  SingleResult<bool?> resetPassword({required String email}) =>
      SingleResult.fromCallable(() async {
        final response = await getStateOf(
          request: () async => _authApi.resetPassword(body: {"email": email}),
        );
        return response.toBoolResult();
      });

  @override
  SingleResult<bool?> facebookSignIn() {
    throw UnimplementedError();
  }

  @override
  SingleResult<UserTokenModel?> googleSignIn() => SingleResult.fromCallable(() async {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
          AppEnv.googleClientId,
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
      );

      try {
        final googleSignInAccount = await googleSignIn.signIn();
        if (googleSignInAccount == null) {
          return Either.left(AppException(message: "Google sign in error"));
        }
        String? accessToken = "";
        await googleSignInAccount.authentication.then((value) {
          accessToken = value.accessToken;
        });
        if (accessToken?.isNotEmpty ?? false) {
          final response = await getStateOf(
            request: () async =>
                _authApi.googleSignIn(body: {"access_token": accessToken}),
          );

          if (response is DataFailed) {
            return Either.left(
              AppException(message: response.dioError?.message ?? 'Error'),
            );
          }

          if (response.data == null) {
            return Either.left(AppException(message: 'Data error'));
          }

          final userTokenModel = response.data!.tokens;
          if (Validator.tokenNull(userTokenModel)) {
            return Either.left(AppException(message: 'Data null'));
          }

          await saveToken(userTokenModel);

          return Either.right(userTokenModel);
        }
        return Either.left(AppException(message: "Google sign in error"));
      } catch (e) {
        return Either.left(AppException(message: e.toString()));
      }
    });


  @override
  SingleResult<bool?> verifyAccountEmail({required String token}) =>
      SingleResult.fromCallable(
            () async {
          final response = await getStateOf(
            request: () async => _authApi.verifyEmailAccount(token),
          );
          return response.toBoolResult();
        },
      );

}

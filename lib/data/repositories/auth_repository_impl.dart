import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lettutor/app/core/data/network/app_exception.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/user/user_token_model.dart';
import 'package:lettutor/data/providers/network/apis/auth_api.dart';
import 'package:lettutor/data/providers/network/base_api.dart';
import 'package:lettutor/data/providers/network/data_state.dart';
import 'package:lettutor/domain/repositories/auth_repository.dart';

void delayed() async {
  await Future.delayed(const Duration(seconds: 6));
}

class AuthRepositoryImpl extends BaseApi implements AuthRepository {
  final AuthApi _authApi = Get.find();

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
  SingleResult<bool?> googleSignIn() => SingleResult.fromCallable(() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
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
        return response.toBoolResult();
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

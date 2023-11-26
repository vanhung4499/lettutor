import 'package:get/get.dart';
import 'package:lettutor/data/models/user/user_token_model.dart';
import 'package:lettutor/data/providers/network/apis/auth_api.dart';
import 'package:lettutor/domain/repositories/auth_repository.dart';

void delayed() async {
  await Future.delayed(const Duration(seconds: 6));
}

class AuthRepositoryImpl extends AuthRepository {
  final AuthApi _authApi = Get.find();

  @override
  Future<bool?> facebookSignIn() {

  }

  @override
  Future<bool?> googleSignIn() {

  }

  @override
  Future<UserTokenModel?> login({required String email, required String password}) {
    final body = {'email': email, 'password': password};
    return _authApi.login(body: body).then((value) => value?.tokens);
  }

  @override
  Future<UserTokenModel?> register({required String email, required String password}) {
    final body = {
      'email': email,
      'password': password,
      'source': null,
    };
    return _authApi.register(body: body).then((value) => value.);
  }

  @override
  Future<bool?> resetPassword({required String email}) {
    final body = {'email': email};
    return _authApi.resetPassword(body: body).then((value) => value?);
  }

  @override
  Future<bool?> verifyAccountEmail({required String token}) {
    // TODO: implement verifyAccountEmail
    throw UnimplementedError();
  }

}

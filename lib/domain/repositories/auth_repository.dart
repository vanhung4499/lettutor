import 'package:lettutor/data/models/user/user_token_model.dart';

abstract class AuthRepository {
  Future<UserTokenModel?> login(
      {required String email, required String password});
  Future<UserTokenModel?> register(
      {required String email, required String password});
  Future<bool?> resetPassword({required String email});

  Future<bool?> googleSignIn();

  Future<bool?> facebookSignIn();

  Future<bool?> verifyAccountEmail({required String token});
}

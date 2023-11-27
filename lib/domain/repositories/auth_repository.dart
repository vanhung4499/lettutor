import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/user/user_token_model.dart';

abstract class AuthRepository {
  SingleResult<UserTokenModel?> login(
      {required String email, required String password});

  SingleResult<UserTokenModel?> register(
      {required String email, required String password});

  SingleResult<bool?> resetPassword({required String email});

  SingleResult<bool?> googleSignIn();

  SingleResult<bool?> facebookSignIn();

  SingleResult<bool?> verifyAccountEmail({required String token});
}

import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/user/user_token_model.dart';
import 'package:lettutor/domain/repositories/auth_repository.dart';

@injectable
class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  SingleResult<UserTokenModel?> login(
      {required String email, required String password}) =>
      _authRepository.login(email: email, password: password);

  SingleResult<UserTokenModel?> register(
      {required String email, required String password}) =>
      _authRepository.register(email: email, password: password);

  SingleResult<UserTokenModel?> googleLogin() => _authRepository.googleSignIn();

  SingleResult<bool?> verifyAccount(String token) =>
      _authRepository.verifyAccountEmail(token: token);
}

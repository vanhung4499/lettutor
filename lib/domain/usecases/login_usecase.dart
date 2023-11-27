import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/user/user_token_model.dart';
import 'package:lettutor/domain/repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  SingleResult<UserTokenModel?> login(
      {required String email, required String password}) =>
      _authRepository.login(email: email, password: password);

  SingleResult<UserTokenModel?> register(
      {required String email, required String password}) =>
      _authRepository.register(email: email, password: password);

  SingleResult<bool?> googleLogin() => _authRepository.googleSignIn();

  SingleResult<bool?> verifyAccount() => _authRepository.verifyAccountEmail(
    token:
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MjQ5MjAwOC1jYWY3LTRjZTUtYTc5Ny1iNzFkZmJjM2E1ZGEiLCJpYXQiOjE2OTY5MTc3MTIsImV4cCI6MTY5NzAwNDExMiwidHlwZSI6ImFjY2VzcyJ9.ApAT8knr_Goe-re118kn2EBW_PGlFdpAFl4dk9OfiTM",
  );
}

import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/domain/repositories/auth_repository.dart';

class ResetPassUseCase {
  final AuthRepository _authRepository;
  ResetPassUseCase(this._authRepository);

  SingleResult<bool?> resetPassword({required String email}) =>
      _authRepository.resetPassword(email: email);
}

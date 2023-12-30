import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/domain/repositories/auth_repository.dart';

@injectable
class ResetPasswordUseCase {
  final AuthRepository _authRepository;
  ResetPasswordUseCase(this._authRepository);

  SingleResult<bool?> resetPassword({required String email}) =>
      _authRepository.resetPassword(email: email);
}

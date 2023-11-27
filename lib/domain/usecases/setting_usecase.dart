import 'package:lettutor/domain/entities/user/user.dart';
import 'package:lettutor/domain/repositories/user_repository.dart';
import 'package:lettutor/domain/usecases/common_usecase.dart';

class SettingUseCase extends CommonUseCase<User> {
  final UserRepository _userRepository;
  SettingUseCase(this._userRepository);

  @override
  Future<User?> getUserInfo(token) async => _userRepository.getUserInfo();
  @override
  Future<bool> logOut({required String token}) async => true;
}

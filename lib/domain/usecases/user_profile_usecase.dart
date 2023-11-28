import 'package:dart_either/dart_either.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/core/network/app_exception.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/request/update_profile_request.dart';
import 'package:lettutor/domain/entities/common/topic.dart';
import 'package:lettutor/domain/entities/user/user.dart';
import 'package:lettutor/domain/repositories/common_repository.dart';
import 'package:lettutor/domain/repositories/user_repository.dart';

@injectable
class UserProfileUseCase {
  final UserRepository _userRepository;
  final CommonRepository _commonRepository;

  UserProfileUseCase(this._userRepository, this._commonRepository);

  SingleResult<User> getUserInfo() => SingleResult.fromCallable(
        () async {
      try {
        final response = await _userRepository.getUserInfo();
        if (response == null) {
          return Either.left(AppException(message: 'Data null'));
        }
        return Either.right(response);
      } on AppException catch (e) {
        return Either.left(AppException(message: e.toString()));
      }
    },
  );

  SingleResult<User> updateUserInf(
      {required UpdateProfileRequest updateProfileRequest}) =>
      _userRepository.updateUserInfo(
          request: updateProfileRequest);

  SingleResult<List<Topic>> listTopic() =>_commonRepository.listTopic();
}

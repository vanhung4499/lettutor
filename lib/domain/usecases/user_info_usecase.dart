import 'package:fpdart/fpdart.dart';
import 'package:lettutor/app/core/data/network/app_exception.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/request/update_profile_request.dart';
import 'package:lettutor/domain/entities/common/topic.dart';
import 'package:lettutor/domain/entities/user/user.dart';
import 'package:lettutor/domain/repositories/common_repository.dart';
import 'package:lettutor/domain/repositories/user_repository.dart';

class UserInfoUseCase {
  final UserRepository _userRepository;
  final CommonRepository _commonRepository;

  UserInfoUseCase(this._userRepository, this._commonRepository);

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
          updateProfileRequest: updateProfileRequest);

  SingleResult<List<Topic>> getTopics() =>_commonRepository.getTopics();
}

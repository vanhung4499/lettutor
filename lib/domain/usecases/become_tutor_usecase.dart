import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/request/become_tutor_request.dart';
import 'package:lettutor/domain/entities/common/topic.dart';
import 'package:lettutor/domain/repositories/common_repository.dart';
import 'package:lettutor/domain/repositories/user_repository.dart';

class BecomeTutorUseCase {
  final UserRepository _userRepository;
  final CommonRepository _commonRepository;
  BecomeTutorUseCase(this._userRepository, this._commonRepository);

  SingleResult<List<Topic>> getTopics() => _commonRepository.getTopics();

  SingleResult<bool> registeringTutor(
      {required BecomeTutorRequest becomeTutorRequest}) =>
      _userRepository.becomeTutor(becomeTutorRequest: becomeTutorRequest);
}

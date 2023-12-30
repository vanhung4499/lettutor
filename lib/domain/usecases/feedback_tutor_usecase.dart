import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/request/tutor_feedback_request.dart';
import 'package:lettutor/domain/repositories/user_repository.dart';

@injectable
class TutorFeedbackUseCase {
  final UserRepository _userRepository;
  TutorFeedbackUseCase(this._userRepository);

  SingleResult<bool> feedbackTutor(
      {required TutorFeedbackRequest request}) =>
      _userRepository.feedbackTutor(request: request);
}

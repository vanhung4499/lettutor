import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/request/review_tutor_request.dart';
import 'package:lettutor/domain/repositories/user_repository.dart';

@injectable
class RattingUseCase {
  final UserRepository _userRepository;
  RattingUseCase(this._userRepository);

  SingleResult<bool> rattingTutor(
      {required ReviewTutorRequest reviewTutorRequest}) =>
      _userRepository.reviewTutor(reviewTutorRequest: reviewTutorRequest);
}

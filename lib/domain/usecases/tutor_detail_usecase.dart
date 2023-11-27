import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/tutor/review.dart';
import 'package:lettutor/domain/entities/tutor/tutor_detail.dart';
import 'package:lettutor/domain/repositories/tutor_repository.dart';
import 'package:lettutor/domain/repositories/user_repository.dart';

@injectable
class TutorDetailUseCase {
  final TutorRepository _tutorRepository;
  final UserRepository _userRepository;
  TutorDetailUseCase(this._tutorRepository, this._userRepository);

  SingleResult<TutorDetail?> getTutorById({required String userId}) =>
      _tutorRepository.getTutorById(userId: userId);

  SingleResult<bool> addTutorToFavorite({required String userId}) =>
      _tutorRepository.addTutorToFavorite(userId: userId);

  SingleResult<Pagination<Review>> getReviews(
      {required String userId,
        required int perPage,
        required int currentPage}) =>
      _tutorRepository.getListReview(
          page: currentPage, perPage: perPage, userId: userId);

  SingleResult<bool> reportTutor(
      {required String userId, required String content}) =>
      _userRepository.reportUser(userId: userId, content: content);
}

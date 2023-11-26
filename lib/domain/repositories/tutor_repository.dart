import 'package:lettutor/data/models/request/search_tutor_request.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/schedule/schedule.dart';
import 'package:lettutor/domain/entities/tutor/review.dart';
import 'package:lettutor/domain/entities/tutor/tutor_detail.dart';
import 'package:lettutor/domain/entities/tutor/tutor_fav.dart';

abstract class TutorRepositories {
  Future<TutorFav> pagFetchTutorsData(
      {required int page, required int perPge});

  Future<bool> addTutorToFavorite({required String userId});

  Future<TutorFav?> searchTutor({
    required SearchTutorRequest searchTutorRequest,
  });

  Future<TutorDetail?> getTutorById({required String userId});

  Future<List<Schedule>> getTutorSchedule(
      {required String tutorId,
        required DateTime startTime,
        required DateTime endTime});

  Future<Pagination<Review>> getReviews(
      {required int page, required int perPge, required String userId});
}

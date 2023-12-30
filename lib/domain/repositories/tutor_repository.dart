import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/request/search_tutor_request.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/schedule/schedule.dart';
import 'package:lettutor/domain/entities/tutor/review.dart';
import 'package:lettutor/domain/entities/tutor/tutor_detail.dart';
import 'package:lettutor/domain/entities/tutor/tutor_fav.dart';

abstract class TutorRepository {
  SingleResult<TutorFav> getListTutor(
      {required int page, required int perPage});

  SingleResult<bool> addTutorToFavorite({required String userId});

  SingleResult<TutorFav?> searchTutor({
    required SearchTutorRequest request,
  });

  SingleResult<TutorDetail?> getTutorById({required String userId});

  SingleResult<List<Schedule>> getTutorSchedule(
      {required String tutorId,
        required DateTime startTime,
        required DateTime endTime});

  SingleResult<Pagination<Review>> getListReview(
      {required int page, required int perPage, required String userId});
}

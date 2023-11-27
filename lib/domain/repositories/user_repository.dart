
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/request/become_tutor_request.dart';
import 'package:lettutor/data/models/request/review_tutor_request.dart';
import 'package:lettutor/data/models/request/update_profile_request.dart';
import 'package:lettutor/domain/entities/user/user.dart';

abstract class UserRepository {
  SingleResult<bool> reportUser(
      {required String userId, required String content});

  SingleResult<bool> bookingTutor(
      {required List<String> scheduleDetailIds, required String note});

  SingleResult<bool> cancelBookingTutor({required List<String> scheduleDetailIds});

  SingleResult<bool> updateStudentRequest(
      {required String booId, required String content});

  SingleResult<bool> reviewTutor(
      {required ReviewTutorRequest reviewTutorRequest});

  SingleResult<int> getTotalTime();

  SingleResult<User> updateUserInfo(
      {required UpdateProfileRequest updateProfileRequest});

  Future<User?> getUserInfo();

  SingleResult<bool> becomeTutor(
      {required BecomeTutorRequest becomeTutorRequest});
}

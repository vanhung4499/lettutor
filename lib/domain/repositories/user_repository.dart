
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/request/become_tutor_request.dart';
import 'package:lettutor/data/models/request/tutor_feedback_request.dart';
import 'package:lettutor/data/models/request/update_profile_request.dart';
import 'package:lettutor/data/models/request/upload_avatar_request.dart';
import 'package:lettutor/domain/entities/user/user.dart';

abstract class UserRepository {
  SingleResult<bool> reportUser(
      {required String userId, required String content});

  SingleResult<bool> bookingTutor(
      {required List<String> scheduleDetailIds, required String note});

  SingleResult<bool> cancelBookingTutor({required List<String> scheduleDetailIds});

  SingleResult<bool> updateStudentRequest(
      {required String booId, required String content});

  SingleResult<bool> feedbackTutor(
      {required TutorFeedbackRequest request});

  SingleResult<int> getTotalTime();

  SingleResult<User> updateUserInfo(
      {required UpdateProfileRequest request});

  SingleResult<bool> uploadAvatar(
      {required UploadAvatarRequest request});

  Future<User?> getUserInfo();

  SingleResult<bool> becomeTutor(
      {required BecomeTutorRequest request});
}


import 'package:lettutor/data/models/request/become_tutor_request.dart';
import 'package:lettutor/data/models/request/review_tutor_request.dart';
import 'package:lettutor/data/models/request/update_profile_request.dart';
import 'package:lettutor/domain/entities/user/user.dart';

abstract class UserRepositories {
  Future<bool> reportUser(
      {required String userId, required String content});

  Future<bool> booTutor(
      {required List<String> scheduleDetailIds, required String note});

  Future<bool> cancelBooTutor({required List<String> scheduleDetailIds});

  Future<bool> updateStudentRequest(
      {required String booId, required String content});

  Future<bool> reviewTutor(
      {required ReviewTutorRequest reviewTutorRequest});

  Future<int> getTotalTime();

  Future<User> updateUserInfo(
      {required UpdateProfileRequest updateProfileRequest});

  Future<User?> getUserInfo();

  Future<bool> becomeTutor(
      {required BecomeTutorRequest becomeTutorRequest});
}


import 'package:dart_either/dart_either.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/core/network/app_exception.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/request/become_tutor_request.dart';
import 'package:lettutor/data/models/request/tutor_feedback_request.dart';
import 'package:lettutor/data/models/request/update_profile_request.dart';
import 'package:lettutor/data/models/request/upload_avatar_request.dart';
import 'package:lettutor/data/providers/network/apis/user_api.dart';
import 'package:lettutor/data/providers/network/base_api.dart';
import 'package:lettutor/data/providers/network/data_state.dart';
import 'package:lettutor/domain/entities/user/user.dart';
import 'package:lettutor/domain/repositories/user_repository.dart';

@Injectable(as: UserRepository)
class UserRepositoriesImpl extends BaseApi implements UserRepository {
  final UserApi _userApi;

  UserRepositoriesImpl(this._userApi);

  @override
  SingleResult<bool> reportUser(
      {required String userId, required String content}) =>
      SingleResult.fromCallable(() async {
        final body = {'tutorId': userId, 'content': content};

        final response = await getStateOf(
            request: () async => await _userApi.reportTutor(body: body));

        return response.toBoolResult();
      });

  @override
  SingleResult<bool> bookingTutor(
      {required List<String> scheduleDetailIds, required String note}) =>
      SingleResult.fromCallable(() async {
        await Future.delayed(const Duration(seconds: 2));
        final body = {'scheduleDetailIds': scheduleDetailIds, 'note': note};
        final response = await getStateOf(
            request: () async => _userApi.bookingTutor(body: body));
        return response.toBoolResult();
      });

  @override
  SingleResult<bool> cancelBookingTutor(
      {required List<String> scheduleDetailIds}) =>
      SingleResult.fromCallable(() async {
        final body = {'scheduleDetailIds': scheduleDetailIds};
        final response = await getStateOf(
            request: () async => _userApi.cancelTutor(body: body));
        return response.toBoolResult();
      });

  @override
  SingleResult<bool> updateStudentRequest(
      {required String booId, required String content}) =>
      SingleResult.fromCallable(() async {
        final body = {"studentRequest": content};
        final response = await getStateOf(
          request: () async => _userApi.updateStudentRequest(booId, body: body),
        );
        return response.toBoolResult();
      });

  @override
  SingleResult<int> getTotalTime() => SingleResult.fromCallable(() async {
    final response = await getStateOf(
      request: () async => _userApi.getTotalTime(),
    );
    if (response is DataFailed) {
      return Either.left(
        AppException(message: response.dioError?.message ?? 'Error'),
      );
    }
    final responseData = response.data;
    if (responseData == null) {
      return Either.left(AppException(message: "Data null"));
    }
    return Either.right(responseData.total);
  });

  @override
  Future<User?> getUserInfo() async {
    final response = await getStateOf(
      request: () async => await _userApi.getUserInfo(),
    );
    if (response is DataFailed) {
      throw AppException(message: response.dioError?.message ?? 'Error');
    }
    final responseData = response.data?.user;
    if (responseData == null) {
      throw AppException(message: 'Data null');
    }
    return responseData.toEntity();
  }

  @override
  SingleResult<User> updateUserInfo(
      {required UpdateProfileRequest request}) =>
      SingleResult.fromCallable(() async {
        final response = await getStateOf(
          request: () async =>
          await _userApi.updateUserInfo(body: request.toMap),
        );
        if (response is DataFailed) {
          return Either.left(
            AppException(message: response.dioError?.message ?? 'Error'),
          );
        }
        final responseData = response.data?.user;
        if (responseData != null) {
          return Either.right(responseData.toEntity());
        }
        return Either.left(AppException(message: "Data null"));
      });


  @override
  SingleResult<bool> uploadAvatar(
      {required UploadAvatarRequest request}) =>
      SingleResult.fromCallable(() async {
        final response = await getStateOf(
          request: () async =>
          await _userApi.uploadAvatar(body: request.toJson()),
        );
        return response.toBoolResult();
      });

  @override
  SingleResult<bool> feedbackTutor(
      {required TutorFeedbackRequest request}) =>
      SingleResult.fromCallable(() async {
        final response = await getStateOf(
          request: () async =>
              _userApi.reviewTutor(body: request.toJson()),
        );
        return response.toBoolResult();
      });

  @override
  SingleResult<bool> becomeTutor(
      {required BecomeTutorRequest request}) =>
      SingleResult.fromCallable(() async {
        final body = await request.toJson();
        final response = await getStateOf(
          request: () async => _userApi.becomeTutor(
            body: body,
            contentType: "multipart/form-data",
          ),
        );
        return response.toBoolResult();
      });

}
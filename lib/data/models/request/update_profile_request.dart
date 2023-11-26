import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_profile_request.freezed.dart';

@freezed
class UpdateProfileRequest with _$UpdateProfileRequest {
  const factory UpdateProfileRequest({
    required String name,
    required String country,
    required DateTime birthDay,
    required String level,
    required String studySchedule,
    required List<String>? learnTopic,
    required List<String>? testPreparations,
  }) = _UpdateProfileRequest;
}
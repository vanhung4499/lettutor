import 'package:freezed_annotation/freezed_annotation.dart';

part 'tutor.freezed.dart';

@freezed
class Tutor with _$Tutor {
  const factory Tutor({
    required String id,
    String? level,
    String? email,
    String? google,
    String? facebook,
    String? apple,
    String? avatar,
    String? name,
    String? country,
    String? phone,
    String? language,
    DateTime? birthday,
    bool? requestPassword,
    bool? isActivated,
    bool? isPhoneActivated,
    String? requireNote,
    int? timezone,
    String? phoneAuth,
    bool? isPhoneAuthActivated,
    // String? studySchedule,
    bool? canSendMessage,
    bool? isPublicRecord,
    String? caredByStaffId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deletedAt,
    String? studentGroupId,
    String? userId,
    String? video,
    String? bio,
    String? education,
    String? experience,
    String? profession,
    String? accent,
    String? targetStudent,
    String? interests,
    String? languages,
    String? specialties,
    String? resume,
    double? rating,
    bool? isNative,
    double? price,
    bool? isOnline,
  }) = _Tutor;
}
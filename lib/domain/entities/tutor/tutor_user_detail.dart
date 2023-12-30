import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/domain/entities/course/course_preview.dart';

part 'tutor_user_detail.freezed.dart';

@freezed
class TutorUserDetail with _$TutorUserDetail {
  const factory TutorUserDetail({
    required String id,
    String? level,
    String? avatar,
    String? name,
    String? country,
    String? language,
    bool? isPublicRecord,
    String? caredByStaffId,
    String? studentGroupId,
    String? zaloUserId,
    List<CoursePreview>? courses,
  }) = _TutorUserDetail;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/domain/entities/tutor/tutor_user_detail.dart';

part 'tutor_detail.freezed.dart';

@freezed
class TutorDetail with _$TutorDetail {
  const factory TutorDetail({
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
    double? rating,
    double? avgRating,
    int? totalFeedback,
    bool? isNative,
    bool? isFavorite,
    String? youtubeVideoId,
    TutorUserDetail? user,

  }) = _TutorDetail;
}

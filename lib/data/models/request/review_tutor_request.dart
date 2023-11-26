import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_tutor_request.freezed.dart';

@freezed
class ReviewTutorRequest with _$ReviewTutorRequest {
  const factory ReviewTutorRequest({
    required String booId,
    required String userId,
    required double ratting,
    required String content,
  }) = _ReviewTutorRequest;
}
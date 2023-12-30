import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/domain/entities/tutor/review_user.dart';

part 'review.freezed.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    required double rating,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    required ReviewUser reviewUser,
  }) = _Review;
}

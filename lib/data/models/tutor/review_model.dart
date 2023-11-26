
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/data/models/tutor/review_user_model.dart';
import 'package:lettutor/domain/entities/tutor/review.dart';
import 'package:lettutor/domain/entities/tutor/review_user.dart';

part 'review_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReviewModel {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'content')
  final String? content;

  @JsonKey(name: 'rating')
  final double? rating;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  @JsonKey(name: 'firstInfo')
  final ReviewUserModel? reviewUserModel;

  ReviewModel(
      this.id,
      this.content,
      this.rating,
      this.createdAt,
      this.updatedAt,
      this.reviewUserModel,
      );

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Review toEntity() => Review(
    id: id ?? '',
    rating: rating ?? 0.0,
    content: content ?? '',
    createdAt: createdAt ?? DateTime.now(),
    updatedAt: updatedAt ?? DateTime.now(),
    reviewUser: reviewUserModel?.toEntity() ?? const ReviewUser(name: ''),
  );
}
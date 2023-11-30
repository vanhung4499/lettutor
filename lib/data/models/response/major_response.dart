import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/domain/entities/common/topic.dart';

part 'major_response.g.dart';

@JsonSerializable()
class MajorResponse {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'key')
  final String? key;

  @JsonKey(name: 'englishName')
  final String? name;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  MajorResponse(this.id, this.key, this.name, this.createdAt, this.updatedAt);
  factory MajorResponse.fromJson(Map<String, dynamic> json) =>
      _$MajorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MajorResponseToJson(this);

  Topic toEntity() => Topic(
    id: id,
    key: key,
    name: name,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

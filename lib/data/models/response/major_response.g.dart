// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'major_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MajorResponse _$MajorResponseFromJson(Map<String, dynamic> json) =>
    MajorResponse(
      json['id'] as int?,
      json['key'] as String?,
      json['englishName'] as String?,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MajorResponseToJson(MajorResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'englishName': instance.name,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

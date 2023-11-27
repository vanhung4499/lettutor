// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ebook_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EbookModel _$EbookModelFromJson(Map<String, dynamic> json) => EbookModel(
      json['id'] as String,
      json['name'] as String?,
      json['description'] as String?,
      json['imageUrl'] as String?,
      json['level'] as String?,
      json['visible'] as bool?,
      json['fileUrl'] as String?,
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      (json['categories'] as List<dynamic>?)
          ?.map((e) => CourseCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EbookModelToJson(EbookModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'level': instance.level,
      'visible': instance.visible,
      'fileUrl': instance.fileUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'categories': instance.categories,
    };

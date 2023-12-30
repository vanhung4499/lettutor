import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/data/models/course/course_category_model.dart';
import 'package:lettutor/domain/entities/common/ebook.dart';
import 'package:lettutor/domain/entities/course/course_category.dart';

part 'ebook_model.g.dart';

@JsonSerializable()
class EbookModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'imageUrl')
  final String? imageUrl;

  @JsonKey(name: 'level')
  final String? level;

  @JsonKey(name: 'visible')
  final bool? visible;

  @JsonKey(name: 'fileUrl')
  final String? fileUrl;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  @JsonKey(name: 'categories')
  final List<CourseCategoryModel>? categories;

  EbookModel(
      this.id,
      this.name,
      this.description,
      this.imageUrl,
      this.level,
      this.visible,
      this.fileUrl,
      this.createdAt,
      this.updatedAt,
      this.categories,
      );

  factory EbookModel.fromJson(Map<String, dynamic> json) =>
      _$EbookModelFromJson(json);

  Map<String, dynamic> toJson() => _$EbookModelToJson(this);

  Ebook toEntity() => Ebook(
    id: id,
    name: name ?? '',
    description: description,
    imageUrl: imageUrl,
    level: level,
    visible: visible,
    fileUrl: fileUrl,
    createdAt: createdAt,
    updatedAt: updatedAt,
    categories: categories?.map((e) => e.toEntity()).toList() ??
        List<CourseCategory>.empty(),
  );
}

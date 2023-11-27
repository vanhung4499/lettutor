import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/domain/entities/course/course_category.dart';

part 'ebook.freezed.dart';

@freezed
class Ebook with _$Ebook {
  const factory Ebook({
    required String id,
    required String name,
    String? description,
    String? imageUrl,
    String? level,
    bool? visible,
    String? fileUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<CourseCategory>? categories,
  }) = _Ebook;
}

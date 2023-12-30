import 'package:freezed_annotation/freezed_annotation.dart';
import 'course_category.dart';
import 'course_topic.dart';

part 'course.freezed.dart';

@freezed
class Course with _$Course {
  const factory Course({
    String? imageUrl,
    String? level,
    String? reason,
    String? purpose,
    String? otherDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
    required String id,
    @Default('') String name,
    @Default('') String description,
    @Default(0) double defaultPrice,
    @Default(0) double coursePrice,
    @Default(true) bool visible,
    @Default(<CourseCategory>[]) List<CourseCategory> categories,
    @Default(<CourseTopic>[]) List<CourseTopic> topics,
  }) = _Course;
}
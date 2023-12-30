import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/course/course.dart';
import 'package:lettutor/domain/entities/course/course_category.dart';

abstract class CourseRepository {
  SingleResult<Pagination<Course>> listCourse(
      {required int page, required int perPage, String? q, String? categoryId});

  SingleResult<Course> getCourseDetail({required String courseId});

  SingleResult<List<CourseCategory>> listCourseCategory();
}

import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/course/course.dart';
import 'package:lettutor/domain/entities/course/course_category.dart';

abstract class CourseRepositories {
  Future<Pagination<Course>> pagFetchCourseData(
      {required int page, required int perPge, String? q, String? categoryId});

  Future<Course> getCourseDetail({required String courseId});

  Future<List<CourseCategory>> getCourseCategory();
}

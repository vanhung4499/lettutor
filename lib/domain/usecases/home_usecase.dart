import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/course/course.dart';
import 'package:lettutor/domain/entities/course/course_category.dart';
import 'package:lettutor/domain/repositories/course_repository.dart';

class HomeUseCase {
  final CourseRepository _courseRepository;

  HomeUseCase(this._courseRepository);

  SingleResult<Pagination<Course>?> pagFetchData(
      {required int page,
        required int size,
        String? q,
        String? categoryId}) =>
      _courseRepository.getListCourse(
          page: page, perPage: size, q: q, categoryId: categoryId);

  SingleResult<List<CourseCategory>> getCourseCategory() =>
      _courseRepository.getCourseCategory();
}

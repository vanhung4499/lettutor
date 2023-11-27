import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/domain/entities/course/course.dart';
import 'package:lettutor/domain/repositories/course_repository.dart';

@injectable
class CourseDetailUseCase {
  final CourseRepository _courseRepository;
  CourseDetailUseCase(this._courseRepository);

  SingleResult<Course> getCourseDetail({required String courseId}) =>
      _courseRepository.getCourseDetail(courseId: courseId);
}

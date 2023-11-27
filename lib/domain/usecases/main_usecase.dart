import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/course/course.dart';
import 'package:lettutor/domain/entities/tutor/tutor_fav.dart';
import 'package:lettutor/domain/repositories/course_repository.dart';
import 'package:lettutor/domain/repositories/tutor_repository.dart';

@injectable
class MainUseCase {
  final TutorRepository _tutorRepository;
  final CourseRepository _courseRepository;

  MainUseCase(this._tutorRepository, this._courseRepository,);

  SingleResult<TutorFav> getTopTutors() =>
      _tutorRepository.getListTutor(page: 1, perPage: 5);

  SingleResult<Pagination<Course>?> getTopCourse() => _courseRepository
      .getListCourse(page: 1, perPage: 5, q: null, categoryId: null);

}
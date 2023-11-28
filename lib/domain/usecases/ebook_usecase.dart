import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/domain/entities/common/ebook.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/course/course_category.dart';
import 'package:lettutor/domain/repositories/common_repository.dart';
import 'package:lettutor/domain/repositories/course_repository.dart';

@injectable
class EbookUseCase {
  final CourseRepository _courseRepository;
  final CommonRepository _commonRepository;

  EbookUseCase(this._courseRepository, this._commonRepository);

  SingleResult<Pagination<Ebook>> listEbook(
      {
        required int page,
        required int size,
        String? q,
        String? categoryId
      }) =>
      _commonRepository.listEbook(
          page: page, size: size, q: q, categoryId: categoryId);

  SingleResult<List<CourseCategory>> listCourseCategory() =>
      _courseRepository.listCourseCategory();
}
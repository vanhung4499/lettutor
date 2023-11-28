import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/request/search_tutor_request.dart';
import 'package:lettutor/domain/entities/common/topic.dart';
import 'package:lettutor/domain/entities/tutor/tutor_fav.dart';
import 'package:lettutor/domain/repositories/common_repository.dart';
import 'package:lettutor/domain/repositories/tutor_repository.dart';

@injectable
class SearchTutorUseCase {
  final CommonRepository _commonRepository;
  final TutorRepository _tutorRepository;
  SearchTutorUseCase(this._commonRepository, this._tutorRepository);

  SingleResult<List<Topic>> listTopic() => _commonRepository.listTopic();

  SingleResult<TutorFav?> searchTutor(
      {required SearchTutorRequest request}) =>
      _tutorRepository.searchTutor(request: request);
}
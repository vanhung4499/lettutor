import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/tutor/tutor.dart';

part 'tutor_fav.freezed.dart';

@freezed
class TutorFav with _$TutorFav {
  const factory TutorFav({
    @Default(Pagination<Tutor>(
        rows: <Tutor>[], count: 0, perPage: 10, currentPage: 0))
    Pagination<Tutor> tutors,
    @Default(<String>[]) List<String> fav,
  }) = _TutorFav;
}

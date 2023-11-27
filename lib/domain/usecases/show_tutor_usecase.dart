import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/domain/entities/schedule/booking_info.dart';
import 'package:lettutor/domain/entities/tutor/tutor_fav.dart';
import 'package:lettutor/domain/repositories/schedule_repository.dart';
import 'package:lettutor/domain/repositories/tutor_repository.dart';
import 'package:lettutor/domain/repositories/user_repository.dart';

class ShowTutorUseCase {
  final TutorRepository _tutorRepository;
  final UserRepository _userRepository;
  final ScheduleRepository _scheduleRepository;
  ShowTutorUseCase(
      this._tutorRepository,
      this._userRepository,
      this._scheduleRepository,
      );

  SingleResult<TutorFav?> pagFetchData(
      {required int page, required int size}) =>
      _tutorRepository.getListTutor(page: page, perPage: size);

  SingleResult<bool> addTutorToFavorite({required String userId}) =>
      _tutorRepository.addTutorToFavorite(userId: userId);

  SingleResult<int> getTotalTime() => _userRepository.getTotalTime();

  SingleResult<BookingInfo?> getUpComingClass({required DateTime dateTime}) =>
      _scheduleRepository.getUpComingBookingInfo(dateTime: dateTime);
}
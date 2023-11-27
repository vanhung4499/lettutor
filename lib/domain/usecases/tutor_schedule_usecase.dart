import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/domain/entities/schedule/schedule.dart';
import 'package:lettutor/domain/repositories/tutor_repository.dart';
import 'package:lettutor/domain/repositories/user_repository.dart';

class TutorScheduleUseCase {
  final TutorRepository _tutorRepository;
  final UserRepository _userRepository;
  TutorScheduleUseCase(this._tutorRepository, this._userRepository);

  SingleResult<List<Schedule>> getTutorSchedule(
      {required String tutorId,
        required DateTime startTime,
        required DateTime endTime}) =>
      _tutorRepository.getTutorSchedule(
          tutorId: tutorId, startTime: startTime, endTime: endTime);

  SingleResult<bool> bookingTutorClass({
    required List<String> scheduleDetailIds,
    required String note,
  }) =>
      _userRepository.bookingTutor(
          scheduleDetailIds: scheduleDetailIds, note: note);
}

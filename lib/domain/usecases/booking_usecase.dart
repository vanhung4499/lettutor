import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/schedule/booking_info.dart';
import 'package:lettutor/domain/repositories/schedule_repository.dart';
import 'package:lettutor/domain/repositories/user_repository.dart';

class BookingUseCase {
  final ScheduleRepository _scheduleRepository;
  final UserRepository _userRepository;
  BookingUseCase(this._scheduleRepository, this._userRepository);

  SingleResult<Pagination<BookingInfo>> getBookingInfo({
    required int page,
    required int perPage,
    required DateTime dateTimeLte,
    required bool isHistoryGet,
    String orderBy = 'meeting',
    String sortBy = 'desc',
  }) =>
      _scheduleRepository.getBookingInfo(
          page: page,
          perPage: perPage,
          dateTimeLte: dateTimeLte,
          isHistoryGet: isHistoryGet);
  SingleResult<bool> cancelBooTutor(
      {required List<String> scheduleDetailIds}) =>
      _userRepository.cancelBookingTutor(scheduleDetailIds: scheduleDetailIds);

  SingleResult<bool> updateStudentRequest(
      {required String booId, required String content}) =>
      _userRepository.updateStudentRequest(booId: booId, content: content);
}

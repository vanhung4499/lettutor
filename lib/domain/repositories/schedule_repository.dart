import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/schedule/booking_info.dart';

abstract class ScheduleRepositories {
  Future<Pagination<BookingInfo>> getBookingInfo({
    required int page,
    required int perPage,
    required DateTime dateTimeLte,
    required bool isHistoryGet,
    String orderBy = 'meeting',
    String sortBy = 'desc',
  });

  Future<BookingInfo?> getUpComingBookingInfo({required DateTime dateTime});
}

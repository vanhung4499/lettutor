import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/schedule/booking_info.dart';

abstract class ScheduleRepository {
  SingleResult<Pagination<BookingInfo>> getBookingInfo({
    required int page,
    required int perPage,
    required DateTime dateTimeLte,
    required bool isHistoryGet,
    String orderBy = 'meeting',
    String sortBy = 'desc',
  });

  SingleResult<BookingInfo?> getUpComingClass({required DateTime dateTime});
}

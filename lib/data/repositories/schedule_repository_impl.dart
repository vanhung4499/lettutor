import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/core/data/network/app_exception.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/providers/network/apis/schedule_api.dart';
import 'package:lettutor/data/providers/network/base_api.dart';
import 'package:lettutor/data/providers/network/data_state.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/schedule/booking_info.dart';
import 'package:lettutor/domain/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl extends BaseApi implements ScheduleRepository {
  final ScheduleApi _scheduleApi = Get.find();

  @override
  SingleResult<Pagination<BookingInfo>> getBookingInfo({
    required int page,
    required int perPage,
    required DateTime dateTimeLte,
    required bool isHistoryGet,
    String orderBy = 'meeting',
    String sortBy = 'desc',
  }) =>
      SingleResult.fromCallable(() async {
        final queries = <String, dynamic>{
          'page': page,
          'perPage': perPage,
          'orderBy': orderBy,
          'sortBy': sortBy,
        };
        if (isHistoryGet) {
          queries.addAll(
            {'dateTimeLte': dateTimeLte.millisecondsSinceEpoch},
          );
        } else {
          queries.addAll(
            {'dateTimeGte': dateTimeLte.millisecondsSinceEpoch},
          );
        }
        final response = await getStateOf(
            request: () async => await _scheduleApi.getBooHistory(queries));
        if (response is DataFailed) {
          return Either.left(
            AppException(message: response.dioError?.message ?? 'Error'),
          );
        }
        final responseData = response.data;
        if (responseData == null) {
          return Either.left(AppException(message: "Data null"));
        }
        return Either.right(
          Pagination<BookingInfo>(
            count: responseData.count,
            perPage: perPage,
            currentPage: page,
            rows: responseData.boos.map((e) => e.toEntity()).toList(),
          ),
        );
      });

  @override
  SingleResult<BookingInfo?> getUpComingBookingInfo({required DateTime dateTime}) =>
      SingleResult.fromCallable(
            () async {
          final millisecondsSinceEpoch = dateTime.millisecondsSinceEpoch;
          final response = await getStateOf(
            request: () async =>
            await _scheduleApi.getUpComing(millisecondsSinceEpoch),
          );
          if (response is DataFailed) {
            return Either.left(
              AppException(message: response.dioError?.message ?? 'Error'),
            );
          }
          final responseData = response.data;
          if (responseData == null) {
            return Either.right(null);
          }
          final listData = responseData.data.where((element) {
            final startPeriodTimestamp =
                element.scheduleDetailInfo?.startPeriodTimestamp;
            if (startPeriodTimestamp != null) {
              return startPeriodTimestamp > millisecondsSinceEpoch;
            }
            return false;
          }).toList();

          if (listData.isEmpty) {
            return Either.right(null);
          }
          listData.sort((a, b) {
            return a.scheduleDetailInfo!.startPeriodTimestamp
                .compareTo(b.scheduleDetailInfo!.startPeriodTimestamp);
          });
          return Either.right(listData.first.toEntity());
        },
      );
}

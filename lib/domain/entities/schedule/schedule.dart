import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/domain/entities/schedule/schedule_detail.dart';

part 'schedule.freezed.dart';

@freezed
class Schedule with _$Schedule {
  const factory Schedule({
    required String id,
    required String tutorId,
    required String startTime,
    required String endTime,
    required DateTime startTimestamp,
    required DateTime endTimestamp,
    required DateTime createdAt,
    required bool isBooked,
    @Default(<ScheduleDetail>[]) List<ScheduleDetail> scheduleDetails,
  }) = _Schedule;
}

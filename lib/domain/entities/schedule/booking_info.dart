import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/domain/entities/schedule/schedule_detail.dart';

part 'booking_info.freezed.dart';

@freezed
class BookingInfo with _$BookingInfo {
  const factory BookingInfo({
    required String id,
    required String? userId,
    required String? scheduleId,
    required String? cancelReasonId,
    required String? lessonPlanId,
    required String? calendarId,
    required String? cancelNote,
    required bool? isDeleted,
    required bool? isTrial,
    required int? convertedLesson,
    required String? tutorMeetingLink,
    required String? studentMeetingLink,
    required String? googleMeetLink,
    required String? studentRequest,
    required String? tutorReview,
    required String? scoreByTutor,
    required String? recordUrl,
    required DateTime? createdAt,
    required DateTime? updatedAt,
    required DateTime? createdAtTimeStamp,
    required DateTime? updatedAtTimeStamp,
    required ScheduleDetail? scheduleDetailInfo,
  }) = _BookingInfo;
}

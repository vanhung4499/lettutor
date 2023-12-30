import 'package:lettutor/data/models/schedule/schedule_model.dart';

class ListScheduleResponse {
  final String status;
  final List<ScheduleModel> schedules;
  ListScheduleResponse(this.status, this.schedules);

  factory ListScheduleResponse.fromJson(Map<String, dynamic> data) {
    final cData = data['scheduleOfTutor'];
    if (cData == null) return ListScheduleResponse('Error', List.empty());
    return ListScheduleResponse(
      data['message']?.toString() ?? 'Error',
      ((cData) as List<dynamic>).map((e) => ScheduleModel.fromJson(e)).toList(),
    );
  }
}

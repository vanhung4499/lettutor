import 'package:lettutor/data/models/schedule/booking_info_model.dart';

class UpcomingResponse {
  final String message;
  final List<BookingInfoModel> data;

  UpcomingResponse(this.message, this.data);

  factory UpcomingResponse.fromJson(Map<String, dynamic> data) {
    return UpcomingResponse(
      data['message']?.toString() ?? 'Error',
      data['data'] != null
          ? ((data['data']) as List<dynamic>)
          .map((e) => BookingInfoModel.fromJson(e))
          .toList()
          : List.empty(),
    );
  }
}

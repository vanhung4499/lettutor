
import 'package:lettutor/data/models/schedule/booking_info_model.dart';

class BookingResponse {
  final String status;
  final int count;
  final List<BookingInfoModel> boos;
  BookingResponse(this.status, this.count, this.boos);

  factory BookingResponse.fromJson(Map<String, dynamic> data) {
    final cData = data['data'];
    if (cData == null) return BookingResponse('Error', 0, List.empty());
    return BookingResponse(
      data['message']?.toString() ?? 'Error',
      (cData['count'] as int?) ?? 0,
      cData['rows'] != null
          ? ((cData['rows']) as List<dynamic>)
          .map((e) => BookingInfoModel.fromJson(e))
          .toList()
          : List.empty(),
    );
  }
}

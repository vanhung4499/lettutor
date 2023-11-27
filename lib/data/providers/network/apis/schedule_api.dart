import 'package:dio/dio.dart';
import 'package:lettutor/data/models/response/booking_response.dart';
import 'package:lettutor/data/models/response/upcoming_response.dart';
import 'package:retrofit/retrofit.dart';

part 'schedule_api.g.dart';

@RestApi()
abstract class ScheduleApi {
  static const String getUpComingApi = "/booking/next";

  factory ScheduleApi(Dio dio) = _ScheduleApi;

  @GET("/booking/list/student")
  Future<HttpResponse<BookingResponse?>> getBooHistory(
      @Queries() Map<String, dynamic> queries,
      );

  @GET("/booking/next?dateTime={time}")
  Future<HttpResponse<UpcomingResponse?>> getUpComing(@Path('time') int time);
}
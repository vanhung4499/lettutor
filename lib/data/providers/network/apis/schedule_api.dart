import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/response/booking_response.dart';
import 'package:lettutor/data/models/response/upcoming_response.dart';
import 'package:retrofit/retrofit.dart';

part 'schedule_api.g.dart';

@injectable
@RestApi()
abstract class ScheduleApi {

  @factoryMethod
  factory ScheduleApi(Dio dio) = _ScheduleApi;

  @GET("/booking/list/student")
  Future<HttpResponse<BookingResponse?>> getBookingHistory(
      @Queries() Map<String, dynamic> queries,
      );

  @GET("/booking/next?dateTime={time}")
  Future<HttpResponse<UpcomingResponse?>> getUpComingClass(@Path('time') int time);
}
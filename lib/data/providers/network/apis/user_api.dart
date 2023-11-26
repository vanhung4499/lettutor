import 'package:dio/dio.dart';
import 'package:lettutor/data/models/response/total_time_response.dart';
import 'package:lettutor/data/models/user/user_info.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {

  factory UserApi(Dio dio) = _UserApi;

  @POST("/report")
  Future<void> reportTutor(
      {@Body() required Map<String, dynamic> body});

  @POST("/booking")
  Future<void> bookingTutor(
      {@Body() required Map<String, dynamic> body});

  @DELETE("/booking")
  Future<void> cancelTutor(
      {@Body() required Map<String, dynamic> body});

  @POST("/booking/student-request/{booId}")
  Future<void> updateStudentRequest(@Path('booId') String booId,
      {@Body() required Map<String, dynamic> body});

  @GET("/call/total")
  Future<TotalTimeResponse?> getTotalTime();

  @GET("/user/info")
  Future<UserInfo?> getUserInfo();

  @PUT("/user/info")
  Future<UserInfo?> updateUserInfo(
      {@Body() required Map<String, dynamic> body});

  @POST("/user/feedbackTutor")
  Future<void> reviewTutor(
      {@Body() required Map<String, dynamic> body});

  @POST("/tutor/register")
  Future<void> becomeTutor({
    @Body() required Map<String, dynamic> body,
    @Header("Content-Type") required String contentType,
  });
}

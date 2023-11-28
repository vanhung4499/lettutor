import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/response/total_time_response.dart';
import 'package:lettutor/data/models/user/user_info.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api.g.dart';

@injectable
@RestApi()
abstract class UserApi {
  @factoryMethod
  factory UserApi(Dio dio) = _UserApi;

  @POST("/report")
  Future<HttpResponse> reportTutor(
      {@Body() required Map<String, dynamic> body});

  @POST("/booking")
  Future<HttpResponse> bookingTutor(
      {@Body() required Map<String, dynamic> body});

  @DELETE("/booking")
  Future<HttpResponse> cancelTutor(
      {@Body() required Map<String, dynamic> body});

  @POST("/booking/student-request/{bookingId}")
  Future<HttpResponse> updateStudentRequest(@Path('bookingId') String bookingId,
      {@Body() required Map<String, dynamic> body});

  @GET("/call/total")
  Future<HttpResponse<TotalTimeResponse?>> getTotalTime();

  @GET("/user/info")
  Future<HttpResponse<UserInfo?>> getUserInfo();

  @PUT("/user/info")
  Future<HttpResponse<UserInfo?>> updateUserInfo(
      {@Body() required Map<String, dynamic> body});
  
  @POST('/user/uploadAvatar')
  Future<HttpResponse<UserInfo?>> uploadAvatar(
      {@Body() required Map<String, dynamic> body});

  @POST("/user/feedbackTutor")
  Future<HttpResponse> reviewTutor(
      {@Body() required Map<String, dynamic> body});

  @POST("/tutor/register")
  Future<HttpResponse> becomeTutor({
    @Body() required Map<String, dynamic> body,
    @Header("Content-Type") required String contentType,
  });
}

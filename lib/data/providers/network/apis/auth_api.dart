import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/data/models/response/auth_response.dart';
import 'package:lettutor/data/models/response/login_response.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@injectable
@RestApi()
abstract class AuthApi {

  @factoryMethod
  factory AuthApi(Dio dio) = _AuthApi;

  @POST("/auth/login")
  Future<HttpResponse<LoginResponse?>> login(
      {@Body() required Map<String, dynamic> body});

  @POST("/auth/register")
  Future<HttpResponse<LoginResponse?>> register(
      {@Body() required Map<String, dynamic> body});

  @POST("/auth/logout")
  Future<HttpResponse<AuthenticateResponse>> logout();

  @POST("/auth/refresh-token")
  Future<HttpResponse<AuthenticateResponse>> refreshToken(
      {@Body() required Map<String, dynamic> body});

  @POST("/user/forgotPassword")
  Future<HttpResponse> resetPassword({
    @Body() required Map<String, dynamic> body,
  });

  @POST("/auth/google")
  Future<HttpResponse> googleSignIn({
    @Body() required Map<String, dynamic> body,
  });

  @GET("/auth/verifyAccount?token={value}")
  Future<HttpResponse> verifyEmailAccount(@Path('value') String token);
}

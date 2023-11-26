import 'package:dio/dio.dart';
import 'package:lettutor/data/models/response/auth_response.dart';
import 'package:lettutor/data/models/response/login_response.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {

  factory AuthApi(Dio dio) = _AuthApi;

  @POST("/auth/login")
  Future<LoginResponse?> login(
      {@Body() required Map<String, dynamic> body});

  @POST("/auth/register")
  Future<LoginResponse?> register(
      {@Body() required Map<String, dynamic> body});

  @POST("/auth/logout")
  Future<AuthenticateResponse> logout();

  @POST("/auth/refresh-token")
  Future<AuthenticateResponse> refreshToken(
      {@Body() required Map<String, dynamic> body});

  @POST("/user/forgotPassword")
  Future<void> resetPassword({
    @Body() required Map<String, dynamic> body,
  });

  @POST("/auth/google")
  Future<void> googleSignIn({
    @Body() required Map<String, dynamic> body,
  });

  @GET("/auth/verifyAccount?token={value}")
  Future<void> verifyEmailAccount(@Path('value') String token);
}

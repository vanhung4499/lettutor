import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response.g.dart';
part 'auth_response.freezed.dart';

@freezed
class AuthenticateResponse with _$AuthenticateResponse {
  const factory AuthenticateResponse(
      {@Default("") String message,
        @Default(false) bool isSuccess,
        @Default("") String accessToken,
        @Default("") String refreshToken,
        @Default("") String role,
        @Default(0) int expiredTime}) = _AuthenticateResponse;

  factory AuthenticateResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticateResponseFromJson(json);
}

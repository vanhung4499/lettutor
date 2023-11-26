import 'package:lettutor/data/models/user/user_token_model.dart';

class LoginResponse {
  final UserTokenModel tokens;
  LoginResponse(this.tokens);

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
      UserTokenModel.fromJson(json['tokens'] as Map<String, dynamic>));
}

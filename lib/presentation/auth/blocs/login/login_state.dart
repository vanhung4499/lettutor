import 'package:flutter/material.dart';

class Credential {
  final String email;
  final String password;

  const Credential({required this.email, required this.password});
}

@immutable
abstract class LoginState {}

class LoginSuccessMessage implements LoginState {
  const LoginSuccessMessage();
}

class LoginErrorMessage implements LoginState {
  final Object? error;
  final String? message;
  const LoginErrorMessage({this.error, this.message});

  @override
  String toString() =>
      "LoginErrorMessage => {message=${message ?? ''}, error=${error ?? ''}}";
}

class InvalidFormatMessage implements LoginState {
  const InvalidFormatMessage();
}

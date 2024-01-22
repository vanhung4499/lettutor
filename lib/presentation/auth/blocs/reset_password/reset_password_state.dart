import 'package:flutter/material.dart';

@immutable
abstract class ResetPasswordState {}

class ResetPasswordSuccess implements ResetPasswordState {
  const ResetPasswordSuccess();
}

class ResetPasswordFailed implements ResetPasswordState {
  final String? message;
  ResetPasswordFailed({this.message});

  @override
  String toString() => "🐛[Reset password failed] $message";
}

import 'package:flutter/material.dart';
import 'package:lettutor/domain/entities/user/user.dart';

@immutable
abstract class UserProfileState {}

class ChangeAvatarSuccess implements UserProfileState {
  const ChangeAvatarSuccess();
}

class GetUserInfoSuccess implements UserProfileState {
  final User user;
  const GetUserInfoSuccess(this.user);
}

class GetUserInfoFailed implements UserProfileState {
  final Object? error;
  final String? message;
  const GetUserInfoFailed({this.error, this.message});

  @override
  String toString() =>
      "GetUserProfileFailed => {message=${message ?? ''}, error=${error ?? ''}}";
}

class ListTopicSuccess implements UserProfileState {
  const ListTopicSuccess();
}

class ListTopicFailed implements UserProfileState {
  final String? message;
  final Object? error;

  const ListTopicFailed({this.error, this.message});

  @override
  String toString() =>
      "[Fetch topic errors] => message ${message ?? ''}, error ${error ?? ''} ";
}

class UpdateUserProfileSuccess implements UserProfileState {
  const UpdateUserProfileSuccess();
}

class UpdateUserProfileFailed implements UserProfileState {
  final String? message;
  final Object? error;

  const UpdateUserProfileFailed({this.error, this.message});

  @override
  String toString() =>
      "[UpdateProfile errors] => message ${message ?? ''}, error ${error ?? ''} ";
}

class SelectTopicSuccess implements UserProfileState {
  const SelectTopicSuccess();
}

class PopScreenSuccess implements UserProfileState {
  final User user;
  const PopScreenSuccess(this.user);
}

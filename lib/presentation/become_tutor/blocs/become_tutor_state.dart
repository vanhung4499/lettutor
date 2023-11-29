import 'package:flutter/foundation.dart';

@immutable
abstract class BecomeTutorState {}

class SelectTopicSuccess implements BecomeTutorState {
  const SelectTopicSuccess();
}

class ChangeAvatarSuccess implements BecomeTutorState {
  const ChangeAvatarSuccess();
}

class ListTopicSuccess implements BecomeTutorState {
  const ListTopicSuccess();
}

class ListTopicFailed implements BecomeTutorState {
  final String? message;
  final Object? error;

  const ListTopicFailed({this.error, this.message});

  @override
  String toString() =>
      "[List topic error] => message ${message ?? ''}, error ${error ?? ''} ";
}

class RegisterTutorSuccess implements BecomeTutorState {
  const RegisterTutorSuccess();
}

class RegisterTutorFailed implements BecomeTutorState {
  final String? message;
  final Object? error;

  const RegisterTutorFailed({this.error, this.message});

  @override
  String toString() =>
      "[Register tutor error] => message ${message ?? ''}, error ${error ?? ''} ";
}

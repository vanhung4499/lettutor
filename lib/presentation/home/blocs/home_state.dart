import 'package:flutter/material.dart';

@immutable
abstract class HomeState {}

class ListTopTutorSuccess implements HomeState {
  const ListTopTutorSuccess();
}

class ListTopTutorFailed implements HomeState {
  final String? message;
  final Object? error;

  const ListTopTutorFailed({this.message, this.error});
  @override
  String toString() => "message $message error $error";
}

class ListTopCourseSuccess implements HomeState {
  const ListTopCourseSuccess();
}

class ListTopCourseFailed implements HomeState {
  final String? message;
  final Object? error;

  const ListTopCourseFailed({this.message, this.error});
  @override
  String toString() => "message $message error $error";
}

class ListTopEbookSuccess implements HomeState {
  const ListTopEbookSuccess();
}

class ListTopEbookFailed implements HomeState {
  final String? message;
  final Object? error;

  const ListTopEbookFailed({this.message, this.error});
  @override
  String toString() => "message $message error $error";
}

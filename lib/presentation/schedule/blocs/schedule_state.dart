import 'package:flutter/material.dart';

@immutable
abstract class ScheduleState {}

class GetBookingInfoSuccess implements ScheduleState {
  const GetBookingInfoSuccess();
}

class GetBookingInfoFailed implements ScheduleState {
  final String? message;
  final Object? error;

  const GetBookingInfoFailed({this.error, this.message});

  @override
  String toString() =>
      "[Get boo history errors] => message ${message ?? ''}, error ${error ?? ''} ";
}

class CancelBookingTutorSuccess implements ScheduleState {
  const CancelBookingTutorSuccess();
}

class CancelBookingTutorFailed implements ScheduleState {
  final String? message;
  final Object? error;

  const CancelBookingTutorFailed({this.error, this.message});

  @override
  String toString() =>
      "[Cancel boo errors] => message ${message ?? ''}, error ${error ?? ''} ";
}

class UpdateStudentRequestSuccess implements ScheduleState {
  const UpdateStudentRequestSuccess();
}

class UpdateStudentRequestFailed implements ScheduleState {
  final String? message;
  final Object? error;

  const UpdateStudentRequestFailed({this.error, this.message});

  @override
  String toString() =>
      "[Update student request errors] => message ${message ?? ''}, error ${error ?? ''} ";
}

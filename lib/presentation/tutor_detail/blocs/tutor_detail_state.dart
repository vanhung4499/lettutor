import 'package:flutter/material.dart';

@immutable
abstract class TutorDetailState {}

class GetTutorSuccess implements TutorDetailState {
  const GetTutorSuccess();
}

class GetTutorFailed implements TutorDetailState {
  final Object? error;
  final String? message;

  GetTutorFailed({this.error, this.message});

  @override
  String toString() =>
      "[Get tutors by id errors] => message ${message ?? ''}, error ${error ?? ''} ";
}

class FavTutorSuccess implements TutorDetailState {
  const FavTutorSuccess();
}

class FavTutorFailed implements TutorDetailState {
  final Object? error;
  final String? message;

  FavTutorFailed({this.error, this.message});

  @override
  String toString() =>
      "[Fav tutor errors] => message ${message ?? ''}, error ${error ?? ''} ";
}

class ListReviewSuccess implements TutorDetailState {
  const ListReviewSuccess();
}

class ListReviewFailed implements TutorDetailState {
  final Object? error;
  final String? message;

  ListReviewFailed({this.error, this.message});

  @override
  String toString() =>
      "[List review] => message ${message ?? ''}, error ${error ?? ''} ";
}

class OpenReportTutorSuccess implements TutorDetailState {
  final String userId;
  OpenReportTutorSuccess({required this.userId});
}

class OpenTutorScheduleSuccess implements TutorDetailState {
  final String userId;
  OpenTutorScheduleSuccess({required this.userId});
}

class InvalidTutorDetail implements TutorDetailState {
  const InvalidTutorDetail();
}

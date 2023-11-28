import 'package:flutter/material.dart';

@immutable
abstract class TutorFeedbackState {}

class FeedbackSuccess implements TutorFeedbackState {
  const FeedbackSuccess();
}

class FeedbackFailed implements TutorFeedbackState {
  final Object? error;
  final String? message;

  FeedbackFailed({this.error, this.message});

  @override
  String toString() =>
      "[Feedback] => message ${message ?? ''}, error ${error ?? ''} ";
}

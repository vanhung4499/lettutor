import 'package:flutter/cupertino.dart';

@immutable
abstract class TutorSearchResultState {}

class TutorSearchSuccess implements TutorSearchResultState {
  final String message;
  const TutorSearchSuccess({this.message = "Search success"});
}

class TutorSearchFailed implements TutorSearchResultState {
  final Object? error;
  final String? message;
  const TutorSearchFailed({this.error, this.message});

  @override
  String toString() =>
      "SearchFailed => {message=${message ?? ''}, error=${error ?? ''}}";
}

class STRInvalid implements TutorSearchResultState {
  const STRInvalid();
}

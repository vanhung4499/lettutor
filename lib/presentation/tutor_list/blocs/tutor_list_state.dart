import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/domain/entities/schedule/booking_info.dart';

@immutable
abstract class TutorListState {}

class ListTutorSuccess implements TutorListState {
  final String message;
  const ListTutorSuccess({this.message = "List tutor success"});
}

class ListTutorFailed implements TutorListState {
  final Object? error;
  final String? message;
  const ListTutorFailed({this.error, this.message});

  @override
  String toString() =>
      "ListTutorFailed => {message=${message ?? ''}, error=${error ?? ''}}";
}


class ListTopicSuccess implements TutorListState {
  const ListTopicSuccess();
}

class ListTopicFailed implements TutorListState {
  final String? message;
  final Object? error;

  const ListTopicFailed({this.error, this.message});

  @override
  String toString() =>
      "[List topic error] => message ${message ?? ''}, error ${error ?? ''} ";
}

class AddTutorToFavSuccess implements TutorListState {
  final String message;
  const AddTutorToFavSuccess({this.message = "Fetch data success"});
}

class AddTutorToFavFailed implements TutorListState {
  final Object? error;
  final String? message;
  const AddTutorToFavFailed({this.error, this.message});

  @override
  String toString() =>
      "AddTutorFavFailed => {message=${message ?? ''}, error=${error ?? ''}}";
}

class GetTotalTimeFailed implements TutorListState {
  final Object? error;
  final String? message;
  const GetTotalTimeFailed({this.error, this.message});

  @override
  String toString() =>
      "GetTotalTimeFailed => {message=${message ?? ''}, error=${error ?? ''}}";
}

class GetUpComingClassFailed implements TutorListState {
  final Object? error;
  final String? message;
  const GetUpComingClassFailed({this.error, this.message});

  @override
  String toString() =>
      "GetUpComingClassFailed => {message=${message ?? ''}, error=${error ?? ''}}";
}

class ChangeFavoriteModeSuccess implements TutorListState {
  const ChangeFavoriteModeSuccess();
}

class GetTotalTimeSuccess implements TutorListState {
  const GetTotalTimeSuccess();
}

class GetUpComingClassSuccess implements TutorListState {
  const GetUpComingClassSuccess();
}

class OpenMeetingPrepareViewSuccess implements TutorListState {
  final BookingInfo args;
  const OpenMeetingPrepareViewSuccess(this.args);
}

class OpenBeforeMeetingViewFailed implements TutorListState {
  const OpenBeforeMeetingViewFailed();
}

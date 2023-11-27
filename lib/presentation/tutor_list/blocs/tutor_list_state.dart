import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/domain/entities/schedule/booking_info.dart';

@immutable
abstract class TutorListState {}

class FetchTutorDataSuccess implements TutorListState {
  final String message;
  const FetchTutorDataSuccess({this.message = "Fetch data success"});
}

class FetchTutorDataFailed implements TutorListState {
  final Object? error;
  final String? message;
  const FetchTutorDataFailed({this.error, this.message});

  @override
  String toString() =>
      "FetchDataFailed => {message=${message ?? ''}, error=${error ?? ''}}";
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

class OpenBeforeMeetingViewSuccess implements TutorListState {
  final BookingInfo args;
  const OpenBeforeMeetingViewSuccess(this.args);
}

class OpenBeforeMeetingViewFailed implements TutorListState {
  const OpenBeforeMeetingViewFailed();
}

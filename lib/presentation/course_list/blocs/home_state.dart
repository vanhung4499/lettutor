import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
abstract class CourseListState {}

class GetCourseCategorySuccess implements CourseListState {
  const GetCourseCategorySuccess();
}

class FetchDataCourseSuccess implements CourseListState {
  final String message;
  const FetchDataCourseSuccess({this.message = "Fetch data success"});
}

class FetchDataCourseFailed implements CourseListState {
  final Object? error;
  final String? message;
  const FetchDataCourseFailed({this.error, this.message});

  @override
  String toString() =>
      "FetchDataFailed => {message=${message ?? ''}, error=${error ?? ''}}";
}

class GetCourseCategoryFailed implements CourseListState {
  final Object? error;
  final String? message;
  const GetCourseCategoryFailed({this.error, this.message});

  @override
  String toString() =>
      "Get course category failed => {message=${message ?? ''}, error=${error ?? ''}}";
}

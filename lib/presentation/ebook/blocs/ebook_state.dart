import 'package:flutter/material.dart';

@immutable
abstract class EbookState {}

class GetEbookSuccess implements EbookState {
  final String message;
  const GetEbookSuccess({this.message = "Fetch data success"});
}

class GetEbookFailed implements EbookState {
  final Object? error;
  final String? message;
  const GetEbookFailed({this.error, this.message});

  @override
  String toString() =>
      "FetchDataFailed => {message=${message ?? ''}, error=${error ?? ''}}";
}

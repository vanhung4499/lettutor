import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lettutor/data/models/request/search_tutor_request.dart';

@immutable
abstract class TutorSearchState {}

class ListTopicSuccess implements TutorSearchState {
  const ListTopicSuccess();
}

class ListTopicFailed implements TutorSearchState {
  final String? message;
  final Object? error;

  const ListTopicFailed({this.error, this.message});

  @override
  String toString() =>
      "[Fetch topic errors] => message ${message ?? ''}, error ${error ?? ''} ";
}

class InvalidSearch implements TutorSearchState {
  const InvalidSearch();
}

class SelectTopicSuccess implements TutorSearchState {
  const SelectTopicSuccess();
}

class SelectNationalitySuccess implements TutorSearchState {
  const SelectNationalitySuccess();
}

class OpenSearchTutorResultPageSuccess implements TutorSearchState {
  final SearchTutorRequest searchTutorRequest;
  OpenSearchTutorResultPageSuccess({required this.searchTutorRequest});
}

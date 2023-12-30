import 'package:lettutor/data/models/tutor/tutor_model.dart';

class SearchTutorResponse {
  final int count;
  final List<TutorModel> tutors;

  SearchTutorResponse(this.count, this.tutors);

  factory SearchTutorResponse.fromJson(Map<String, dynamic> data) {
    return SearchTutorResponse(
      (data['count'] as int?) ?? 0,
      data['rows'] != null
          ? ((data['rows']) as List<dynamic>)
          .map((e) => TutorModel.fromJson(e))
          .toList()
          : List.empty(),
    );
  }
}

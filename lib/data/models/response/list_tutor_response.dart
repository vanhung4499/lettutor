import 'package:lettutor/data/models/tutor/tutor_model.dart';

class ListTutorResponse {
  final int count;
  final List<TutorModel> tutors;
  final List<String> favTutors;
  ListTutorResponse(this.count, this.tutors, this.favTutors);

  factory ListTutorResponse.fromJson(Map<String, dynamic> data) {
    final cData = data['tutors'];
    if (cData == null) return ListTutorResponse(0, List.empty(), List.empty());
    return ListTutorResponse(
      (cData['count'] as int?) ?? 0,
      cData['rows'] != null
          ? ((cData['rows']) as List<dynamic>)
          .map((e) => TutorModel.fromJson(e))
          .toList()
          : List.empty(),
      data['favoriteTutor'] != null
          ? (data['favoriteTutor'] as List<dynamic>)
          .map((e) => e['secondId']?.toString().trim() ?? '')
          .toList()
          : List.empty(),
    );
  }
}

import 'package:lettutor/data/models/course/course_model.dart';

class ListCourseResponse {
  final String status;
  final int count;
  final List<CourseModel> courses;
  ListCourseResponse(this.status, this.count, this.courses);

  factory ListCourseResponse.fromJson(Map<String, dynamic> data) {
    final cData = data['data'];
    if (cData == null) return ListCourseResponse('Error', 0, List.empty());
    return ListCourseResponse(
      data['message']?.toString() ?? 'Error',
      (cData['count'] as int?) ?? 0,
      cData['rows'] != null
          ? ((cData['rows']) as List<dynamic>)
          .map((e) => CourseModel.fromJson(e))
          .toList()
          : List.empty(),
    );
  }
}
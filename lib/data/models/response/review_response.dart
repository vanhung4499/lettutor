import 'package:lettutor/data/models/tutor/review_model.dart';

class ListReviewResponse {
  final String status;
  final int count;
  final List<ReviewModel> reviews;
  ListReviewResponse(this.status, this.count, this.reviews);

  factory ListReviewResponse.fromJson(Map<String, dynamic> data) {
    final cData = data['data'];
    if (cData == null) return ListReviewResponse('Error', 0, List.empty());
    return ListReviewResponse(
      data['message']?.toString() ?? 'Error',
      (cData['count'] as int?) ?? 0,
      cData['rows'] != null
          ? ((cData['rows']) as List<dynamic>)
          .map((e) => ReviewModel.fromJson(e))
          .toList()
          : List.empty(),
    );
  }
}

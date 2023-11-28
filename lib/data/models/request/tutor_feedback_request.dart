class TutorFeedbackRequest {
  final String booId;
  final String userId;
  final double ratting;
  final String content;

  TutorFeedbackRequest({
    required this.booId,
    required this.userId,
    required this.ratting,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
    "bookingId": booId,
    "userId": userId,
    "rating": ratting,
    "content": content
  };
}

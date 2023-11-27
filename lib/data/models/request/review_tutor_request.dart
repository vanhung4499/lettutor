class ReviewTutorRequest {
  final String booId;
  final String userId;
  final double ratting;
  final String content;

  ReviewTutorRequest({
    required this.booId,
    required this.userId,
    required this.ratting,
    required this.content,
  });

  Map<String, dynamic> get toMap => {
    "bookingId": booId,
    "userId": userId,
    "rating": ratting,
    "content": content
  };
}
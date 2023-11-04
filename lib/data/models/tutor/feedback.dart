import 'package:lettutor/data/models/user/simple_user.dart';

class Feedback {
  String id;
  String bookingId;
  String userId;
  String secondId;
  int rating;
  String content;
  String createdAt;
  String updatedAt;
  SimpleUser user;

  Feedback({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.secondId,
    required this.rating,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });
}

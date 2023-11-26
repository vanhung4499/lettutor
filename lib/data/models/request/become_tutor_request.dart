import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:lettutor/domain/entities/common/topic.dart';

class BecomeTutorRequest {
  final String name;
  final String country;
  final DateTime birthDay;
  final String interest;
  final String education;
  final String experience;
  final String profession;
  final String languages;
  final String bio;
  final String targetStudent;
  final List<Topic> specialties;
  final String avatar;
  final int price;
  BecomeTutorRequest(
      {required this.name,
        required this.country,
        required this.birthDay,
        required this.interest,
        required this.education,
        required this.experience,
        required this.profession,
        required this.languages,
        required this.bio,
        required this.targetStudent,
        required this.specialties,
        required this.avatar,
        required this.price});

  Future<Map<String, dynamic>> toMap() async => {
    "avatar": await MultipartFile.fromFile(
      avatar,
      filename: avatar.split('/').last,
      contentType: MediaType("image", "jpeg"),
    ),
    "name": name,
    "country": country,
    "birthday": DateFormat('yyyy-MM-dd').format(birthDay),
    "interests": interest,
    "education": education,
    "experience": experience,
    "profession": profession,
    "languages": languages,
    "bio": bio,
    "targetStudent": targetStudent,
    "specialties": specialties.map((e) => e.key).join(","),
    "price": price,
  };
}
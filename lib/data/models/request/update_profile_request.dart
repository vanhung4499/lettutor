import 'package:intl/intl.dart';

class UpdateProfileRequest {
  final String name;
  final String country;
  final DateTime birthDay;
  final String level;
  final String studySchedule;
  final List<String>? learnTopic;
  final List<String>? testPreparations;

  UpdateProfileRequest({
    required this.name,
    required this.country,
    required this.birthDay,
    required this.level,
    required this.studySchedule,
    this.learnTopic,
    this.testPreparations,
  });

  Map<String, dynamic> get toMap => {
    'name': name,
    'country': country.toUpperCase(),
    'birthday': DateFormat('yyyy-MM-dd').format(birthDay),
    'level': level,
    'learnTopics': learnTopic ?? <String>[],
    'testPreparations': testPreparations ?? <String>[],
    'studySchedule': studySchedule,
  };
}
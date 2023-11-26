import 'package:lettutor/domain/entities/common/topic.dart';

abstract class AppRepositories {
  Future<List<Topic>> getTopics();
}
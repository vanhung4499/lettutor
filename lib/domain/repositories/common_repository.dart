import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/domain/entities/common/topic.dart';

abstract class CommonRepository {
  SingleResult<List<Topic>> getTopics();
}
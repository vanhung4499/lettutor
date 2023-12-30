import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/domain/entities/common/ebook.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/common/topic.dart';

abstract class CommonRepository {
  SingleResult<List<Topic>> listTopic();

  SingleResult<Pagination<Ebook>> listEbook(
      {required int page, required int size, String? q, String? categoryId});
}
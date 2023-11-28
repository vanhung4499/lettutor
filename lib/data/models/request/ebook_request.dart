import 'package:lettutor/domain/entities/common/ebook.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';

class ListEbookRequest {
  final String query;
  final String categoryId;
  final Pagination<Ebook> ebooks;
  ListEbookRequest(this.query, this.categoryId, this.ebooks);
}
import 'package:lettutor/data/models/common/ebook_model.dart';

class EbookResponse {
  final String status;
  final int count;
  final List<EbookModel> ebooks;
  EbookResponse(this.status, this.count, this.ebooks);

  factory EbookResponse.fromJson(Map<String, dynamic> data) {
    final cData = data['data'];
    if (cData == null) return EbookResponse('Error', 0, List.empty());
    return EbookResponse(
      data['message']?.toString() ?? 'Error',
      (cData['count'] as int?) ?? 0,
      cData['rows'] != null
          ? ((cData['rows']) as List<dynamic>)
          .map((e) => EbookModel.fromJson(e))
          .toList()
          : List.empty(),
    );
  }
}

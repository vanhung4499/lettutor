
import 'package:dart_either/dart_either.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/core/network/app_exception.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/providers/network/apis/common_api.dart';
import 'package:lettutor/data/providers/network/base_api.dart';
import 'package:lettutor/data/providers/network/data_state.dart';
import 'package:lettutor/domain/entities/common/ebook.dart';
import 'package:lettutor/domain/entities/common/pagination.dart';
import 'package:lettutor/domain/entities/common/topic.dart';
import 'package:lettutor/domain/repositories/common_repository.dart';

@Injectable(as: CommonRepository)
class CommonRepositoryImpl extends BaseApi implements CommonRepository {
  final CommonApi _commonApi;
  CommonRepositoryImpl(this._commonApi);

  @override
  SingleResult<List<Topic>> getTopics() {
    return SingleResult.fromCallable(() async {
      final response = await getStateOf(
        request: () async => await _commonApi.getTopic(),
      );

      final response1 = await getStateOf(
        request: () async => await _commonApi.getTestPreparation(),
      );

      if ((response is DataFailed) && (response1 is DataFailed)) {
        return Either.left(
          AppException(message: response.dioError?.message ?? 'Error'),
        );
      }
      if ((response.data == null) && (response1.data == null)) {
        return Either.left(
          AppException(message: "Data error"),
        );
      }
      return Either.right(
        [
          ...response.data
              ?.map((e) => e.toEntity().copyWith(isTopics: true))
              .toList() ??
              <Topic>[],
          ...response1.data
              ?.map((e) => e.toEntity().copyWith(isTopics: false))
              .toList() ??
              <Topic>[],
        ],
      );
    });
  }

  @override
  SingleResult<Pagination<Ebook>> getListEbook({
    required int page,
    required int size,
    String? q,
    String? categoryId,
  }) =>
      SingleResult.fromCallable(
            () async {
          await Future.delayed(const Duration(seconds: 2));
          final body = <String, dynamic>{"page": page, "size": size};
          if (q?.isNotEmpty ?? false) {
            body.addAll({"q": q});
          }
          if (categoryId?.isNotEmpty ?? false) {
            body.addAll({"categoryId": categoryId});
          }
          final response =
          await getStateOf(request: () async => _commonApi.getListEbook(body));

          if (response is DataFailed) {
            return Either.left(
              AppException(message: response.dioError?.message ?? 'Error'),
            );
          }
          final responseData = response.data;
          if (responseData == null) {
            return Either.left(AppException(message: 'Data null'));
          }
          return Either.right(
            Pagination<Ebook>(
              rows: responseData.ebooks.map((e) => e.toEntity()).toList(),
              count: responseData.count,
              perPage: size,
              currentPage: page,
            ),
          );
        },
      );
}

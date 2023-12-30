
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
  SingleResult<List<Topic>> listTopic() {
    return SingleResult.fromCallable(() async {
      final topicResponse = await getStateOf(
        request: () async => await _commonApi.listTopic(),
      );

      final testPrepareResponse = await getStateOf(
        request: () async => await _commonApi.listTestPreparation(),
      );

      // final majorResponse = await getStateOf(
      //   request: () async => await _commonApi.listMajor(),
      // );

      if ((topicResponse is DataFailed) && (testPrepareResponse is DataFailed)) {
        return Either.left(
          AppException(message: topicResponse.dioError?.message ?? 'Error'),
        );
      }
      if ((topicResponse.data == null) && (testPrepareResponse.data == null)) {
        return Either.left(
          AppException(message: "Data error"),
        );
      }
      return Either.right(
        [
          ...topicResponse.data
              ?.map((e) => e.toEntity().copyWith(isTopics: true))
              .toList() ??
              <Topic>[],
          ...testPrepareResponse.data
              ?.map((e) => e.toEntity().copyWith(isTopics: false))
              .toList() ??
              <Topic>[],
        ],
      );
    });
  }

  @override
  SingleResult<Pagination<Ebook>> listEbook({
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
          await getStateOf(request: () async => _commonApi.listEbook(body));

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

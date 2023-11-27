
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:lettutor/app/core/data/network/app_exception.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/providers/network/apis/common_api.dart';
import 'package:lettutor/data/providers/network/base_api.dart';
import 'package:lettutor/data/providers/network/data_state.dart';
import 'package:lettutor/domain/entities/common/topic.dart';
import 'package:lettutor/domain/repositories/common_repository.dart';

class CommonRepositoryImpl extends BaseApi implements CommonRepository {
  final CommonApi _appApi = Get.find();

  @override
  SingleResult<List<Topic>> getTopics() {
    return SingleResult.fromCallable(() async {
      final response = await getStateOf(
        request: () async => await _appApi.getTopic(),
      );

      final response1 = await getStateOf(
        request: () async => await _appApi.getTestPreparation(),
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
}

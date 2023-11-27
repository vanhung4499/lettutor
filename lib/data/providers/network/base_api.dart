
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:lettutor/app/core/data/network/app_exception.dart';
import 'package:lettutor/app/utils/validator.dart';
import 'package:lettutor/data/models/common/app_error.dart';
import 'package:lettutor/data/models/response/login_response.dart';
import 'package:lettutor/data/models/user/user_token_model.dart';
import 'package:lettutor/data/providers/local/preferences.dart';
import 'package:lettutor/data/providers/network/data_state.dart';
import 'package:retrofit/dio.dart';

abstract class BaseApi {
  Future<DataState<T>> getStateOf<T>({
    required Future<HttpResponse<T>> Function() request,
  }) async {
    try {
      final httpResponse = await request();

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(data: httpResponse.data);
      } else {
        return DataFailed(
          // ignore: deprecated_member_use
          dioError: DioError(
            requestOptions: httpResponse.response.requestOptions,
            response: httpResponse.response,
          ),
        );
      }
      // ignore: deprecated_member_use
    } on DioError catch (error) {
      return DataFailed(dioError: error);
    }
  }

  SingleResult<UserTokenModel?> authFunction({
    required Future<HttpResponse<LoginResponse?>> functionCall,
  }) {
    return SingleResult.fromCallable(
          () async {
        final response = await getStateOf<LoginResponse?>(
          request: () async => await functionCall,
        );
        if (response is DataFailed) {
          return Either.left(
            AppException(message: response.dioError?.message ?? 'Error'),
          );
        }
        if (response.data == null) {
          return Either.left(AppException(message: 'Data error'));
        }
        final userTokenModel = response.data!.tokens;
        if (Validator.tokenNull(userTokenModel)) {
          return Either.left(AppException(message: 'Data null'));
        }

        ///[Print] log data
        log("[Access] ${userTokenModel.access?.token}");
        log("[Refresh] ${userTokenModel.refresh?.token}");
        log("[Expired time] ${DateFormat().add_yMd().format(userTokenModel.access?.expires ?? DateTime.now())}");

        await CommonAppSettingPref.setExpiredTime(
            (userTokenModel.access?.expires ?? DateTime.now())
                .millisecondsSinceEpoch);
        await CommonAppSettingPref.setAccessToken(
            userTokenModel.access?.token ?? '');
        await CommonAppSettingPref.setRefreshToken(
            userTokenModel.refresh?.token ?? '');

        return Either.right(userTokenModel);
      },
    );
  }
}

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/core/app_core_factory.dart';
import 'package:lettutor/core/config/app_env.dart';

@module
abstract class DataSourceModule {
  @prod
  Dio dioProd() => AppCoreFactory.createDio(
    AppEnv.baseUrl,
  );
}

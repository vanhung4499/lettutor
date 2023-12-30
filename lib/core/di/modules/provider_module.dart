import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/core/app_network_factory.dart';
import 'package:lettutor/core/config/app_env.dart';

@module
abstract class ProviderModule {
  @prod
  Dio dioProd() => AppNetworkFactory.createDio(
    AppEnv.baseUrl,
  );
}

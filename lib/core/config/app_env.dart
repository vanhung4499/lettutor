import 'package:lettutor/core/constants/env_constant.dart';

class AppEnv {
  static String _baseUrl = EnvConstant.baseUrl;
  static String _name = EnvConstant.name;
  static String _environment = EnvConstant.environment;
  static String _mode = EnvConstant.mode;
  static String _googleClientId = EnvConstant.googleClientId;

  void setEnvValue(Map<String, dynamic> env) {
    _name = env['name'] ?? EnvConstant.name;
    _environment = env['environment'] ?? EnvConstant.environment;
    _baseUrl = env['baseUrl'] ?? EnvConstant.baseUrl;
    _mode = env['mode'] ?? EnvConstant.mode;
    _googleClientId = env['googleClientId'] ?? EnvConstant.googleClientId;
  }

  static String get baseUrl => _baseUrl;
  static String get name => _name;
  static String get environment => _environment;
  static String get mode => _mode;
  static String get googleClientId => _googleClientId;

  static bool get isMobileMode => _mode == 'mobile';
}

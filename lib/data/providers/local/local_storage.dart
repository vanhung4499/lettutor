import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lettutor/data/models/tokens.dart';

class LocalStorage {
  final _getStorage = GetStorage();
  final _secureStorage = const FlutterSecureStorage();
  GetStorage get getStorage => _getStorage;
  FlutterSecureStorage get secureStorage => _secureStorage;

  static const String _userAccessToken = 'user_access_token';
  static const String _userRefreshToken = 'user_refresh_token';
  static const String _locale = 'locale';
  static const String _themeMode = 'theme_mode';

  // User token
  Future<String?> get userAccessToken {
    return secureStorage.read(key: _userAccessToken);
  }

  Future<void> saveUserAccessToken(String? userAccessToken) {
    return secureStorage.write(key: _userAccessToken, value: userAccessToken);
  }

  Future<void> removeUserAccessToken() {
    return secureStorage.delete(key: _userAccessToken);
  }

  // User refresh token
  Future<String?> get userRefreshToken {
    return secureStorage.read(key: _userRefreshToken);
  }

  Future<void> saveUserRefreshToken(String? userRefreshToken) async {
    if (userRefreshToken == null) return;

    return secureStorage.write(key: _userRefreshToken, value: userRefreshToken);
  }

  Future<void> removeUserRefreshToken() {
    return secureStorage.delete(key: _userRefreshToken);
  }

  // User token data
  Future<void> saveUserTokenData(Tokens? tokenModel) {
    return Future.wait([
      saveUserAccessToken(tokenModel?.accessToken),
      saveUserRefreshToken(tokenModel?.refreshToken),
    ]);
  }

  Future<void> removeUserTokenData() {
    return Future.wait([
      removeUserAccessToken(),
      removeUserRefreshToken(),
    ]);
  }

  // Locale
  String? get locale {
    return getStorage.read(_locale);
  }

  Future<void> saveLocale(String currentLocale) {
    return getStorage.write(_locale, currentLocale);
  }

  Future<void> removeLocale() {
    return getStorage.remove(_locale);
  }

  // Dark mode
  ThemeMode get themeMode {
    final String themeMode = getStorage.read(_themeMode) ?? 'system';

    return ThemeMode.values.byName(themeMode);
  }

  Future<void> saveThemeMode(ThemeMode themeMode) {
    return getStorage.write(_themeMode, themeMode.name);
  }

  Future<void> removeThemeMode() {
    return getStorage.remove(_themeMode);
  }

  // Delete all data
  Future<void> removeAllData() async {
    final localStorage = Get.find<LocalStorage>();
    final locale = localStorage.locale;
    final themeMode = localStorage.themeMode;
    await Future.wait([
      _getStorage.erase(),
      _secureStorage.deleteAll(),
    ]);
    if (locale != null) {
      await Future.wait([
        localStorage.saveLocale(locale),
        localStorage.saveThemeMode(themeMode),
      ]);
    }
  }
}

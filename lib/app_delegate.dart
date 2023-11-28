import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/core/config/app_env.dart';
import 'package:lettutor/core/di/di.dart';
import 'package:lettutor/presentation/test_ui/blocs/test_ui_bloc.dart';
import 'package:lettutor/routes/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'application.dart';
import 'package:lettutor/data/providers/local/preferences.dart';

class Mutable<T> {
  Mutable(this.value);
  T value;
}

class AppDelegate {
  Future<Widget> build(Map<String, dynamic> environment) async {
    WidgetsFlutterBinding.ensureInitialized();

    AppEnv().setEnvValue(environment);

    configureDependencies(environment: Environment.prod);
    var isMobile = AppEnv.isMobileMode;
    final savedThemeMode = await AdaptiveTheme.getThemeMode();

    return Application(
      navigationKey: GlobalKey<NavigatorState>(),
      providers: [
        BlocProvider<TestUiBloc>(create: (_) => injector.get()),
      ],
      initialRoute: Routes.splash,
      savedThemeMode: savedThemeMode,
      isMobile: isMobile,
    );
  }

  Future<void> run(Map<String, dynamic> environment) async {
    final app = await build(environment);
    await Preferences.ensureInitedPreferences();
    WidgetsFlutterBinding.ensureInitialized();
    runApp(app);
  }
}

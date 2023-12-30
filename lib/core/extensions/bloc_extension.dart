import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lettutor/core/layouts/setting_layout/controllers/setting_bloc.dart';

extension BlocExtension<T> on BuildContext {
  SettingBloc get readSettingBloc => read<SettingBloc>();
}

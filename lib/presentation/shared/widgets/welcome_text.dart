import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:lettutor/core/extensions/bloc_extension.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/layouts/setting_layout/controllers/setting_bloc.dart';
import 'package:lettutor/generated/l10n.dart';

class WelcomeText extends StatefulWidget {
  const WelcomeText({super.key});

  @override
  State<WelcomeText> createState() => _WelcomeTextState();
}

class _WelcomeTextState extends State<WelcomeText> {
  SettingBloc get _settingBloc => context.readSettingBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      bloc: _settingBloc,
      builder: (ctx, state) {
        final currentUser = state.data.currentUser;
        if (currentUser == null) {
          return const SizedBox();
        }
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text.rich(TextSpan(
              style: context.titleSmall,
              children: [
                TextSpan(
                  text: S.of(context).welcomeToLetTutor,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextSpan(text: ' ${currentUser.name}')
              ],
            )));
      },
    );
  }
}

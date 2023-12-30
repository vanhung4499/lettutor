import 'package:flutter/material.dart';
import 'package:lettutor/core/config/app_env.dart';
import 'package:lettutor/core/constants/image_constant.dart';
import 'package:lettutor/core/extensions/bloc_extension.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/layouts/setting_layout/controllers/setting_bloc.dart';
import 'package:lettutor/core/layouts/setting_layout/utils/setting_utils.dart';
import 'package:lettutor/core/widgets/dropdown_button_custom.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RenderAppBar extends StatefulWidget {
  const RenderAppBar({super.key});

  @override
  State<RenderAppBar> createState() => _RenderAppBarState();
}

class _RenderAppBarState extends State<RenderAppBar> {
  SettingBloc get _settingBloc => context.readSettingBloc;

  Color get primaryColor => Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.school, color: primaryColor, size: 30),
        Text(
          AppEnv.name,
          style: context.titleLarge
              .copyWith(fontWeight: FontWeight.bold, color: primaryColor),
        ),
        const Spacer(),
        BlocBuilder<SettingBloc, SettingState>(
          bloc: _settingBloc,
          builder: (ctx, state) {
            final lang = state.data.langCode;
            return SizedBox(
              width: 80,
              child: DropdownButtonCustom<String?>(
                borderColor: Colors.transparent,
                showIcon: false,
                width: 60,
                items: SettingUtils.locals
                    .map(
                      (e) => DropdownMenuItem(
                    value: e.langCode,
                    child: Image.network(
                        e.image ?? ImageConstant.defaultImage,
                        width: 40,
                        height: 20),
                  ),
                ).toList(),
                value: lang,
                onChange: (lang) => _settingBloc.add(
                  SettingEvent.updateLangCode(
                      langCode: lang ?? SettingUtils.locals.first.langCode),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/app_coordinator.dart';
import 'package:lettutor/data/models/request/update_profile_request.dart';
import 'package:lettutor/domain/entities/common/topic.dart';
import 'package:lettutor/domain/entities/user/user.dart';
import 'package:lettutor/core/constants/constants.dart';
import 'package:lettutor/core/utils/handle_time.dart';
import 'package:lettutor/core/constants/image_constant.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/widgets/button_custom.dart';
import 'package:lettutor/core/widgets/dropdown_button_custom.dart';
import 'package:lettutor/core/widgets/image_custom.dart';
import 'package:lettutor/core/widgets/loading_page.dart';
import 'package:lettutor/generated/l10n.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../blocs/user_profile_bloc.dart';
import '../blocs/user_profile_state.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserProfileBloc get _bloc => BlocProvider.of<UserProfileBloc>(context);

  Object? listen;

  Color get _primaryColor => Theme.of(context).primaryColor;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studySchedule = TextEditingController();

  final ValueNotifier _birthday = ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier _countryCode = ValueNotifier<String>('');
  final ValueNotifier<String> _levels = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();

    listen ??= _bloc.state$.flatMap(handleState).collect();

    _bloc.getUserInfo();
    _bloc.listTopic();
  }

  void _onSelectedTime() async {
    final time = await context.pickDate(DatePickerMode.day);
    if (time != null) {
      _birthday.value = time;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studySchedule.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.loading$,
      builder: (ctx, sS) {
        final loading = sS.data ?? false;
        return Stack(
          children: [
            _body(context),
            if (loading)
              Container(
                color: Colors.black45,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _loading(),
              )
          ],
        );
      },
    );
  }

  Widget _body(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SafeArea(
            child: ButtonCustom(
              onPress: () => _bloc.updateProfile(
                UpdateProfileRequest(
                  name: _nameController.text,
                  country: _countryCode.value,
                  birthDay: _birthday.value,
                  level: _levels.value,
                  studySchedule: _studySchedule.text,
                ),
              ),
              width: double.infinity,
              radius: 10.0,
              height: 45.0,
              child: Text(
                S.of(context).updateProfile,
                style: context.titleMedium
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
        appBar: _buildAppBar(context),
        body: StreamBuilder(
          stream: _bloc.user$,
          builder: (ctx, sS) {
            final user = sS.data;
            if (user == null) {
              return const SizedBox();
            }
            return _buildMainView(user, context);
          },
        ),
      ),
    );
  }

  ListView _buildMainView(User user, BuildContext context) {
    return ListView(
      children: [
        _buildAvatarWidget(user),
        ...[user.email ?? '', user.phone ?? ''].map(
              (e) => Text(
            e,
            textAlign: TextAlign.center,
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
        const Divider(),
        _informationTextField(
          controller: _nameController,
          hintText: S.of(context).enterYourName,
          labelText: S.of(context).name,
        ),
        const SizedBox(),
        ...[
          S.of(context).birthDay,
          S.of(context).country,
          S.of(context).userLevels,
          S.of(context).topicsAndPreparations
        ].mapIndexed(
              (index, e) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).hintColor,
                ),
              ),
              const SizedBox(height: 5.0),
              switch (index) {
                0 => _buildCalendarWidget(context),
                1 => _buildSelectCountryWidget(user, context),
                2 => _buildLevelWidget(),
                _ => StreamBuilder<List<Topic>>(
                  stream: _bloc.topics$,
                  builder: (ctx2, sS2) {
                    final topics = sS2.data ?? <Topic>[];
                    return StreamBuilder<List<Topic>>(
                      stream: _bloc.selectedTopics$,
                      builder: (ctx3, sS3) {
                        final topicSelected = sS3.data ?? <Topic>[];
                        return _buildListTopicWidget(
                          topics: topics,
                          topicsSelected: topicSelected,
                        );
                      },
                    );
                  },
                )
              }
            ],
          ),
        ),
        const SizedBox(height: 10),
        _informationTextField(
          controller: _studySchedule,
          hintText: S.of(context).enterStudySchedule,
          labelText: S.of(context).studySchedule,
        ),
      ]
          .expand((e) => [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: e,
        ),
        const SizedBox(height: 5.0),
      ])
          .toList(),
    );
  }

  Widget _buildListTopicWidget(
      {required List<Topic> topics, required List<Topic> topicsSelected}) {
    return Wrap(
      spacing: 6.0,
      runSpacing: -8,
      alignment: WrapAlignment.start,
      verticalDirection: VerticalDirection.up,
      children: [
        ...topics.map((e) {
          final isSelected =
              topicsSelected.indexWhere((element) => element.key == e.key) !=
                  -1;
          return ChoiceChip(
            label: Text(
              e.name ?? '',
              style: context.titleSmall.copyWith(
                fontSize: 14,
                color: isSelected ? _primaryColor : null,
                fontWeight: FontWeight.w400,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            avatar: isSelected
                ? Icon(Icons.check, color: _primaryColor, size: 15.0)
                : null,
            selected: isSelected,
            onSelected: (_) => _bloc.selectedTopic(e),
            backgroundColor: Theme.of(context).dividerColor.withOpacity(0.07),
            selectedColor: _primaryColor.withOpacity(0.1),
          );
        })
      ],
    );
  }

  ValueListenableBuilder<String> _buildLevelWidget() {
    return ValueListenableBuilder<String>(
      valueListenable: _levels,
      builder: (_, level, __) {
        return SizedBox(
          width: double.infinity,
          child: DropdownButtonCustom<String?>(
            borderWidth: 1.5,
            radius: 10.0,
            items: Constants.userLevels.entries
              .mapIndexed(
                (index, element) =>
                  DropdownMenuItem(value: element.key, child: Text(element.value)
              ),
            ).toList(),
            value: level.toUpperCase(),
            onChange: (value) {
              if (value?.isNotEmpty ?? false) {
                _levels.value = value!;
              }
            },
          ),
        );
      },
    );
  }

  Container _buildSelectCountryWidget(User user, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 1.5, color: Theme.of(context).dividerColor),
      ),
      child: ValueListenableBuilder(
          valueListenable: _countryCode,
          builder: (_, countryCode, __) {
            return Row(
              children: [
                CountryCodePicker(
                  padding: const EdgeInsets.all(0),
                  initialSelection: user.country,
                  showCountryOnly: true,
                  showOnlyCountryWhenClosed: true,
                  enabled: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  dialogBackgroundColor:
                  Theme.of(context).scaffoldBackgroundColor,
                  hideMainText: false,
                  showFlagMain: true,
                  showFlag: true,
                  hideSearch: false,
                  showFlagDialog: true,
                  onChanged: (value) {
                    _countryCode.value = value.code;
                  },
                ),
                Expanded(child: Text(countryCode, style: context.titleMedium))
              ],
            );
          }),
    );
  }

  ValueListenableBuilder<dynamic> _buildCalendarWidget(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _birthday,
      builder: (_, birthDay, __) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border:
            Border.all(width: 1.5, color: Theme.of(context).dividerColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(getYmdFormat(birthDay), style: context.titleMedium),
              ),
              InkWell(
                onTap: _onSelectedTime,
                child: Icon(Icons.calendar_month, color: _primaryColor),
              )
            ],
          ),
        );
      },
    );
  }

  TextFormField _informationTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelStyle: TextStyle(decorationColor: _primaryColor),
        labelText: labelText,
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          BorderSide(color: Theme.of(context).dividerColor, width: 1.5),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _primaryColor, width: 1.5),
          gapPadding: 10,
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        S.of(context).userInformation,
        style: context.titleLarge.copyWith(fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        onPressed: () => _bloc.popScreen(),
        icon: Icon(Icons.arrow_back, color: context.titleLarge.color),
      ),
    );
  }

  Row _buildAvatarWidget(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _bloc.changeAvatar(),
          child: StreamBuilder(
            stream: _bloc.imageBytes,
            builder: (ctx, sS) {
              final imageData = sS.data;
              return ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: imageData == null
                    ? ImageCustom(
                  imageUrl: user.avatar ?? ImageConstant.defaultImage,
                  isNetworkImage: true,
                  width: 120,
                  height: 120,
                )
                    : Image.memory(imageData,
                    width: 120, height: 120, fit: BoxFit.cover),
              );
            },
          ),
        ),
      ],
    );
  }

  Stream handleState(state) async* {
    if (state is GetUserInfoSuccess) {
      log("🌟[Get user information] success");
      _nameController.text = state.user.name;
      _studySchedule.text = state.user.studySchedule ?? '';
      _birthday.value = state.user.birthday;
      _countryCode.value = state.user.country;
      if (state.user.level?.isNotEmpty ?? false) {
        _levels.value = state.user.level!.toUpperCase();
      } else {
        _levels.value = "BEGINNER";
      }
    }
    if (state is GetUserInfoFailed) {
      context.showSnackBar("🌟[Get user information] ${state.toString()}");
      return;
    }
    if (state is UpdateUserProfileFailed) {
      context.showSnackBar("🌟[Update information] ${state.toString()}");
      return;
    }
    if (state is UpdateUserProfileSuccess) {
      context.showSnackBar("🌟[Update information] Success");
      return;
    }
    if (state is PopScreenSuccess) {
      context.popArgs(state.user);
      return;
    }
  }

  Center _loading() {
    return Center(
      child: StyleLoadingWidget.fadingCube
          .renderWidget(size: 40.0, color: _primaryColor),
    );
  }
}

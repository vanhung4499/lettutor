import 'dart:typed_data';

import 'package:disposebag/disposebag.dart';
import 'package:flutter/cupertino.dart';
import 'package:lettutor/core/services/image_picker_service.dart';
import 'package:lettutor/data/models/request/update_profile_request.dart';
import 'package:lettutor/domain/entities/common/topic.dart';
import 'package:lettutor/domain/entities/user/user.dart';
import 'package:lettutor/core/utils/stream_extension.dart';
import 'package:lettutor/core/utils/type_defs.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/domain/usecases/user_profile_usecase.dart';
import 'package:lettutor/presentation/user_profile/blocs/user_profile_state.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

@injectable
class UserProfileBloc extends DisposeCallbackBaseBloc {
  ///[User info]
  final Function0<void> getUserInfo;

  final Function0<void> changeAvatar;

  final Function0<void> listTopic;

  final Function0<void> popScreen;

  final Function1<Topic, void> selectedTopic;

  final Function1<UpdateProfileRequest, void> updateProfile;

  ///[Stream]

  final Stream<User?> user$;

  final Stream<Uint8List?> imageBytes;

  final Stream<List<Topic>> topics$;

  final Stream<List<Topic>> selectedTopics$;

  final Stream<UserProfileState> state$;

  final Stream<bool?> loading$;

  UserProfileBloc._({
    required Function0<void> dispose,
    required this.popScreen,
    required this.getUserInfo,
    required this.updateProfile,
    required this.listTopic,
    required this.selectedTopic,
    required this.topics$,
    required this.selectedTopics$,
    required this.changeAvatar,
    required this.imageBytes,
    required this.user$,
    required this.state$,
    required this.loading$,
  }) : super(dispose);

  factory UserProfileBloc(
      {required UserProfileUseCase userProfileUseCase,
        required ImagePickerService imagePickerService}) {
    final topicController =
    BehaviorSubject<List<Topic>>.seeded(List<Topic>.empty(growable: true));

    final topicSelectedController =
    BehaviorSubject<List<Topic>>.seeded(List<Topic>.empty(growable: true));

    final loadingController = BehaviorSubject<bool?>.seeded(false);

    final userController = BehaviorSubject<User?>.seeded(null);

    final updateProfileRequestController =
    BehaviorSubject<UpdateProfileRequest?>.seeded(null);

    final imageController = BehaviorSubject<Uint8List?>.seeded(null);

    final getUserInfoController = PublishSubject<void>();

    final changeAvatarController = PublishSubject<void>();

    final popScreenController = PublishSubject<void>();

    final fetchTopicsController = PublishSubject<void>();

    final updateProfileController = PublishSubject<void>();

    final selectedTopicController = PublishSubject<Topic>();

    final getUserInfo$ = getUserInfoController.stream
        .withLatestFrom(
        loadingController.stream, (_, loading) => !(loading ?? false))
        .share();

    final changeAvatarState$ = changeAvatarController
        .debug(identifier: 'ChangeAvatar [1]', log: debugPrint)
        .switchMap(
          (_) => Rx.fromCallable(
              () => imagePickerService.pickImage(ImageSource.gallery))
          .debug(identifier: 'Choose image', log: debugPrint),
    )
        .debug(identifier: 'Change avatar [2]', log: debugPrint)
        .map((file) => file)
        .whereNotNull()
        .distinct()
        .map((value) {
      imageController.add(value);
      return const ChangeAvatarSuccess();
    });

    ///[Handle topics]
    final selectedTopicState$ = selectedTopicController.stream.map((topic) {
      final currentSelectedTopics = topicSelectedController.value;
      if (currentSelectedTopics
          .indexWhere((element) => element.key == topic.key) !=
          -1) {
        topicSelectedController.add(
          currentSelectedTopics
              .where((element) => element.key != topic.key)
              .toList(),
        );
      } else {
        topicSelectedController.add([...currentSelectedTopics, topic]);
      }
      return const SelectTopicSuccess();
    }).share();

    final fetchTopicState$ =
    fetchTopicsController.debug(log: debugPrint).exhaustMap((_) {
      try {
        return userProfileUseCase.listTopic().map(
              (data) => data.fold(
              ifLeft: (error) => ListTopicFailed(
                  message: error.message, error: error.code),
              ifRight: (listTopic) {
                if (listTopic.isNotEmpty) {
                  topicController.add(listTopic);
                }
                return const ListTopicSuccess();
              }),
        );
      } catch (e) {
        return Stream<UserProfileState>.error(
          ListTopicFailed(message: e.toString()),
        );
      }
    });

    ///[Handle update profile]
    ///
    final isValid$ = Rx.combineLatest2(
      loadingController.stream,
      updateProfileRequestController.stream,
          (loading, value) {
        if (value == null) {
          return false;
        }
        return (value.name.isNotEmpty &&
            value.country.isNotEmpty &&
            value.level.isNotEmpty) &&
            !(loading ?? false);
      },
    ).shareValueSeeded(false);

    final updateProfile$ = updateProfileController.stream
        .withLatestFrom(isValid$, (_, isValid) => isValid)
        .share();

    final updateProfileState$ = Rx.merge<UserProfileState>([
      updateProfile$
          .where((isValid) => isValid)
          .debug(log: debugPrint)
          .withLatestFrom(updateProfileRequestController.stream, (_, s) => s!)
          .exhaustMap(
            (request) => userProfileUseCase
            .updateUserInf(updateProfileRequest: request)
            .doOn(
          listen: () => loadingController.add(true),
          cancel: () => loadingController.add(false),
        )
            .map((data) => data.fold(
          ifLeft: (error) => UpdateUserProfileFailed(
              message: error.message, error: error.code),
          ifRight: (cData) {
            userController.add(cData);
            return const UpdateUserProfileSuccess();
          },
        )),
      ),
      updateProfile$
          .where((isValid) => !isValid)
          .map((_) => const UpdateUserProfileFailed(message: 'Invalid'))
    ]).whereNotNull().share();

    final popScreenState$ = popScreenController.stream
        .withLatestFrom(userController.stream, (_, user) => user)
        .map((event) => PopScreenSuccess(event!));

    final state$ = Rx.merge<UserProfileState>([
      popScreenState$,
      updateProfileState$,
      fetchTopicState$,
      changeAvatarState$,
      selectedTopicState$,
      getUserInfo$.where((isValid) => isValid).exhaustMap((event) {
        try {
          return userProfileUseCase
              .getUserInfo()
              .doOn(
            listen: () => loadingController.add(true),
            cancel: () => loadingController.add(false),
          )
              .map((data) => data.fold(
              ifLeft: (error) => GetUserInfoFailed(
                  message: error.message, error: error.code),
              ifRight: (cData) {
                userController.add(cData);

                topicSelectedController.add(<Topic>[
                  ...cData.learnTopics,
                  ...cData.testPreparations
                ]);
                return GetUserInfoSuccess(cData);
              }));
        } catch (e) {
          return Stream.error(GetUserInfoFailed(message: e.toString()));
        }
      }),
      getUserInfo$.where((isValid) => !isValid).map(
            (_) => const GetUserInfoFailed(message: 'Invalid format'),
      )
    ]).whereNotNull().share();

    final subscriptions = <String, Stream>{
      'state': state$,
      'loadingController': loadingController,
      'isValid': isValid$,
    }.debug();

    return UserProfileBloc._(
      imageBytes: imageController,
      changeAvatar: () => changeAvatarController.add(null),
      dispose: () async => await DisposeBag([
        loadingController,
        userController,
        getUserInfoController,
        changeAvatarController,
        imageController,
        topicController,
        fetchTopicsController,
        selectedTopicController,
        topicSelectedController,
        updateProfileController,
        updateProfileRequestController,
        popScreenController,
        ...subscriptions,
      ]).dispose(),
      updateProfile: (request) {
        final currentTopicSelected = topicSelectedController.value;
        updateProfileRequestController.add(
          UpdateProfileRequest(
            name: request.name,
            country: request.country,
            birthDay: request.birthDay,
            level: request.level,
            studySchedule: request.studySchedule,
            learnTopic: currentTopicSelected
              .where((element) => element.isTopics ?? false)
              .map((e) => e.id.toString())
              .toList(),
            testPreparations: currentTopicSelected
              .where((element) => !(element.isTopics ?? false))
              .map((e) => e.id.toString())
              .toList(),
          ),
        );
        updateProfileController.add(null);
      },
      popScreen: () => popScreenController.add(null),
      getUserInfo: () => getUserInfoController.add(null),
      user$: userController,
      state$: state$,
      loading$: loadingController,
      listTopic: () => fetchTopicsController.add(null),
      selectedTopics$: topicSelectedController,
      selectedTopic: (topic) => selectedTopicController.add(topic),
      topics$: topicController,
    );
  }
}

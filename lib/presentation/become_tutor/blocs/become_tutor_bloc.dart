import 'package:country_code_picker/country_code_picker.dart';
import 'package:disposebag/disposebag.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/data/models/request/become_tutor_request.dart';
import 'package:lettutor/domain/entities/common/topic.dart';
import 'package:lettutor/core/constants/constants.dart';
import 'package:lettutor/core/utils/stream_extension.dart';
import 'package:lettutor/core/utils/type_defs.dart';
import 'package:lettutor/core/services/image_picker_service.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:lettutor/domain/usecases/become_tutor_usecase.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import 'become_tutor_state.dart';

@injectable
class BecomeTutorBloc extends DisposeCallbackBaseBloc {
  final Function1<int, void> changeStep;

  final Function0<void> selectImage;

  final Function1<Topic, void> selectTopic;

  final Function0<void> listTopicData;

  final Function0<void> changeAvatar;

  final Function1<CountryCode, void> changeCountryCode;

  final Function1<DateTime, void> changeBirthday;

  final Function1<String, void> changeStudentType;

  final Function1<Map<String, String>, void> registerTutor;

  final Function1<String, void> getName;

  ///-----------------------------------------------

  final Stream<int> step$;

  final Stream<DateTime> birthday$;

  final Stream<CountryCode?> countryCode$;

  final Stream<List<Topic>> topics$;

  final Stream<List<Topic>> selectedTopic$;

  final Stream<ImageData?> imageData$;

  final Stream<String?> studentType$;

  final Stream<BecomeTutorState> state$;

  final Stream<bool> loading$;

  BecomeTutorBloc._({
    required Function0<void> dispose,
    required this.selectImage,
    required this.changeAvatar,
    required this.listTopicData,
    required this.changeStep,
    required this.selectTopic,
    required this.changeCountryCode,
    required this.changeStudentType,
    required this.changeBirthday,
    required this.getName,
    required this.registerTutor,
    //-------------------------
    required this.countryCode$,
    required this.selectedTopic$,
    required this.state$,
    required this.topics$,
    required this.birthday$,
    required this.step$,
    required this.imageData$,
    required this.studentType$,
    required this.loading$,
  }) : super(dispose);

  factory BecomeTutorBloc({
    required BecomeTutorUseCase becomeTutorUseCase,
    required ImagePickerService imagePickerService,
  }) {
    final stepController = BehaviorSubject<int>.seeded(0);

    final bothImageController = BehaviorSubject<ImageData?>.seeded(null);

    final dateBornController = BehaviorSubject<DateTime>.seeded(DateTime.now());

    final topicController =
    BehaviorSubject<List<Topic>>.seeded(List<Topic>.empty(growable: true));

    final topicSelectedController =
    BehaviorSubject<List<Topic>>.seeded(List<Topic>.empty(growable: true));

    final countryCodeController =
    BehaviorSubject<CountryCode?>.seeded(CountryCode(code: "VN"));

    final typeStudentController =
    BehaviorSubject<String?>.seeded(Constants.userLevels.entries.first.key);

    final loadingController = BehaviorSubject<bool>.seeded(false);

    final interestController = BehaviorSubject<String>.seeded("");

    final educationController = BehaviorSubject<String>.seeded("");

    final experienceController = BehaviorSubject<String>.seeded("");

    final professionController = BehaviorSubject<String>.seeded("");

    final bioController = BehaviorSubject<String>.seeded("");

    final languageController = BehaviorSubject<String>.seeded("");

    final nameController = BehaviorSubject<String>.seeded("");

    ///----------------------------------------------------------------

    final changeAvatarController = PublishSubject<void>();

    final fetchTopicsController = PublishSubject<void>();

    final registeringController = PublishSubject<void>();

    final selectedTopicController = PublishSubject<Topic>();

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
        return becomeTutorUseCase.listTopic().map(
              (data) => data.fold(
              ifLeft: (error) => ListTopicFailed(
                  message: error.message, error: error.code),
              ifRight: (listTopic) {
                if (listTopic.isNotEmpty) {
                  topicController.add(listTopic);
                }
                return const ListTopicFailed();
              }),
        );
      } catch (e) {
        return Stream<BecomeTutorState>.error(
          ListTopicFailed(message: e.toString()),
        );
      }
    });

    ///[Avatar handle]
    ///
    final changeAvatarState$ = changeAvatarController
        .debug(identifier: 'ChangeAvatar [1]', log: debugPrint)
        .switchMap(
          (_) => Rx.fromCallable(
              () => imagePickerService.selectedImage(ImageSource.gallery))
          .debug(identifier: 'Choose image', log: debugPrint),
    )
        .debug(identifier: 'Change avatar [2]', log: debugPrint)
        .map((file) => file)
        .whereNotNull()
        .distinct()
        .map((value) {
      bothImageController.add(value);
      return const ChangeAvatarSuccess();
    });

    ///[Handle registering]

    final isValid$ = Rx.combineLatest7(
      interestController.stream.map((e) => e.isNotEmpty),
      educationController.stream.map((e) => e.isNotEmpty),
      experienceController.stream.map((e) => e.isNotEmpty),
      professionController.stream.map((e) => e.isNotEmpty),
      bioController.stream.map((e) => e.isNotEmpty),
      languageController.stream.map((e) => e.isNotEmpty),
      loadingController.stream,
          (a, b, c, d, e, f, g) => (a && b && c && d && e && f) && !g,
    ).shareValueSeeded(false);

    final request$ = Rx.combineLatest(
        [
          interestController.stream, //0
          educationController.stream, //1
          experienceController.stream, //2
          professionController.stream, //3
          bioController.stream, //4
          languageController.stream, //5
          countryCodeController.stream, //6
          topicSelectedController.stream, //7
          dateBornController.stream, //8
          typeStudentController.stream, //9
          bothImageController.stream, //10
          nameController.stream, //11
        ],
            (values) => BecomeTutorRequest(
          name: values[11].toString(),
          country: (values[6] as CountryCode).code ?? "VN",
          birthDay: values[8] as DateTime,
          interest: values[0].toString(),
          education: values[1].toString(),
          experience: values[2].toString(),
          profession: values[3].toString(),
          languages: values[5].toString(),
          bio: values[4].toString(),
          targetStudent: values[9].toString(),
          specialties: values[7] as List<Topic>,
          avatar: values[10] == null
              ? ""
              : (values[10] as ImageData).path ?? "",
          price: 50000,
        ));

    final submit$ = registeringController.stream
        .withLatestFrom(isValid$, (_, isValid) => isValid)
        .share();

    final registeringState$ = Rx.merge<BecomeTutorState>([
      submit$
          .where((isValid) => isValid)
          .debug(log: debugPrint)
          .withLatestFrom(request$, (_, request) => request)
          .exhaustMap((request) {
        try {
          return becomeTutorUseCase
              .registeringTutor(becomeTutorRequest: request)
              .doOn(
            listen: () => loadingController.add(true),
            cancel: () => loadingController.add(false),
          )
              .map(
                (data) => data.fold(
              ifLeft: (error) => const RegisterTutorFailed(
                  message: "User has already been a tutor"),
              ifRight: (_) => const RegisterTutorSuccess(),
            ),
          );
        } catch (e) {
          return Stream.error(const RegisterTutorFailed(
              message: "User has already been a tutor"));
        }
      }),
      submit$
          .where((isValid) => !isValid)
          .map((_) => const RegisterTutorFailed(message: "Invalid format"))
    ]).whereNotNull().share();

    final state$ = Rx.merge<BecomeTutorState>([
      selectedTopicState$,
      fetchTopicState$,
      changeAvatarState$,
      registeringState$
    ]).whereNotNull().share();

    final subscriptions = <String, Stream>{
      'state': state$,
      'loadingController': loadingController,
      'isValid': isValid$,
    }.debug();

    return BecomeTutorBloc._(
      dispose: () async => await DisposeBag([
        stepController,
        bothImageController,
        dateBornController,
        topicController,
        topicSelectedController,
        countryCodeController,
        typeStudentController,
        fetchTopicsController,
        selectedTopicController,
        changeAvatarController,
        loadingController,
        interestController,
        educationController,
        experienceController,
        professionController,
        bioController,
        languageController,
        registeringController,
        nameController,
        ...subscriptions,
      ]).dispose(),
      state$: state$,
      loading$: loadingController,
      countryCode$: countryCodeController,
      studentType$: typeStudentController,
      step$: stepController,
      changeAvatar: () => changeAvatarController.add(null),
      imageData$: bothImageController,
      changeStudentType: (type) => typeStudentController.add(type),
      changeStep: (index) => stepController.add(index),
      birthday$: dateBornController,
      selectImage: () {},
      listTopicData: () => fetchTopicsController.add(null),
      selectTopic: (value) => selectedTopicController.add(value),
      selectedTopic$: topicSelectedController,
      topics$: topicController,
      changeCountryCode: (countryCode) =>
          countryCodeController.add(countryCode),
      changeBirthday: (dateBorn) => dateBornController.add(dateBorn),
      getName: (name) => nameController.add(name),
      registerTutor: (textData) {
        interestController.add(textData['interest']?.toString() ?? '');
        educationController.add(textData['education']?.toString() ?? '');
        experienceController.add(textData['experience']?.toString() ?? '');
        professionController.add(textData['profession']?.toString() ?? '');
        bioController.add(textData['bio']?.toString() ?? '');
        languageController.add(textData['language']?.toString() ?? '');

        registeringController.add(null);
      },
    );
  }
}

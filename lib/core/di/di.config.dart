// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/models/request/search_tutor_request.dart' as _i44;
import '../../data/providers/network/apis/auth_api.dart' as _i18;
import '../../data/providers/network/apis/common_api.dart' as _i22;
import '../../data/providers/network/apis/course_api.dart' as _i25;
import '../../data/providers/network/apis/schedule_api.dart' as _i7;
import '../../data/providers/network/apis/tutor_api.dart' as _i12;
import '../../data/providers/network/apis/user_api.dart' as _i15;
import '../../data/repositories/auth_repository_impl.dart' as _i20;
import '../../data/repositories/common_repository_impl.dart' as _i24;
import '../../data/repositories/course_repository_impl.dart' as _i27;
import '../../data/repositories/schedule_repository_impl.dart' as _i9;
import '../../data/repositories/tutor_repository_impl.dart' as _i14;
import '../../data/repositories/user_repository_impl.dart' as _i17;
import '../../domain/repositories/auth_repository.dart' as _i19;
import '../../domain/repositories/common_repository.dart' as _i23;
import '../../domain/repositories/course_repository.dart' as _i26;
import '../../domain/repositories/schedule_repository.dart' as _i8;
import '../../domain/repositories/tutor_repository.dart' as _i13;
import '../../domain/repositories/user_repository.dart' as _i16;
import '../../domain/usecases/become_tutor_usecase.dart' as _i46;
import '../../domain/usecases/booking_usecase.dart' as _i21;
import '../../domain/usecases/course_detail_usecase.dart' as _i47;
import '../../domain/usecases/course_usecase.dart' as _i28;
import '../../domain/usecases/ebook_usecase.dart' as _i29;
import '../../domain/usecases/feedback_tutor_usecase.dart' as _i38;
import '../../domain/usecases/login_usecase.dart' as _i30;
import '../../domain/usecases/main_usecase.dart' as _i31;
import '../../domain/usecases/reset_password_usecase.dart' as _i33;
import '../../domain/usecases/search_tutor_usecase.dart' as _i35;
import '../../domain/usecases/setting_usecase.dart' as _i36;
import '../../domain/usecases/tutor_detail_usecase.dart' as _i37;
import '../../domain/usecases/tutor_list_usecase.dart' as _i39;
import '../../domain/usecases/tutor_schedule_usecase.dart' as _i41;
import '../../domain/usecases/user_profile_usecase.dart' as _i45;
import '../../presentation/auth/blocs/login/login_bloc.dart' as _i51;
import '../../presentation/auth/blocs/register/register_bloc.dart' as _i32;
import '../../presentation/auth/blocs/reset_password/reset_password_bloc.dart'
    as _i52;
import '../../presentation/become_tutor/blocs/become_tutor_bloc.dart' as _i59;
import '../../presentation/course_detail/blocs/course_detail_bloc.dart' as _i60;
import '../../presentation/course_list/blocs/home_bloc.dart' as _i48;
import '../../presentation/dashboard/blocs/dashboard_bloc.dart' as _i3;
import '../../presentation/ebook/blocs/ebook_bloc.dart' as _i49;
import '../../presentation/home/blocs/home_bloc.dart' as _i50;
import '../../presentation/schedule/blocs/schedule_bloc.dart' as _i34;
import '../../presentation/splash/bloc/splash_bloc.dart' as _i10;
import '../../presentation/test_ui/blocs/test_ui_bloc.dart' as _i11;
import '../../presentation/tutor_detail/blocs/tutor_detail_bloc.dart' as _i54;
import '../../presentation/tutor_detail/blocs/tutor_report_bloc.dart' as _i40;
import '../../presentation/tutor_feedback/blocs/tutor_feedback_bloc.dart'
    as _i55;
import '../../presentation/tutor_list/blocs/tutor_list_bloc.dart' as _i56;
import '../../presentation/tutor_schedule/blocs/tutor_schedule_bloc.dart'
    as _i57;
import '../../presentation/tutor_search/blocs/tutor_search_bloc.dart' as _i42;
import '../../presentation/tutor_search/blocs/tutor_search_result_bloc.dart'
    as _i43;
import '../../presentation/user_profile/blocs/user_profile_bloc.dart' as _i58;
import '../layouts/setting_layout/controllers/setting_bloc.dart' as _i53;
import '../services/google_sign_in_service.dart' as _i5;
import '../services/image_picker_service.dart' as _i6;
import 'modules/provider_module.dart' as _i61;

const String _prod = 'prod';

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt init(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final providerModule = _$ProviderModule();
  gh.factory<_i3.DashboardBloc>(() => _i3.DashboardBloc());
  gh.factory<_i4.Dio>(
    () => providerModule.dioProd(),
    registerFor: {_prod},
  );
  gh.factory<_i5.GoogleSignInService>(() => _i5.GoogleSignInService());
  gh.factory<_i6.ImagePickerService>(() => _i6.ImagePickerService());
  gh.factory<_i7.ScheduleApi>(() => _i7.ScheduleApi(gh<_i4.Dio>()));
  gh.factory<_i8.ScheduleRepository>(
      () => _i9.ScheduleRepositoryImpl(gh<_i7.ScheduleApi>()));
  gh.factory<_i10.SplashBloc>(() => _i10.SplashBloc());
  gh.factory<_i11.TestUiBloc>(() => _i11.TestUiBloc());
  gh.factory<_i12.TutorApi>(() => _i12.TutorApi(gh<_i4.Dio>()));
  gh.factory<_i13.TutorRepository>(
      () => _i14.TutorRepositoryImpl(gh<_i12.TutorApi>()));
  gh.factory<_i15.UserApi>(() => _i15.UserApi(gh<_i4.Dio>()));
  gh.factory<_i16.UserRepository>(
      () => _i17.UserRepositoriesImpl(gh<_i15.UserApi>()));
  gh.factory<_i18.AuthApi>(() => _i18.AuthApi(gh<_i4.Dio>()));
  gh.factory<_i19.AuthRepository>(() => _i20.AuthRepositoryImpl(
        gh<_i18.AuthApi>(),
        gh<_i5.GoogleSignInService>(),
      ));
  gh.factory<_i21.BookingUseCase>(() => _i21.BookingUseCase(
        gh<_i8.ScheduleRepository>(),
        gh<_i16.UserRepository>(),
      ));
  gh.factory<_i22.CommonApi>(() => _i22.CommonApi(gh<_i4.Dio>()));
  gh.factory<_i23.CommonRepository>(
      () => _i24.CommonRepositoryImpl(gh<_i22.CommonApi>()));
  gh.factory<_i25.CourseApi>(() => _i25.CourseApi(gh<_i4.Dio>()));
  gh.factory<_i26.CourseRepository>(
      () => _i27.CourseRepositoryImpl(gh<_i25.CourseApi>()));
  gh.factory<_i28.CourseUseCase>(
      () => _i28.CourseUseCase(gh<_i26.CourseRepository>()));
  gh.factory<_i29.EbookUseCase>(() => _i29.EbookUseCase(
        gh<_i26.CourseRepository>(),
        gh<_i23.CommonRepository>(),
      ));
  gh.factory<_i30.LoginUseCase>(
      () => _i30.LoginUseCase(gh<_i19.AuthRepository>()));
  gh.factory<_i31.MainUseCase>(() => _i31.MainUseCase(
        gh<_i13.TutorRepository>(),
        gh<_i26.CourseRepository>(),
        gh<_i23.CommonRepository>(),
      ));
  gh.factory<_i32.RegisterBloc>(
      () => _i32.RegisterBloc(login: gh<_i30.LoginUseCase>()));
  gh.factory<_i33.ResetPasswordUseCase>(
      () => _i33.ResetPasswordUseCase(gh<_i19.AuthRepository>()));
  gh.factory<_i34.ScheduleBloc>(
      () => _i34.ScheduleBloc(bookingUseCase: gh<_i21.BookingUseCase>()));
  gh.factory<_i35.SearchTutorUseCase>(() => _i35.SearchTutorUseCase(
        gh<_i23.CommonRepository>(),
        gh<_i13.TutorRepository>(),
      ));
  gh.factory<_i36.SettingUseCase>(
      () => _i36.SettingUseCase(gh<_i16.UserRepository>()));
  gh.factory<_i37.TutorDetailUseCase>(() => _i37.TutorDetailUseCase(
        gh<_i13.TutorRepository>(),
        gh<_i16.UserRepository>(),
      ));
  gh.factory<_i38.TutorFeedbackUseCase>(
      () => _i38.TutorFeedbackUseCase(gh<_i16.UserRepository>()));
  gh.factory<_i39.TutorListUseCase>(() => _i39.TutorListUseCase(
        gh<_i13.TutorRepository>(),
        gh<_i16.UserRepository>(),
        gh<_i8.ScheduleRepository>(),
      ));
  gh.factoryParam<_i40.TutorReportBloc, String, dynamic>((
    userId,
    _,
  ) =>
      _i40.TutorReportBloc(
        userId,
        tutorDetailUseCase: gh<_i37.TutorDetailUseCase>(),
      ));
  gh.factory<_i41.TutorScheduleUseCase>(() => _i41.TutorScheduleUseCase(
        gh<_i13.TutorRepository>(),
        gh<_i16.UserRepository>(),
      ));
  gh.factory<_i42.TutorSearchBloc>(() =>
      _i42.TutorSearchBloc(searchTutorUseCase: gh<_i35.SearchTutorUseCase>()));
  gh.factoryParam<_i43.TutorSearchResultBloc, _i44.SearchTutorRequest, dynamic>(
      (
    request,
    _,
  ) =>
          _i43.TutorSearchResultBloc(
            request,
            searchTutorUseCase: gh<_i35.SearchTutorUseCase>(),
          ));
  gh.factory<_i45.UserProfileUseCase>(() => _i45.UserProfileUseCase(
        gh<_i16.UserRepository>(),
        gh<_i23.CommonRepository>(),
      ));
  gh.factory<_i46.BecomeTutorUseCase>(() => _i46.BecomeTutorUseCase(
        gh<_i16.UserRepository>(),
        gh<_i23.CommonRepository>(),
      ));
  gh.factory<_i47.CourseDetailUseCase>(
      () => _i47.CourseDetailUseCase(gh<_i26.CourseRepository>()));
  gh.factory<_i48.CourseListBloc>(
      () => _i48.CourseListBloc(courseUseCase: gh<_i28.CourseUseCase>()));
  gh.factory<_i49.EbookBloc>(
      () => _i49.EbookBloc(ebookUseCase: gh<_i29.EbookUseCase>()));
  gh.factory<_i50.HomeBloc>(
      () => _i50.HomeBloc(mainUseCase: gh<_i31.MainUseCase>()));
  gh.factory<_i51.LoginBloc>(
      () => _i51.LoginBloc(loginUseCase: gh<_i30.LoginUseCase>()));
  gh.factory<_i52.ResetPasswordBloc>(() => _i52.ResetPasswordBloc(
      resetPasswordUseCase: gh<_i33.ResetPasswordUseCase>()));
  gh.factory<_i53.SettingBloc>(
      () => _i53.SettingBloc(gh<_i36.SettingUseCase>()));
  gh.factoryParam<_i54.TutorDetailBloc, String, dynamic>((
    userId,
    _,
  ) =>
      _i54.TutorDetailBloc(
        userId,
        tutorDetailUseCase: gh<_i37.TutorDetailUseCase>(),
      ));
  gh.factoryParam<_i55.TutorFeedbackBloc, String, dynamic>((
    booId,
    _,
  ) =>
      _i55.TutorFeedbackBloc(
        booId,
        tutorFeedbackUseCase: gh<_i38.TutorFeedbackUseCase>(),
      ));
  gh.factory<_i56.TutorListBloc>(
      () => _i56.TutorListBloc(tutorListUseCase: gh<_i39.TutorListUseCase>()));
  gh.factoryParam<_i57.TutorScheduleBloc, String, dynamic>((
    userId,
    _,
  ) =>
      _i57.TutorScheduleBloc(
        userId,
        tutorScheduleUseCase: gh<_i41.TutorScheduleUseCase>(),
      ));
  gh.factory<_i58.UserProfileBloc>(() => _i58.UserProfileBloc(
        userProfileUseCase: gh<_i45.UserProfileUseCase>(),
        imagePickerService: gh<_i6.ImagePickerService>(),
      ));
  gh.factory<_i59.BecomeTutorBloc>(() => _i59.BecomeTutorBloc(
        becomeTutorUseCase: gh<_i46.BecomeTutorUseCase>(),
        imagePickerService: gh<_i6.ImagePickerService>(),
      ));
  gh.factoryParam<_i60.CourseDetailBloc, dynamic, dynamic>((
    courseId,
    _,
  ) =>
      _i60.CourseDetailBloc(
        courseId,
        courseDetailUseCase: gh<_i47.CourseDetailUseCase>(),
      ));
  return getIt;
}

class _$ProviderModule extends _i61.ProviderModule {}

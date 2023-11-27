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

import '../../data/providers/network/apis/auth_api.dart' as _i16;
import '../../data/providers/network/apis/common_api.dart' as _i20;
import '../../data/providers/network/apis/course_api.dart' as _i23;
import '../../data/providers/network/apis/schedule_api.dart' as _i5;
import '../../data/providers/network/apis/tutor_api.dart' as _i10;
import '../../data/providers/network/apis/user_api.dart' as _i13;
import '../../data/repositories/auth_repository_impl.dart' as _i18;
import '../../data/repositories/common_repository_impl.dart' as _i22;
import '../../data/repositories/course_repository_impl.dart' as _i25;
import '../../data/repositories/schedule_repository_impl.dart' as _i7;
import '../../data/repositories/tutor_repository_impl.dart' as _i12;
import '../../data/repositories/user_repository_impl.dart' as _i15;
import '../../domain/repositories/auth_repository.dart' as _i17;
import '../../domain/repositories/common_repository.dart' as _i21;
import '../../domain/repositories/course_repository.dart' as _i24;
import '../../domain/repositories/schedule_repository.dart' as _i6;
import '../../domain/repositories/tutor_repository.dart' as _i11;
import '../../domain/repositories/user_repository.dart' as _i14;
import '../../domain/usecases/become_tutor_usecase.dart' as _i41;
import '../../domain/usecases/booking_usecase.dart' as _i19;
import '../../domain/usecases/course_detail_usecase.dart' as _i42;
import '../../domain/usecases/course_usecase.dart' as _i26;
import '../../domain/usecases/login_usecase.dart' as _i28;
import '../../domain/usecases/main_usecase.dart' as _i29;
import '../../domain/usecases/rating_usecase.dart' as _i30;
import '../../domain/usecases/reset_password_usecase.dart' as _i32;
import '../../domain/usecases/search_tutor_usecase.dart' as _i34;
import '../../domain/usecases/setting_usecase.dart' as _i35;
import '../../domain/usecases/tutor_detail_usecase.dart' as _i36;
import '../../domain/usecases/tutor_list_usecase.dart' as _i38;
import '../../domain/usecases/tutor_schedule_usecase.dart' as _i39;
import '../../domain/usecases/user_info_usecase.dart' as _i40;
import '../../presentation/auth/blocs/login/login_bloc.dart' as _i43;
import '../../presentation/auth/blocs/register/register_bloc.dart' as _i31;
import '../../presentation/auth/blocs/reset_password/reset_password_bloc.dart'
    as _i45;
import '../../presentation/dashboard/blocs/dashboard_bloc.dart' as _i3;
import '../../presentation/home/blocs/home_bloc.dart' as _i27;
import '../../presentation/main/blocs/main_bloc.dart' as _i44;
import '../../presentation/schedule/blocs/schedule_bloc.dart' as _i33;
import '../../presentation/splash/bloc/splash_bloc.dart' as _i8;
import '../../presentation/test_ui/blocs/test_ui_bloc.dart' as _i9;
import '../../presentation/tutor_detail/blocs/tutor_detail_bloc.dart' as _i47;
import '../../presentation/tutor_detail/blocs/tutor_report_bloc.dart' as _i37;
import '../../presentation/tutor_list/blocs/tutor_list_bloc.dart' as _i48;
import '../layouts/setting_layout/controllers/setting_bloc.dart' as _i46;
import 'modules/provider_module.dart' as _i49;

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
  final dataSourceModule = _$DataSourceModule();
  gh.factory<_i3.DashboardBloc>(() => _i3.DashboardBloc());
  gh.factory<_i4.Dio>(
    () => dataSourceModule.dioProd(),
    registerFor: {_prod},
  );
  gh.factory<_i5.ScheduleApi>(() => _i5.ScheduleApi(gh<_i4.Dio>()));
  gh.factory<_i6.ScheduleRepository>(
      () => _i7.ScheduleRepositoryImpl(gh<_i5.ScheduleApi>()));
  gh.factory<_i8.SplashBloc>(() => _i8.SplashBloc());
  gh.factory<_i9.TestUiBloc>(() => _i9.TestUiBloc());
  gh.factory<_i10.TutorApi>(() => _i10.TutorApi(gh<_i4.Dio>()));
  gh.factory<_i11.TutorRepository>(
      () => _i12.TutorRepositoryImpl(gh<_i10.TutorApi>()));
  gh.factory<_i13.UserApi>(() => _i13.UserApi(gh<_i4.Dio>()));
  gh.factory<_i14.UserRepository>(
      () => _i15.UserRepositoriesImpl(gh<_i13.UserApi>()));
  gh.factory<_i16.AuthApi>(() => _i16.AuthApi(gh<_i4.Dio>()));
  gh.factory<_i17.AuthRepository>(
      () => _i18.AuthRepositoryImpl(gh<_i16.AuthApi>()));
  gh.factory<_i19.BookingUseCase>(() => _i19.BookingUseCase(
        gh<_i6.ScheduleRepository>(),
        gh<_i14.UserRepository>(),
      ));
  gh.factory<_i20.CommonApi>(() => _i20.CommonApi(gh<_i4.Dio>()));
  gh.factory<_i21.CommonRepository>(
      () => _i22.CommonRepositoryImpl(gh<_i20.CommonApi>()));
  gh.factory<_i23.CourseApi>(() => _i23.CourseApi(gh<_i4.Dio>()));
  gh.factory<_i24.CourseRepository>(
      () => _i25.CourseRepositoryImpl(gh<_i23.CourseApi>()));
  gh.factory<_i26.CourseUseCase>(
      () => _i26.CourseUseCase(gh<_i24.CourseRepository>()));
  gh.factory<_i27.HomeBloc>(
      () => _i27.HomeBloc(courseUseCase: gh<_i26.CourseUseCase>()));
  gh.factory<_i28.LoginUseCase>(
      () => _i28.LoginUseCase(gh<_i17.AuthRepository>()));
  gh.factory<_i29.MainUseCase>(() => _i29.MainUseCase(
        gh<_i11.TutorRepository>(),
        gh<_i24.CourseRepository>(),
        gh<_i21.CommonRepository>(),
      ));
  gh.factory<_i30.RattingUseCase>(
      () => _i30.RattingUseCase(gh<_i14.UserRepository>()));
  gh.factory<_i31.RegisterBloc>(
      () => _i31.RegisterBloc(login: gh<_i28.LoginUseCase>()));
  gh.factory<_i32.ResetPasswordUseCase>(
      () => _i32.ResetPasswordUseCase(gh<_i17.AuthRepository>()));
  gh.factory<_i33.ScheduleBloc>(
      () => _i33.ScheduleBloc(bookingUseCase: gh<_i19.BookingUseCase>()));
  gh.factory<_i34.SearchTutorUseCase>(() => _i34.SearchTutorUseCase(
        gh<_i21.CommonRepository>(),
        gh<_i11.TutorRepository>(),
      ));
  gh.factory<_i35.SettingUseCase>(
      () => _i35.SettingUseCase(gh<_i14.UserRepository>()));
  gh.factory<_i36.TutorDetailUseCase>(() => _i36.TutorDetailUseCase(
        gh<_i11.TutorRepository>(),
        gh<_i14.UserRepository>(),
      ));
  gh.factoryParam<_i37.TutorFeedbackBloc, String, dynamic>((
    userId,
    _,
  ) =>
      _i37.TutorFeedbackBloc(
        userId,
        tutorDetailUseCase: gh<_i36.TutorDetailUseCase>(),
      ));
  gh.factory<_i38.TutorListUseCase>(() => _i38.TutorListUseCase(
        gh<_i11.TutorRepository>(),
        gh<_i14.UserRepository>(),
        gh<_i6.ScheduleRepository>(),
      ));
  gh.factory<_i39.TutorScheduleUseCase>(() => _i39.TutorScheduleUseCase(
        gh<_i11.TutorRepository>(),
        gh<_i14.UserRepository>(),
      ));
  gh.factory<_i40.UserInfoUseCase>(() => _i40.UserInfoUseCase(
        gh<_i14.UserRepository>(),
        gh<_i21.CommonRepository>(),
      ));
  gh.factory<_i41.BecomeTutorUseCase>(() => _i41.BecomeTutorUseCase(
        gh<_i14.UserRepository>(),
        gh<_i21.CommonRepository>(),
      ));
  gh.factory<_i42.CourseDetailUseCase>(
      () => _i42.CourseDetailUseCase(gh<_i24.CourseRepository>()));
  gh.factory<_i43.LoginBloc>(
      () => _i43.LoginBloc(login: gh<_i28.LoginUseCase>()));
  gh.factory<_i44.MainBloc>(
      () => _i44.MainBloc(mainUseCase: gh<_i29.MainUseCase>()));
  gh.factory<_i45.ResetPasswordBloc>(() => _i45.ResetPasswordBloc(
      resetPasswordUseCase: gh<_i32.ResetPasswordUseCase>()));
  gh.factory<_i46.SettingBloc>(
      () => _i46.SettingBloc(gh<_i35.SettingUseCase>()));
  gh.factoryParam<_i47.TutorDetailBloc, String, dynamic>((
    userId,
    _,
  ) =>
      _i47.TutorDetailBloc(
        userId,
        tutorDetailUseCase: gh<_i36.TutorDetailUseCase>(),
      ));
  gh.factory<_i48.TutorListBloc>(
      () => _i48.TutorListBloc(tutorListUseCase: gh<_i38.TutorListUseCase>()));
  return getIt;
}

class _$DataSourceModule extends _i49.DataSourceModule {}

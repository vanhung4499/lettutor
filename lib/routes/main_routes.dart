import 'package:flutter/material.dart';
import 'package:lettutor/core/di/di.dart';
import 'package:lettutor/data/models/request/search_tutor_request.dart';
import 'package:lettutor/presentation/auth/blocs/login/login_bloc.dart';
import 'package:lettutor/presentation/auth/blocs/register/register_bloc.dart';
import 'package:lettutor/presentation/auth/blocs/reset_password/reset_password_bloc.dart';
import 'package:lettutor/presentation/auth/views/login_screen.dart';
import 'package:lettutor/presentation/auth/views/register_screen.dart';
import 'package:lettutor/presentation/auth/views/reset_password_screen.dart';
import 'package:lettutor/presentation/course_detail/blocs/course_detail_bloc.dart';
import 'package:lettutor/presentation/course_detail/views/course_detail_screen.dart';
import 'package:lettutor/presentation/course_detail/views/pdf_viewer_screen.dart';
import 'package:lettutor/presentation/course_list/blocs/home_bloc.dart';
import 'package:lettutor/presentation/course_list/views/course_list_screen.dart';
import 'package:lettutor/presentation/dashboard/blocs/dashboard_bloc.dart';
import 'package:lettutor/presentation/dashboard/views/dashboard_view.dart';
import 'package:lettutor/presentation/ebook/blocs/ebook_bloc.dart';
import 'package:lettutor/presentation/ebook/views/ebook_screen.dart';
import 'package:lettutor/presentation/splash/bloc/splash_bloc.dart';
import 'package:lettutor/presentation/splash/views/splash_screen.dart';
import 'package:lettutor/presentation/tutor_detail/blocs/tutor_detail_bloc.dart';
import 'package:lettutor/presentation/tutor_detail/views/tutor_detail_screen.dart';
import 'package:lettutor/presentation/tutor_feedback/blocs/tutor_feedback_bloc.dart';
import 'package:lettutor/presentation/tutor_feedback/views/tutor_feedback_screen.dart';
import 'package:lettutor/presentation/tutor_list/blocs/tutor_list_bloc.dart';
import 'package:lettutor/presentation/tutor_list/views/tutor_list_screen.dart';
import 'package:lettutor/presentation/tutor_search/blocs/tutor_search_bloc.dart';
import 'package:lettutor/presentation/tutor_search/blocs/tutor_search_result_bloc.dart';
import 'package:lettutor/presentation/tutor_search/views/tutor_search_result_screen.dart';
import 'package:lettutor/presentation/tutor_search/views/tutor_search_screen.dart';
import 'package:lettutor/presentation/user_profile/blocs/user_profile_bloc.dart';
import 'package:lettutor/presentation/user_profile/views/user_profile_screen.dart';
import 'package:lettutor/routes/routes.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';

class MainRoutes {
  static Map<String, WidgetBuilder> getRoutesWithSettings() {
    final routes = {Routes.login: (context) => const SizedBox()};
    return routes;
  }

  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<LoginBloc>(
            initBloc: (_) => injector.get(),
            child: const LoginScreen(),
          ),
        );
      case Routes.resetPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return BlocProvider<ResetPasswordBloc>(
              initBloc: (_) => injector.get<ResetPasswordBloc>(),
              child: const ResetPasswordScreen(),
            );
          },
        );
      case Routes.register:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return BlocProvider<RegisterBloc>(
              initBloc: (_) => injector.get<RegisterBloc>(),
              child: const RegisterScreen(),
            );
          },
        );

      case Routes.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<SplashBloc>(
            initBloc: (_) => SplashBloc(),
            child: const SplashScreen(),
          ),
        );

      case Routes.courseList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<CourseListBloc>(
            initBloc: (_) => injector.get(),
            child: const CourseListScreen(),
          ),
        );

      case Routes.dashboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<DashboardBloc>(
            initBloc: (_) => injector.get(),
            child: const DashboardView(),
          ),
        );

      case Routes.tutorList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<TutorListBloc>(
            initBloc: (_) => injector.get(),
            child: const TutorListScreen(),
          ),
        );

      case Routes.tutorSearch:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<TutorSearchBloc>(
            initBloc: (_) => injector.get(),
            child: const TutorSearchScreen(),
          ),
        );

      case Routes.tutorSearchResult:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            if (settings.arguments is SearchTutorRequest) {
              return BlocProvider<TutorSearchResultBloc>(
                initBloc: (_) => injector.get<TutorSearchResultBloc>(
                    param1: settings.arguments),
                child: const TutorSearchResultScreen(),
              );
            }
            return const SizedBox();
          },
        );

      case Routes.tutorDetail:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            if (settings.arguments is String) {
              return BlocProvider<TutorDetailBloc>(
                initBloc: (_) =>
                    injector.get<TutorDetailBloc>(param1: settings.arguments),
                child: const TutorDetailScreen(),
              );
            }
            return const SizedBox();
          },
        );

      case Routes.tutorFeedback:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            if (settings.arguments is String) {
              return BlocProvider<TutorFeedbackBloc>(
                initBloc: (_) =>
                    injector.get(param1: settings.arguments.toString()),
                child: const TutorFeedbackScreen(),
              );
            }
            return const SizedBox();
          },
        );

      case Routes.courseDetail:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            if (settings.arguments is String) {
              return BlocProvider<CourseDetailBloc>(
                initBloc: (_) =>
                    injector.get<CourseDetailBloc>(param1: settings.arguments),
                child: const CourseDetailScreen(),
              );
            }
            return const SizedBox();
          },
        );

      case Routes.ebook:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return BlocProvider<EbookBloc>(
              initBloc: (_) => injector.get(),
              child: const EbookScreen(),
            );
          },
        );

      case Routes.pdfViewer:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            if (settings.arguments is String) {
              return PdfViewerScreen(url: settings.arguments.toString());
            }
            return const SizedBox();
          },
        );

      case Routes.userProfile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return BlocProvider<UserProfileBloc>(
              initBloc: (_) => injector.get<UserProfileBloc>(),
              child: const UserProfileScreen(),
            );
          },
        );


      default:
        return unDefinedRoute();
    }
  }

  static Route unDefinedRoute([String message = 'Page not founds']) {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: Center(
            child: Text(message),
          ),
        );
      },
    );
  }
}

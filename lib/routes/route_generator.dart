import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster_empployee/bottomNavigation/mainPage.dart';
import 'package:rooster_empployee/routes/routes.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_bloc.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/presentation/upload_documents_page.dart';
import 'package:rooster_empployee/screens/calendar/bloc/calendar_bloc.dart';
import 'package:rooster_empployee/screens/calendar/presentation/calendarPage.dart';
import 'package:rooster_empployee/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:rooster_empployee/screens/dashboard/presentaion/dashboard_page.dart';
import 'package:rooster_empployee/screens/dashboard/repositary/dashboard_repositary.dart';
import 'package:rooster_empployee/screens/history/bloc/history_bloc.dart';
import 'package:rooster_empployee/screens/login/bloc/signIn_bloc.dart';
import 'package:rooster_empployee/screens/login/presentation/signIn.dart';
import 'package:rooster_empployee/screens/profile/bloc/profile_bloc.dart';
import 'package:rooster_empployee/screens/profile/presentation/profilePage.dart';
import 'package:rooster_empployee/screens/signUp/bloc/signup_bloc.dart';
import 'package:rooster_empployee/screens/signUp/models/signupRepositary.dart';
import 'package:rooster_empployee/screens/signUp/presenttaion/signupPage.dart';
import 'package:rooster_empployee/screens/splashScreen/splashScreen.dart';
import 'package:rooster_empployee/service/apiService.dart';

class RouteGenerator {
  // bloc initialization for pages
  final DashboardBloc _dashboardBloc =
      DashboardBloc(Dashboardrepository(ApiService(Dio())));

  final signInBloc _signInBloc = signInBloc(
      // signInrepository(ApiService(Dio()))
      );

  // bloc initialization for the signup page
  final SignupBloc _signupBloc =
      SignupBloc(Signuprepository(ApiService(Dio())));

  // bloc initilaization for profile page
  final ProfileBloc _profileBloc = ProfileBloc();

  final HistoryBloc _historyBloc = HistoryBloc();

  final CalendarBloc _calendarBloc = CalendarBloc();
  final UploadBloc _uploadBloc = UploadBloc();

  Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.SplashScreen:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );

      // case Routes.dashboard:
      // return PageRouteBuilder(
      //   transitionDuration: const Duration(milliseconds: 500),
      //   pageBuilder: (_, __, ___) {
      //      return MultiBlocProvider(
      //     providers: [
      //        BlocProvider<DashboardBloc>.value(
      //       value: _dashboardBloc,
      //     ),
      //     ],
      //     child: const DashboardPage(),
      //   );
      //   },
      //   transitionsBuilder: (_, animation, __, child) {
      //     return SlideTransition(
      //       position: Tween<Offset>(
      //         begin: const Offset(1.0, 0.0),
      //         end: Offset.zero,
      //       ).animate(animation),
      //       child: child,
      //     );});

      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(providers: [
            BlocProvider<signInBloc>.value(
              value: _signInBloc,
            ),
          ], child: const LoginPage()),
        );
      case Routes.calendar:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(providers: [
            BlocProvider<CalendarBloc>.value(
              value: _calendarBloc,
            ),
          ], child: const CalendarPage()),
        );

      case Routes.botomNav:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(providers: [
            BlocProvider<DashboardBloc>.value(
              value: _dashboardBloc,
            ),
            BlocProvider<HistoryBloc>.value(
              value: _historyBloc,
            ),
          ], child: MainPage()),
        );

      case Routes.signup:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(providers: [
            BlocProvider<SignupBloc>.value(
              value: _signupBloc,
            ),
          ], child: SignupPage()),
        );
      case Routes.uploadDocuments:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<UploadBloc>.value(
                value: _uploadBloc,
              ),
            ],
            child: const UploadDocumentsPage(),
          ),
        );

      case Routes.profilePage:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<ProfileBloc>.value(
                    value: _profileBloc,
                  ),
                ],
                child: ProfilePage(
                  userRole: args,
                )),
          );
        } else {
          return _errorRoute();
        }

      // case Routes.dashboard:
      // return PageRouteBuilder(
      //   transitionDuration: const Duration(milliseconds: 500),
      //   pageBuilder: (_, __, ___) {
      //     return MultiBlocProvider(
      //       providers: [
      //         // BlocProvider<DashboardBloc>.value(value: dashboardBloc),
      //         // // You can add more BlocProviders here as needed
      //       ],
      //       child: const DashboardPage(),
      //     );
      //   },);
      // return
      // MaterialPageRoute(
      //   builder: (_) => MultiBlocProvider(providers: [
      //     // BlocProvider<signInBloc>.value(
      //     //   value: _signInBloc,
      //     // ),
      //   ], child: const DashboardPage()),
      // );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR IN ROUTE NAVIGATION '),
        ),
      );
    });
  }
}

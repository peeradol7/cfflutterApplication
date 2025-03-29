import 'package:fam_care/view/calendar_page/calendar_page.dart';
import 'package:fam_care/view/disease/disease_detail_page.dart';
import 'package:fam_care/view/disease/display_disease_list.dart';
import 'package:fam_care/view/disease/select_disease_page.dart';
import 'package:fam_care/view/disease/summary_page.dart';
import 'package:fam_care/view/home_page/home_page.dart';
import 'package:fam_care/view/home_page/profile_page/profile_page.dart';
import 'package:fam_care/view/landing_page/langding_page.dart';
import 'package:fam_care/view/login_page/login_page.dart';
import 'package:fam_care/view/register_page/register_page.dart';
import 'package:fam_care/view/register_page/reset_password_page.dart';
import 'package:go_router/go_router.dart';

import 'view/survey/contraception_form_page.dart';

class AppRoutes {
  static const String landingPage = '/';
  static const String loginPage = '/loginPage';
  static const String registerpage = '/register';
  static const String loginEmailPasswordPage = '/login-email-page';
  static const String inputInformationPage = '/input-information';
  static const String homePage = '/homePage';
  static const String test = '/test';
  static const String resetPasswordPage = '/reset-password';
  static const String calendarPage = '/calendar';
  static const String profilePage = '/edit-profile';
  static const String selectDiseasePage = '/selectDiseasePage';
  static const String displayDiseaseList = '/displayDiseaseList';
  static const String diseaseDetail = '/diseaseDetail';
  static const String summaryPage = '/summary';
  static const String surveyPage = '/survey';

  static final GoRouter router = GoRouter(
    initialLocation: homePage,
    routes: [
      GoRoute(
        path: landingPage,
        builder: (context, state) => LandingPage(),
      ),
      // GoRoute(
      //   path: test,
      //   builder: (context, state) => SurveyForm(),
      // ),
      GoRoute(
        path: loginPage,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: registerpage,
        builder: (context, state) => RegisterPage(),
      ),
      GoRoute(
        path: homePage,
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: resetPasswordPage,
        builder: (context, state) => ResetPasswordPage(),
      ),

      GoRoute(
          path: calendarPage,
          builder: (context, state) {
            return CalendarPage();
          }),
      GoRoute(
        path: selectDiseasePage,
        builder: (context, state) => SelectDiseasePage(),
      ),
      GoRoute(
        path: displayDiseaseList,
        builder: (context, state) => DisplayDiseaseList(),
      ),
      GoRoute(
        path: summaryPage,
        builder: (context, state) => SummaryPage(),
      ),
      GoRoute(
        path: surveyPage,
        builder: (context, state) => ContraceptionFormPage(),
      ),
      GoRoute(
        path: '$diseaseDetail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return DiseaseDetailPage(id: id);
        },
      ),
      GoRoute(
        path: '$profilePage/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId'] ?? '';
          return ProfileEditPage(userId: userId);
        },
      ),
    ],
    debugLogDiagnostics: true,
    redirect: (context, state) {
      print('state.url ===> ${state.uri}');
      return null;
    },
  );
}

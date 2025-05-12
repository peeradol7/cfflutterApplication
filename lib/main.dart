import 'package:fam_care/constatnt/app_colors.dart';
import 'package:fam_care/controller/calendar_controller.dart';
import 'package:fam_care/controller/disease_controller.dart';
import 'package:fam_care/controller/email_auth_controller.dart';
import 'package:fam_care/controller/google_auth_controller.dart';
import 'package:fam_care/controller/health_controller.dart';
import 'package:fam_care/controller/knowledge_controller.dart';
import 'package:fam_care/controller/menu_bar_controller.dart';
import 'package:fam_care/controller/user_controller.dart';
import 'package:fam_care/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app_routes.dart';
import 'service/shared_prefercense_service.dart';

void main() async {
  await initializeDateFormatting('th', null);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPrefercenseService().instance();
  Get.put(DiseaseController());
  Get.put(MenuBarController());
  Get.put(GoogleAuthController());
  Get.put(UserController());
  Get.put(EmailAuthController());
  Get.put(CalendarController());
  Get.put(KnowledgeController());
  Get.put(HealthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoutes.router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
      ),
    );
  }
}

import 'package:fam_care/app_routes.dart';
import 'package:fam_care/controller/user_controller.dart';
import 'package:fam_care/service/shared_prefercense_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    Future<bool> checkUserData() async {
      final sharedPreferenceService = SharedPrefercenseService();
      final userData = await sharedPreferenceService.getUser();

      if (userData != null) {
        print("User ID: ${userData.userId}");
        context.go(AppRoutes.homePage);
        return true;
      }

      print("User not found.");
      return false;
    }

    return Scaffold(
      body: FutureBuilder<bool>(
        future: checkUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(color: Colors.amber),
                  child: Center(
                    child: Text('ใส่โลโก้แอป'),
                  ),
                ),
                const Text(
                  'Welcome to FamCare',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        context.push(AppRoutes.loginPage);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.person_add),
                      label: const Text(
                        'Create New Account',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                      ),
                      onPressed: () {
                        context.push(AppRoutes.registerpage);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:fam_care/app_routes.dart';
import 'package:fam_care/controller/user_controller.dart';
import 'package:fam_care/view/login_page/custom_button.dart';
import 'package:fam_care/view/login_page/widget/form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../controller/email_auth_controller.dart';
import '../../controller/google_auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  CustomButton customButton = CustomButton();
  final EmailAuthController emailController = Get.find<EmailAuthController>();
  final GoogleAuthController googleAuthController =
      Get.find<GoogleAuthController>();
  final UserController userController = Get.find<UserController>();

  Future<void> googleHandleLogin() async {
    if (userController.userData.value == null) {
      googleAuthController.isLoading.value = true;
      await googleAuthController.googleLoginController();
    }
    if (userController.userData.value != null) {
      context.go(AppRoutes.homePage);
    }
    googleAuthController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/logo-removeBG.png',
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              const Text(
                'กรุณาเข้าสู่ระบบเพื่อใช้งานแอปพลิเคชัน',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: emailController.formKey,
                child: FormWidget(),
              ),
              const SizedBox(height: 24),
              Obx(
                () => customButton.btnSignUp(
                  iconPath: 'assets/icons/google.png',
                  onPressed: googleAuthController.isLoading.value
                      ? null
                      : () {
                          googleHandleLogin();
                        },
                  label: googleAuthController.isLoading.value
                      ? 'กำลังเข้าสู่ระบบ...'
                      : 'เข้าสู่ระบบด้วย Google',
                ),
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'หรือ',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ยังไม่มีบัญชี?'),
                  TextButton(
                    onPressed: () {
                      context.push(AppRoutes.registerpage);
                    },
                    child: const Text('สมัครสมาชิก'),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:fam_care/app_routes.dart';
import 'package:fam_care/controller/email_auth_controller.dart';
import 'package:fam_care/model/users_model.dart';
import 'package:fam_care/view/register_page/widget/date_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../constatnt/app_colors.dart';
import '../register_page/widget/dialogs.dart';
import '../register_page/widget/email_field.dart';
import '../register_page/widget/name_field.dart';
import '../register_page/widget/password_field.dart';
import '../register_page/widget/register_button.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final EmailAuthController authController = Get.put(EmailAuthController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController periodDateController = TextEditingController();

  DateTime? _birthDate;
  DateTime? _periodDate;
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    birthDateController.text = "";
    periodDateController.text = "";
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (_birthDate == null) {
        showErrorDialog(context, "กรุณาเลือกวันเกิด");
        return;
      }

      UsersModel user = UsersModel(
        email: emailController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        password: passwordController.text.trim(),
        isServeyCompleted: false,
        birthDay: _birthDate,
        authMethod: 'email',
      );

      authController.emailSignUpController(user, context).then((_) {
        showSuccessDialog(context, () {
          context.go(AppRoutes.loginPage);
        });
      }).catchError((error) {
        showErrorDialog(context, error.toString());
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    birthDateController.dispose();
    periodDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'สมัครสมาชิก',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.background, AppColors.secondary]),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      "สร้างบัญชีใหม่",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  EmailField(controller: emailController),
                  SizedBox(height: 15),
                  NameFields(
                    firstNameController: firstNameController,
                    lastNameController: lastNameController,
                  ),
                  SizedBox(height: 15),
                  DateFields(
                    birthDateController: birthDateController,
                    periodDateController: periodDateController,
                    onBirthDateChanged: (date) {
                      setState(() => _birthDate = date);
                    },
                    onPeriodDateChanged: (date) {
                      setState(() => _periodDate = date);
                    },
                  ),
                  SizedBox(height: 15),
                  PasswordField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    onToggleVisibility: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  SizedBox(height: 30),
                  RegisterButton(
                    isLoading: authController.isLoading.value,
                    onPressed: _register,
                    color: AppColors.colorButton,
                  ),
                  SizedBox(height: 15),
                  _buildLoginRedirect(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('มีบัญชีอยู่แล้ว?'),
        TextButton(
          onPressed: () {
            context.go(AppRoutes.loginPage);
          },
          child: Text(
            'เข้าสู่ระบบ',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

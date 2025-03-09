import 'package:fam_care/app_routes.dart';
import 'package:fam_care/controller/user_controller.dart';
import 'package:fam_care/model/users_model.dart';
import 'package:fam_care/service/email_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class EmailAuthController extends GetxController {
  final EmailAuthService authService = EmailAuthService();
  final UserController userController = Get.put(UserController());
  final emailController = TextEditingController();
  var isLoading = false.obs;
  var userData = Rxn<UsersModel?>(null);

  Future<void> emailSignUpController(
      UsersModel userModel, BuildContext context) async {
    isLoading.value = true;
    try {
      User? userCredential = await authService.signUpWithEmail(userModel);
      if (userCredential != null) {
        Get.snackbar("สมัครสำเร็จ!", "กรุณายืนยันอีเมลก่อนเข้าสู่ระบบ");
      } else {
        _showErrorDialog(
            context, "การสมัครสมาชิกไม่สำเร็จ กรุณาลองใหม่อีกครั้ง");
      }
    } catch (e) {
      Get.snackbar("ผิดพลาด", e.toString());

      _showErrorDialog(
          context, _getReadableSignUpErrorMessage_SignUp(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    isLoading.value = true;
    try {
      User? userCredential = await authService.signIn(email, password);

      if (userCredential != null) {
        userController.fetchUserDataById(userCredential.uid);

        if (userController.userData.value != null) {
        } else {
          if (context.mounted) {
            _showErrorDialog(
                context, "ไม่สามารถดึงข้อมูลผู้ใช้งานได้ กรุณาลองใหม่อีกครั้ง");
            return;
          }
        }

        if (context.mounted) {
          context.go(AppRoutes.homePage);
        }
      } else {
        if (context.mounted) {
          _showErrorDialog(
              context, "ล็อกอินไม่สำเร็จ กรุณาตรวจสอบอีเมลและรหัสผ่าน");
        }
      }
    } catch (e) {
      if (context.mounted) {
        String errorMessage = _getReadableErrorMessage_Login(e.toString());
        _showErrorDialog(context, errorMessage);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("แจ้งเตือน"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("ตกลง"),
            ),
          ],
        );
      },
    );
  }

  String _getReadableErrorMessage_Login(String errorMessage) {
    if (errorMessage.contains("กรุณายืนยันอีเมล") || errorMessage.contains("email verification")) {
      return "กรุณายืนยันอีเมลก่อนเข้าสู่ระบบ";
    } else if (errorMessage.contains("wrong-password")) {
      return "รหัสผ่านไม่ถูกต้อง";
    } else if (errorMessage.contains("user-not-found")) {
      return "ไม่พบบัญชีผู้ใช้นี้ในระบบ";
    } else if (errorMessage.contains("invalid-email")) {
      return "รูปแบบอีเมลไม่ถูกต้อง";
    } else if (errorMessage.contains("user-disabled")) {
      return "บัญชีนี้ถูกระงับการใช้งาน";
    } else if (errorMessage.contains("too-many-requests")) {
      return "มีการลองเข้าสู่ระบบหลายครั้งเกินไป กรุณาลองใหม่ภายหลัง";
    } else if (errorMessage.contains("network-request-failed")) {
      return "เกิดปัญหาการเชื่อมต่อเครือข่าย";
    } else {
      return "เกิดข้อผิดพลาด: $errorMessage";
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("ข้อผิดพลาด", "กรุณากรอกอีเมล",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    String? errorMessage = await authService.resetPassword(email);

    if (errorMessage == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("สำเร็จ!"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email_outlined, size: 50, color: Colors.blue),
                SizedBox(height: 10),
                Text("กรุณาตรวจสอบอีเมลของคุณ\nเพื่อทำการรีเซ็ตรหัสผ่าน"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  emailController.clear();
                  context.push(AppRoutes.landingPage);
                },
                child: Text("ตกลง"),
              ),
            ],
          );
        },
      );
    } else {
      Get.snackbar("เกิดข้อผิดพลาด", errorMessage,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ฟังก์ชันสำหรับแปล error message ของการสมัครสมาชิกให้อ่านง่ายขึ้น
  String _getReadableSignUpErrorMessage_SignUp(String errorMessage) {
    if (errorMessage.contains("email-already-in-use")) {
      return "อีเมลนี้ถูกใช้งานแล้ว กรุณาใช้อีเมลอื่น";
    } else if (errorMessage.contains("invalid-email")) {
      return "รูปแบบอีเมลไม่ถูกต้อง";
    } else if (errorMessage.contains("operation-not-allowed")) {
      return "การลงทะเบียนด้วยอีเมลถูกปิดใช้งาน";
    } else if (errorMessage.contains("weak-password")) {
      return "รหัสผ่านไม่ปลอดภัยเพียงพอ กรุณาใช้รหัสผ่านที่ยากขึ้น";
    } else if (errorMessage.contains("network-request-failed")) {
      return "เกิดปัญหาการเชื่อมต่อเครือข่าย";
    } else {
      return "เกิดข้อผิดพลาดในการสมัครสมาชิก: $errorMessage";
    }
  }
}

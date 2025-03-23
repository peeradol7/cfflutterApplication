import 'package:fam_care/controller/user_controller.dart';
import 'package:fam_care/service/shared_prefercense_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../app_routes.dart';
import '../../../constatnt/app_colors.dart';

class LogoutDialogWidget extends StatelessWidget {
  LogoutDialogWidget({super.key});
  final UserController userController = Get.find<UserController>();
  final prefs = SharedPrefercenseService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'ต้องการออกจากระบบ?',
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.logout_rounded,
            size: 50,
            color: AppColors.primary,
          ),
          SizedBox(height: 16),
          Text(
            'คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.color5,
            ),
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => context.pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.color5,
              ),
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                userController.signOut(context);
                prefs.removeUser();
                context.go(AppRoutes.landingPage);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('ออกจากระบบ'),
            ),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

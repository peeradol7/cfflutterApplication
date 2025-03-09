import 'package:fam_care/controller/facebook_auth_controller.dart';
import 'package:fam_care/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../app_routes.dart';

class LogoutDialogWidget extends StatelessWidget {
  LogoutDialogWidget({super.key});
  final UserController userController = Get.find<UserController>();
  final FacebookAuthController facebookAuthController =
      Get.put(FacebookAuthController());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Logout '),
      actions: [
        Column(
          children: [
            TextButton(
              onPressed: () {
                userController.signOut(context);
                facebookAuthController.signOut();
                context.go(AppRoutes.landingPage);
              },
              child: Text('ออกจากระบบ'),
            ),
          ],
        )
      ],
    );
  }
}

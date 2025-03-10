import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../app_routes.dart';
import '../../../controller/email_auth_controller.dart';

class FormWidget extends StatelessWidget {
  FormWidget({super.key});
  final EmailAuthController controller = Get.find<EmailAuthController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller.emailController,
          decoration: const InputDecoration(
            labelText: 'อีเมล',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกอีเมล';
            }
            if (!GetUtils.isEmail(value)) {
              return 'กรุณากรอกอีเมลให้ถูกต้อง';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.passwordController,
          decoration: const InputDecoration(
            labelText: 'รหัสผ่าน',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกรหัสผ่าน';
            }
            if (value.length < 6) {
              return 'รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              context.push(AppRoutes.resetPasswordPage);
            },
            child: const Text('ลืมรหัสผ่าน?'),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () async {
                    if (controller.formKey.currentState!.validate()) {
                      await controller.signIn(
                        controller.emailController.text,
                        controller.passwordController.text,
                        context,
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'เข้าสู่ระบบด้วยอีเมล',
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        )
      ],
    );
  }
}

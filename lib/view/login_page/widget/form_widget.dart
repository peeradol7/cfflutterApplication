import 'package:fam_care/constatnt/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../app_routes.dart';
import '../../../controller/email_auth_controller.dart';
import '../../../controller/user_controller.dart';
import '../custom_button.dart';

class FormWidget extends StatelessWidget {
  FormWidget({super.key});

  final EmailAuthController controller = Get.find<EmailAuthController>();
  final UserController userController = Get.find<UserController>();
  final CustomButton customButton = CustomButton();
  final RxBool isChecked = false.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email Field
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

        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  showConsentDialog(
                    context,
                    () {
                      userController.isApprove.value = true;
                    },
                    () {
                      userController.isApprove.value = false;
                    },
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: 'อ่านข้อตกลงการเก็บข้อมูล',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        Obx(() => customButton.btnSignUp(
              isEnabled: userController.isApprove.value,
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
              label: controller.isLoading.value
                  ? 'กำลังเข้าสู่ระบบ...'
                  : 'เข้าสู่ระบบด้วยอีเมล',
            )),
      ],
    );
  }

  void showConsentDialog(
      BuildContext context, VoidCallback onAgree, VoidCallback onDisagree) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 5,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Text(
                  'ขอความยินยอมในการเก็บข้อมูล',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'แอปพลิเคชัน FamCare ขออนุญาติเก็บข้อมูลการใช้งาน การตอบแบบสอบถาม และข้อมูลพื้นฐานบางส่วน '
                  'เพื่อศึกษาพฤติกรรมการเลือกวิธีคุมกำเนิดตามเงื่อนไขสุขภาพของแต่ละบุคคล เพื่อพัฒนาเทคโนโลยีที่ตอบสนองผู้ใช้งาน '
                  'ข้อมูลที่เก็บจะถูกนำมาใช้เพื่อวัตถุประสงค์ทางการศึกษาและวิจัยในการทดลองใช้แอปพลิเคชัน FamCare แบบ prototype เท่านั้น '
                  'จะไม่มีการเปิดเผยข้อมูลส่วนบุคคลของท่านต่อบุคคลภายนอก '
                  'ข้อมูลที่รวบรวมจะถูกใช้เพื่อวัตถุประสงค์ทางการวิจัยเท่านั้น และอาจนำเสนอในรูปแบบรายงานสรุป ผลการวิเคราะห์เชิงสถิติ หรือบทความวิชาการ '
                  'โดยจะไม่มีการเปิดเผยข้อมูลส่วนบุคคลที่สามารถระบุตัวตนของท่านได้ '
                  'ข้อมูลทั้งหมดจะถูกจัดเก็บอย่างปลอดภัยในระบบฐานข้อมูลที่มีการเข้ารหัส และสามารถเข้าถึงได้เฉพาะผู้วิจัยและทีมงานที่ได้รับอนุญาตเท่านั้น '
                  'ทั้งนี้ข้อมูลจะถูกเก็บเป็นระยะเวลา 1 ปีก่อนถูกลบอย่างถาวร '
                  'ท่านสามารถถอนตัวจากการวิจัยเมื่อใดก็ได้โดยไม่เสียสิทธิ์ในการใช้งานแอป',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Checkbox(
                          value: isChecked.value,
                          onChanged: (value) {
                            isChecked.value = value!;
                          },
                        )),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'ข้าพเจ้ายินยอมให้แอปพลิเคชัน FamCare เก็บและใช้ข้อมูลสุขภาพของข้าพเจ้าเพื่อวัตถุประสงค์ที่ระบุไว้ข้างต้น',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.background,
                              side: const BorderSide(
                                color: AppColors.primary,
                                width: 1,
                              ),
                            ),
                            onPressed: isChecked.value == false
                                ? null
                                : () {
                                    Navigator.pop(context);
                                    onAgree();
                                  },
                            child: const Text(
                              'ยินยอม',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onDisagree();
                            },
                            child: const Text(
                              'ไม่ยินยอม',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

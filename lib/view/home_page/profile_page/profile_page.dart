import 'package:fam_care/controller/user_controller.dart';
import 'package:fam_care/view/home_page/profile_page/widget/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constatnt/app_colors.dart';

class ProfileEditPage extends StatefulWidget {
  final String userId;

  ProfileEditPage({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final UserController userController = Get.find<UserController>();
  final TextfieldWidget textfieldWidget = TextfieldWidget();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.fetchUserDataById(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูลส่วนตัว'),
        backgroundColor: AppColors.secondary,
      ),
      body: GetBuilder<UserController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.userData.value == null) {
            return const Center(child: Text('ไม่พบข้อมูลผู้ใช้'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textfieldWidget.buildTextField(
                      controller.firstNameController, 'ชื่อ', 'โปรดกรอกชื่อ'),
                  const SizedBox(height: 16),
                  textfieldWidget.buildTextField(controller.lastNameController,
                      'นามสกุล', 'โปรดกรอกนามสกุล'),
                  const SizedBox(height: 16),
                  textfieldWidget.buildDateField(
                    context,
                    'วันเกิด',
                    controller.birthDateController,
                    controller.birthDate.value,
                    (pickedDate) => controller.updateBirthDate(pickedDate),
                  ),
                  const SizedBox(height: 16),
                  textfieldWidget.buildDateField(
                    context,
                    'วันที่มีประจำเดือน',
                    controller.periodDateController,
                    controller.periodDate.value,
                    (pickedDate) => controller.updatePeriodDate(pickedDate),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.color5,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: controller.isSaving.value
                          ? null
                          : () async {
                              if (await controller.saveUserData(
                                  widget.userId, '')) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('บันทึกข้อมูลสำเร็จ')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'เกิดข้อผิดพลาด โปรดลองอีกครั้ง')),
                                );
                              }
                            },
                      child: controller.isSaving.value
                          ? const CircularProgressIndicator()
                          : const Text('บันทึกข้อมูล',
                              style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

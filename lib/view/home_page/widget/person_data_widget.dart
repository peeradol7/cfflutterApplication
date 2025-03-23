import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../app_routes.dart';
import '../../../constatnt/app_colors.dart';
import '../../../controller/user_controller.dart';

class PersonDataWidget extends StatelessWidget {
  PersonDataWidget({super.key});
  final UserController _controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        );
      }

      final user = _controller.userData.value;
      if (user == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_off_rounded,
                size: 48,
                color: AppColors.color3,
              ),
              SizedBox(height: 12),
              Text(
                'ไม่พบข้อมูลผู้ใช้ กรุณาเข้าสู่ระบบอีกครั้ง',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.color5,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          _buildInfoRow(
            icon: Icons.email_rounded,
            title: 'อีเมล',
            value: user.email ?? 'ไม่ระบุ',
            iconColor: AppColors.primary,
          ),
          Divider(height: 24, color: AppColors.color8),
          _buildInfoRow(
            icon: Icons.person_rounded,
            title: 'ชื่อ-นามสกุล',
            value: '${user.firstName ?? ''} ${user.lastName ?? ''}',
            iconColor: AppColors.color3,
          ),
          Divider(height: 24, color: AppColors.color8),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.cake_rounded,
                  color: AppColors.secondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'อายุ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.color5,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      user.birthDay != null
                          ? '${_controller.calculateAge(user.birthDay!)} ปี'
                          : 'ไม่ระบุ',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  color: AppColors.primary,
                  onPressed: () {
                    final route = AppRoutes.profilePage;
                    final userId = user.userId;
                    context.push('$route/$userId');
                  },
                  icon: const Icon(Icons.edit_rounded),
                  tooltip: 'แก้ไขข้อมูลส่วนตัว',
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.color5,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

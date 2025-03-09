import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../app_routes.dart';
import '../../../controller/user_controller.dart';

class PersonDataWidget extends StatelessWidget {
  PersonDataWidget({super.key});
  final UserController _controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final user = _controller.userData.value;
      if (user == null) {
        return const Center(
          child: Text(
            'ไม่พบข้อมูลผู้ใช้ กรุณาเข้าสู่ระบบอีกครั้ง',
            style: TextStyle(fontSize: 16),
          ),
        );
      }

      return Column(
        children: [
          Row(
            children: [
              const Icon(Icons.email),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('อีเมล',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(user.email ?? 'ไม่ระบุ'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.person),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ชื่อ-นามสกุล',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${user.firstName ?? ''} ${user.lastName ?? ''}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.brightness_1_rounded),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'อายุ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(user.birthDay != null
                        ? '${_controller.calculateAge(user.birthDay!)} ปี'
                        : 'ไม่ระบุ'),
                  ],
                ),
              ),
              IconButton(
                color: Colors.black,
                onPressed: () {
                  final route = AppRoutes.profilePage;
                  final userId = user.userId;
                  context.push('$route/$userId');
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
        ],
      );
    });
  }
}

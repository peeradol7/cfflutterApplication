import 'package:fam_care/constatnt/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../service/shared_prefercense_service.dart';

class HealthController extends GetxController {
  RxList<String> selectedMoods = <String>[].obs;
  RxList<String> selectedSymptoms = <String>[].obs;
  RxList<String> selectedBehaviors = <String>[].obs;
  RxList<String> selectedDischarge = <String>[].obs;
  RxList<String> selectedSexualActivity = <String>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPrefercenseService().instance();

    selectedMoods.value = prefs.getStringList('health-moods') ?? [];
    selectedSymptoms.value = prefs.getStringList('health-symptoms') ?? [];
    selectedBehaviors.value = prefs.getStringList('health-behaviors') ?? [];
    selectedDischarge.value = prefs.getStringList('health-discharge') ?? [];
    selectedSexualActivity.value =
        prefs.getStringList('health-sexualActivity') ?? [];

    isLoading.value = false;
  }

  Future<void> clearData() async {
    final prefs = await SharedPrefercenseService().instance();
    await prefs.remove('health-moods');
    await prefs.remove('health-symptoms');
    await prefs.remove('health-behaviors');
    await prefs.remove('health-discharge');
    await prefs.remove('health-sexualActivity');
  }

  Future<void> saveData(BuildContext context) async {
    try {
      final prefs = await SharedPrefercenseService().instance();
      await clearData();

      await prefs.setStringList('health-moods', selectedMoods.toList());
      await prefs.setStringList('health-symptoms', selectedSymptoms.toList());
      await prefs.setStringList('health-behaviors', selectedBehaviors.toList());
      await prefs.setStringList('health-discharge', selectedDischarge.toList());
      await prefs.setStringList(
          'health-sexualActivity', selectedSexualActivity.toList());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บันทึกข้อมูลเรียบร้อยแล้ว'),
          backgroundColor: AppColors.color5,
        ),
      );
      loadData();
      Future.delayed(const Duration(seconds: 1), () {
        context.pop();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

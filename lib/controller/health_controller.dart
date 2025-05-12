import 'package:fam_care/model/health_model.dart';
import 'package:fam_care/service/health_service.dart';
import 'package:fam_care/view/widget/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../service/shared_prefercense_service.dart';

class HealthController extends GetxController {
  final service = HealthService();
  RxList<String> selectedMoods = <String>[].obs;
  RxList<String> selectedSymptoms = <String>[].obs;
  RxList<String> selectedBehaviors = <String>[].obs;
  RxList<String> selectedDischarge = <String>[].obs;
  RxList<String> selectedSexualActivity = <String>[].obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  RxList<HealthModel> healthData = <HealthModel>[].obs;
  var healthDataDetail = Rxn<HealthModel>();

  RxBool isLoading = true.obs;
  Rx<DateTime> date = DateTime.now().obs;
  final pref = SharedPrefercenseService();

  Future<void> fetchHealthData() async {
    try {
      isLoading(true);
      final userId = await pref.getUserId();
      final data = await service.fetchHealthData(userId!);

      healthData.value = data;
    } catch (e) {
      print('Error fetching health data: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchHealthDataByDate(String healthId) async {
    try {
      isLoading(true);
      final data = await service.getDataById(healthId);

      healthDataDetail.value = data;
    } catch (e) {
      print('Error fetching health data: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteHealthData(String healthId) async {
    try {
      isLoading(true);
      await service.deleteHealthData(healthId);
    } catch (e) {
      print('Error deleting health data: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateHealthData(String id, BuildContext ct) async {
    try {
      isLoading(true);
      final isUpdate = await service.updateHealthData(
        healthId: id,
        selectedMoods: selectedMoods,
        selectedSymptoms: selectedSymptoms,
        selectedBehaviors: selectedBehaviors,
        selectedDischarge: selectedDischarge,
        selectedSexualActivity: selectedSexualActivity,
        date: DateFormat('yyyy-MM-dd').format(selectedDate.value),
      );
      if (isUpdate == false) {
        AppSnackbar.error(
            ct, 'ไม่สามารถอัพเดทข้อมูลได้เนื่องจากมีข้อมูลในวันนี้แล้ว');
        return;
      }
      AppSnackbar.success(ct, 'อัพเดทข้อมูลเรียบร้อยแล้ว');

      await fetchHealthDataByDate(id);
      await fetchHealthData();
    } catch (e) {
      print('Error updating health data: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<bool> saveData(BuildContext context) async {
    try {
      final userId = await pref.getUserId();

      final model = HealthModel(
        userId: userId!,
        date: DateFormat('yyyy-MM-dd').format(selectedDate.value),
        selectedMoods: selectedMoods,
        selectedSymptoms: selectedSymptoms,
        selectedBehaviors: selectedBehaviors,
        selectedDischarge: selectedDischarge,
        sexualActivity: selectedSexualActivity,
      );

      final isSave = await service.saveHealthData(model);

      if (isSave == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('ไม่สามารถบันทึกข้อมูลได้เนื่องจากมีข้อมูลในวันนี้แล้ว'),
            backgroundColor: Colors.redAccent,
          ),
        );

        return false;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บันทึกข้อมูลเรียบร้อยแล้ว'),
          backgroundColor: Colors.green,
        ),
      );
      await fetchHealthData();
      await service.fetchHealthData(userId);

      clear();
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  void clear() {
    selectedMoods.clear();
    selectedSymptoms.clear();
    selectedBehaviors.clear();
    selectedDischarge.clear();
    selectedSexualActivity.clear();
  }
}

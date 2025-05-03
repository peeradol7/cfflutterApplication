import 'package:fam_care/constatnt/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../constatnt/health_option_constants.dart';
import '../../controller/health_controller.dart';

class HealthOptionPage extends StatefulWidget {
  const HealthOptionPage({Key? key}) : super(key: key);

  @override
  _HealthOptionPageState createState() => _HealthOptionPageState();
}

class _HealthOptionPageState extends State<HealthOptionPage> {
  final controller = Get.find<HealthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('บันทึกข้อมูลสุขภาพ',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('อารมณ์'),
              _buildSelectionGrid(
                  HealthOptionConstants.mood, controller.selectedMoods),
              _buildSectionHeader('อาการ'),
              _buildSelectionGrid(
                  HealthOptionConstants.symptom, controller.selectedSymptoms),
              _buildSectionHeader('พฤติกรรมที่เปลี่ยนไป'),
              _buildSelectionGrid(HealthOptionConstants.behaviorChanges,
                  controller.selectedBehaviors),
              _buildSectionHeader('อาการตกขาว'),
              _buildSelectionGrid(HealthOptionConstants.dischargeSymptoms,
                  controller.selectedDischarge),
              _buildSectionHeader('เพศสัมพันธ์'),
              _buildSelectionGrid(
                HealthOptionConstants.sexualActivity,
                controller.selectedSexualActivity,
              ),
              const SizedBox(height: 30),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity, // ทำให้ปุ่มกว้างสุดเท่ากับหน้าจอ
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20), // เพิ่มความสูง
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        controller.saveData(context);
                      },
                      child: const Text(
                        'บันทึก',
                        style: TextStyle(fontSize: 18), // ปรับขนาดตัวอักษร
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );

  Widget _buildSelectionGrid(
      List<String> options, RxList<String> selectedOptions,
      {bool exclusive = false}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => Wrap(
              spacing: 8.0,
              children: options.map((option) {
                final isSelected = selectedOptions.contains(option);
                return FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (exclusive) {
                      selectedOptions.clear();
                      if (selected) selectedOptions.add(option);
                    } else {
                      selected
                          ? selectedOptions.add(option)
                          : selectedOptions.remove(option);
                    }
                  },
                );
              }).toList(),
            )),
      ),
    );
  }
}

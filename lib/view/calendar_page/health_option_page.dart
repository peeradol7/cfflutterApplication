import 'package:fam_care/constatnt/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../constatnt/health_option_constants.dart';
import '../../controller/health_controller.dart';

// ignore: must_be_immutable
class HealthOptionPage extends StatefulWidget {
  String? id;
  HealthOptionPage({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  _HealthOptionPageState createState() => _HealthOptionPageState();
}

class _HealthOptionPageState extends State<HealthOptionPage> {
  final controller = Get.find<HealthController>();

  Future<void> _showDatePicker() async {
    final DateTime now = DateTime.now();

    DateTime initialDate = controller.selectedDate.value;
    if (initialDate.isAfter(now)) {
      initialDate = now;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: now, // ใช้วันที่ปัจจุบันเป็นวันสุดท้ายที่เลือกได้
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != controller.selectedDate.value) {
      controller.selectedDate.value = picked;
      print('Selected date: ${controller.selectedDate.value}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
            widget.id == null || widget.id!.isEmpty
                ? 'บันทึกข้อมูลสุขภาพ'
                : 'แก้ไขข้อมูลสุขภาพ',
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
              // เพิ่มส่วนเลือกวันที่
              _buildSectionHeader('เลือกวันที่'),
              _buildDatePickerButton(),

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
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        widget.id == null || widget.id!.isEmpty
                            ? controller.saveData(context)
                            : controller.updateHealthData(widget.id!, context);
                      },
                      child: const Text(
                        'บันทึก',
                        style: TextStyle(fontSize: 18),
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

  // Widget สำหรับปุ่มเลือกวันที่
  Widget _buildDatePickerButton() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: _showDatePicker,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('dd MMMM yyyy', 'th').format(
                        controller.selectedDate.value,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Icon(Icons.arrow_drop_down, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
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

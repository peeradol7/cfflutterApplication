import 'package:fam_care/controller/health_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../app_routes.dart';
import '../../constatnt/app_colors.dart';

class HealthDataPage extends StatefulWidget {
  const HealthDataPage({Key? key}) : super(key: key);

  @override
  _HealthDataPageState createState() => _HealthDataPageState();
}

class _HealthDataPageState extends State<HealthDataPage> {
  final controller = Get.find<HealthController>();

  @override
  void initState() {
    super.initState();
    controller.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลสุขภาพของคุณ',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategorySection('อารมณ์', controller.selectedMoods),
                      _buildCategorySection(
                          'อาการ', controller.selectedSymptoms),
                      _buildCategorySection(
                          'พฤติกรรมที่เปลี่ยนไป', controller.selectedBehaviors),
                      _buildCategorySection(
                          'อาการตกขาว', controller.selectedDischarge),
                      _buildCategorySection(
                          'เพศสัมพันธ์', controller.selectedSexualActivity),
                    ],
                  )),
            ),
          ),
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
                    context.push(AppRoutes.healthOption);
                  },
                  child: const Text(
                    'ประเมินสุขภาพ',
                    style: TextStyle(fontSize: 18), // ปรับขนาดตัวอักษร
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<String> items) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 12),
                const Text('ไม่มีข้อมูล', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: items.map((item) {
                  return Chip(
                    label: Text(item),
                    backgroundColor: Colors.teal.withOpacity(0.1),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

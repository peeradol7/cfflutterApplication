import 'package:fam_care/app_routes.dart';
import 'package:fam_care/constatnt/app_colors.dart';
import 'package:fam_care/view/disease/widget/disease_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../controller/disease_controller.dart';

class SelectDiseasePage extends StatefulWidget {
  const SelectDiseasePage({super.key});

  @override
  _SelectDiseasePageState createState() => _SelectDiseasePageState();
}

class _SelectDiseasePageState extends State<SelectDiseasePage> {
  final DiseaseController diseaseController = Get.find<DiseaseController>();

  final Color primaryPurple = Color(0xFF6A1B9A);
  final Color lightPurple = Color(0xFF9C4DCC);
  final Color darkPurple = Color(0xFF4A148C);
  final Color accentPurple = Color(0xFFE1BEE7);

  @override
  void initState() {
    super.initState();
    diseaseController.loadSavedDiseases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เพิ่มโรคประจำตัว"),
        backgroundColor: AppColors.color5,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [accentPurple.withOpacity(0.3), Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: lightPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: lightPurple.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      color: darkPurple,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "โรคที่เลือก",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkPurple,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Obx(
                () => diseaseController.selectedDiseases.isEmpty
                    ? Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 40,
                            horizontal: 20,
                          ),
                          margin: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.health_and_safety_outlined,
                                size: 60,
                                color: lightPurple.withOpacity(0.5),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "กรุณากดปุ่ม \"เพิ่มโรค\"",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.all(8),
                            itemCount:
                                diseaseController.savedRecommendations.length,
                            itemBuilder: (context, index) {
                              final recommendation =
                                  diseaseController.savedRecommendations[index];
                              return Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 2),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: lightPurple.withOpacity(0.2)),
                                ),
                                child: DiseaseDetailCard(
                                  recommendation: recommendation,
                                  onRemove: () =>
                                      diseaseController.removeDisease(
                                          recommendation.diseaseType),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 20),
              Obx(() => ElevatedButton.icon(
                    onPressed: diseaseController.selectedDiseases.length >= 4
                        ? null
                        : () async {
                            final result = await context
                                .push(AppRoutes.displayDiseaseList);
                            if (result != null && result is String) {
                              if (!diseaseController.selectedDiseases
                                  .contains(result)) {
                                diseaseController.selectedDiseases.add(result);
                              }
                            }
                          },
                    label: Text(
                      diseaseController.selectedDiseases.length >= 4
                          ? "เพิ่มได้สูงสุด 4 โรค"
                          : "เพิ่มโรค",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.color5,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: Colors.grey[400],
                    ),
                  )),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    context.push(AppRoutes.summaryPage);
                  },
                  icon: Icon(Icons.table_chart_outlined),
                  label: Text(
                    'แสดงตารางคุมกำเนิด',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: accentPurple.withOpacity(0.2),
                    foregroundColor: darkPurple,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: lightPurple),
                    ),
                  ),
                ),
              ),
              Obx(() => diseaseController.selectedDiseases.length >= 4
                  ? Container(
                      margin: EdgeInsets.only(top: 16),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.amber[700]),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "คุณเพิ่มโรคครบจำนวนสูงสุด (4 โรค) แล้ว",
                              style: TextStyle(color: Colors.amber[900]),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}

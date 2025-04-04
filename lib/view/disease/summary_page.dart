import 'package:fam_care/constatnt/title_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../app_routes.dart';
import '../../controller/summary_controller.dart';

class SummaryPage extends StatelessWidget {
  final SummaryController controller = Get.find<SummaryController>();

  SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("สรุปผลการเลือกวิธีการคุมกำเนิด"),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go(AppRoutes.homePage),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildConditionDetailCard(),
              const SizedBox(height: 24),
              _buildMethodSummaryCard(),
              const SizedBox(height: 24),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodSummaryCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "สรุปวิธีการคุมกำเนิด",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Obx(() => Table(
                  border: TableBorder.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(2),
                  },
                  children: [
                    _buildTableRow(
                      "วิธีที่ปลอดภัยสำหรับคุณ",
                      controller.selectedSafeMethod.value,
                      isHeader: true,
                      textColor: Colors.green,
                    ),
                    _buildTableRow(
                      "วิธีที่คุณสนใจ",
                      controller.selectedPreferredMethod.value,
                      textColor: Colors.blue,
                    ),
                  ],
                )),
            const SizedBox(height: 16),
            const Text(
              "คำอธิบายหมวดหมู่",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildCategoryExplanation(
                "หมวด 1", "ใช้วิธีนี้ได้ทุกกรณี", Colors.green.shade100),
            _buildCategoryExplanation(
                "หมวด 2",
                "ใช้วิธีนี้ได้โดยทั่วไป (หากใช้ได้ทั้งวิธีในหมวด 1 และ 2 ให้เลือกใช้หมวด 1 ก่อน)",
                Colors.blue.shade100),
            _buildCategoryExplanation(
                "หมวด 3",
                "ไม่ควรใช้วิธีนี้ ยกเว้นไม่สามารถจัดหาวิธีที่เหมาะสมกว่านี้ ใช้ได้ภายใต้ข้อพิจารณาของบุคลากรทางการแพทย์",
                Colors.orange.shade100),
            _buildCategoryExplanation(
                "หมวด 4", "ห้ามใช้วิธีนี้", Colors.red.shade100),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionDetailCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "รายละเอียดตามเงื่อนไขส่วนตัว",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Obx(() {
              Map<String, List<String>> uniqueDiseaseAttributes =
                  controller.getUniqueDiseaseAttributes();
              Map<String, Map<String, dynamic>> methodValues =
                  controller.getMethodValues();
              List<Widget> conditionWidgets = [];

              // เพิ่มหมายเหตุ
              conditionWidgets.add(
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    border: Border.all(color: Colors.yellow.shade800),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "หมายเหตุ: ทุกวิธีแนะนำให้ใช้ร่วมกับถุงยางอนามัยสำหรับผู้ชายหรือผู้หญิง เพื่อป้องกันโรคติดต่อทางเพศสัมพันธ์/เชื้อเอชไอวี",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
              );

              int conditionIndex = 1;
              uniqueDiseaseAttributes.forEach((diseaseType, attributes) {
                for (var attribute in attributes) {
                  String key = "$diseaseType-$attribute";

                  conditionWidgets.add(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "เงื่อนไขที่ $conditionIndex:$diseaseType \n$attribute",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Table(
                          border: TableBorder.all(color: Colors.grey.shade300),
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(1),
                          },
                          children: _buildMethodCategoryRows(key, methodValues),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                  conditionIndex++;
                }
              });

              return Column(children: conditionWidgets);
            }),
          ],
        ),
      ),
    );
  }

  List<TableRow> _buildMethodCategoryRows(
      String conditionKey, Map<String, Map<String, dynamic>> methodValues) {
    List<TableRow> rows = [];
    Map<String, dynamic>? conditionData = methodValues[conditionKey];

    if (conditionData == null) {
      return [
        TableRow(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("ไม่มีข้อมูล"),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("-"),
            ),
          ],
        ),
      ];
    }

    rows.add(TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("วิธีการคุมกำเนิด",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("หมวด", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    ));

    for (int i = 0; i < ContentConstants.keys.length; i++) {
      var methodKey = ContentConstants.keys[i];
      var methodTitle = ContentConstants.contraceptiveTitles[i];
      var category = conditionData[methodKey];

      if (category.toString().contains("4")) {
        continue;
      }
      if (category.toString().contains("3")) {
        continue;
      }

      Color textColor = Colors.black;
      if (category.toString().contains("1")) {
        textColor = Colors.green;
      } else if (category.toString().contains("2")) {
        textColor = Colors.blue;
      }

      rows.add(TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(methodTitle),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              category.toString(),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ));
    }

    return rows;
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: const Icon(
            Icons.save,
            color: Colors.white,
          ),
          label: const Text("บันทึกข้อมูล"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onPressed: () {
            saveData(context);
          },
        ),
      ],
    );
  }

  TableRow _buildTableRow(String label, String value,
      {bool isHeader = false, Color textColor = Colors.black}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey.shade100 : Colors.white,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryExplanation(
      String category, String explanation, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$category: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(explanation),
          ),
        ],
      ),
    );
  }

  void saveData(BuildContext context) async {
    if (controller.selectedSafeMethod.value.isEmpty ||
        controller.selectedPreferredMethod.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("กรุณาเลือกวิธีคุมกำเนิด"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("กำลังบันทึกข้อมูล..."),
              ],
            ),
          ),
        );
      },
    );

    bool success = await controller.saveToFirestore();

    context.pop();

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("บันทึกข้อมูลสำเร็จ"),
          backgroundColor: Colors.green,
        ),
      );

      context.go(AppRoutes.homePage);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("เกิดข้อผิดพลาด: ไม่สามารถบันทึกข้อมูลได้"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

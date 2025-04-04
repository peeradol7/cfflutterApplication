import 'package:fam_care/controller/disease_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../app_routes.dart';
import '../../constatnt/title_constants.dart';
import '../../controller/summary_controller.dart';

class TablePage extends StatelessWidget {
  final SummaryController controller = Get.put(SummaryController());
  final DiseaseController diseaseController = Get.put(DiseaseController());

  TablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ตารางการเลือกวิธีการคุมกำเนิด\nตามเงื่อนไขส่วนตัว"),
      ),
      body: Obx(() => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    height: 400,
                    child: DataTable(
                      border: TableBorder.all(color: Colors.black),
                      columns: [
                        DataColumn(
                            label: Text("วิธีการคุมกำเนิด",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        ...buildConditionColumns(),
                      ],
                      rows: buildMethodRows(),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    icon: Obx(() => Icon(controller.isDescriptionVisible.value
                        ? Icons.visibility_off
                        : Icons.visibility)),
                    label: Obx(() => Text(controller.isDescriptionVisible.value
                        ? "ซ่อนคำอธิบาย"
                        : "แสดงคำอธิบาย")),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () => controller.isDescriptionVisible.toggle(),
                  ),
                ),
              ),
              // แสดงส่วน Container เมื่อกดปุ่ม
              SliverToBoxAdapter(
                child: Obx(() => controller.isDescriptionVisible.value
                    ? Container(
                        padding: EdgeInsets.all(16),
                        color: Colors.grey[200],
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ContentConstants.description,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(ContentConstants.firstDescription,
                                  style: TextStyle(fontSize: 14)),
                              Text(ContentConstants.secondDescription,
                                  style: TextStyle(fontSize: 14)),
                              Text(ContentConstants.thirdDescription,
                                  style: TextStyle(fontSize: 14)),
                              Text(ContentConstants.fourthDescription,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text(ContentConstants.fivethDescription,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic)),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      ContentConstants.sixthescription,
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  buildSafeMethodDropdown(),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '• คุณสนใจวิธีคุมกำเนิดวิธีใด จากการแนะนำของเรา: ',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  buildPreferredMethodDropdown(),
                                ],
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.summarize,
                                    color: Colors.white,
                                  ),
                                  label: Text("สรุปผล"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                  ),
                                  onPressed: () => saveData(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox.shrink()),
              ),
            ],
          )),
    );
  }

  List<DataRow> buildMethodRows() {
    List<DataRow> rows = [];
    List<String> methodKeys = [
      "first",
      "second",
      "third",
      "four",
      "five",
      "six"
    ];

    for (var methodKey in methodKeys) {
      List<DataCell> cells = [];
      bool shouldHideRow = false;

      Map<String, List<String>> uniqueDiseaseAttributes =
          controller.getUniqueDiseaseAttributes();
      Map<String, Map<String, dynamic>> methodValues =
          controller.getMethodValues();

      uniqueDiseaseAttributes.forEach((diseaseType, attributes) {
        for (var attribute in attributes) {
          String key = "$diseaseType-$attribute";
          var rawValue = methodValues[key]?[methodKey] ?? "";

          String value;
          if (rawValue is List) {
            value = rawValue.join(",");
          } else {
            value = rawValue.toString();
          }

          if (value.contains("3") || value.contains("4")) {
            shouldHideRow = true;
          }

          cells.add(DataCell(
            Text(
              value,
              maxLines: 3,
              style: (value.contains("3") || value.contains("4"))
                  ? TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                  : null,
              textAlign: TextAlign.center,
            ),
          ));
        }
      });

      if (!shouldHideRow) {
        rows.add(DataRow(
          cells: [
            DataCell(Text(ContentConstants.getTitle(methodKey),
                style: TextStyle(fontWeight: FontWeight.bold))),
            ...cells
          ],
        ));
      }
    }

    return rows;
  }

  Widget buildSafeMethodDropdown() {
    return Obx(() => DropdownButton<String>(
          value: controller.selectedSafeMethod.value.isEmpty
              ? null
              : controller.selectedSafeMethod.value,
          hint: Text("เลือกวิธีที่ปลอดภัย"),
          items: controller.getSafeMethods().map((dynamic value) {
            String stringValue = value.toString();
            return DropdownMenuItem<String>(
              value: stringValue,
              child: Text(stringValue),
            );
          }).toList(),
          onChanged: (newValue) {
            controller.selectedSafeMethod.value = newValue ?? "";
          },
        ));
  }

  Widget buildPreferredMethodDropdown() {
    return Obx(() => DropdownButton<String>(
          value: controller.selectedPreferredMethod.value.isEmpty
              ? null
              : controller.selectedPreferredMethod.value,
          hint: Text("เลือกวิธีที่สนใจ"),
          items: controller.getAllMethods().map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            controller.selectedPreferredMethod.value = newValue ?? "";
          },
        ));
  }

  List<DataColumn> buildConditionColumns() {
    Map<String, List<String>> uniqueDiseaseAttributes =
        controller.getUniqueDiseaseAttributes();
    List<DataColumn> columns = [];
    int columnCount = 1;

    uniqueDiseaseAttributes.forEach((diseaseType, attributes) {
      for (var attribute in attributes) {
        columns.add(
          DataColumn(
            label: Text(
              "เงื่อนไขที่ $columnCount\n$attribute",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
        columnCount++;
      }
    });

    return columns;
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
    context.push(AppRoutes.summaryPage);

    // bool success = await controller.saveToFirestore();

    // context.pop();

    // if (success) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text("บันทึกข้อมูลสำเร็จ"),
    //       backgroundColor: Colors.green,
    //     ),
    //   );

    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text("เกิดข้อผิดพลาด: ไม่สามารถบันทึกข้อมูลได้"),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
  }
}

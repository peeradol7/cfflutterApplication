import 'package:fam_care/constatnt/title_constants.dart';
import 'package:fam_care/controller/disease_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../controller/summary_controller.dart';

class SummaryPage extends StatelessWidget {
  final SummaryController controller = Get.put(SummaryController());
  final DiseaseController diseaseController = Get.put(DiseaseController());

  SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ตารางการเลือกวิธีการคุมกำเนิด\nตามเงื่อนไขส่วนตัว"),
      ),
      body: Obx(() => Column(
            children: [
              Expanded(
                child: InteractiveViewer(
                  boundaryMargin: EdgeInsets.all(40),
                  minScale: 0.1,
                  maxScale: 5.0,
                  constrained: false,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        height: diseaseController.savedRecommendations.isEmpty
                            ? 200
                            : null,
                        child: DataTable(
                          border: TableBorder.all(color: Colors.black),
                          columns: [
                            DataColumn(
                                label: Text("วิธีการคุมกำเนิด",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            ...buildConditionColumns(),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(Text(ContentConstants.firstTitle,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ...buildMethodValues("first"),
                            ]),
                            DataRow(cells: [
                              DataCell(Text(ContentConstants.secondtTitle,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ...buildMethodValues("second"),
                            ]),
                            DataRow(cells: [
                              DataCell(Text(ContentConstants.thirdTitle,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ...buildMethodValues("third"),
                            ]),
                            DataRow(cells: [
                              DataCell(Text(ContentConstants.fourthTitle,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ...buildMethodValues("four"),
                            ]),
                            DataRow(cells: [
                              DataCell(Text(ContentConstants.fivethitle,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ...buildMethodValues("five"),
                            ]),
                            DataRow(cells: [
                              DataCell(Text(ContentConstants.sixthitle,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ...buildMethodValues("six"),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 360,
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
                              fontSize: 14, fontStyle: FontStyle.italic)),
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
                          icon: Icon(Icons.save),
                          label: Text("บันทึกข้อมูล"),
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
              ),
            ],
          )),
    );
  }

  // Build UI components
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

  List<DataCell> buildMethodValues(String methodKey) {
    List<DataCell> cells = [];
    Map<String, List<String>> uniqueDiseaseAttributes =
        controller.getUniqueDiseaseAttributes();
    Map<String, Map<String, String>> methodValues =
        controller.getMethodValues();

    uniqueDiseaseAttributes.forEach((diseaseType, attributes) {
      for (var attribute in attributes) {
        String key = "$diseaseType-$attribute";
        String value = methodValues[key]?[methodKey] ?? "";
        bool isHighlighted = (value == "3" || value == "4");

        cells.add(
          DataCell(
            Text(
              value,
              style: isHighlighted
                  ? TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                  : null,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    });

    return cells;
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

      context.pop();
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

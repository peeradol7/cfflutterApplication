import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../controller/summary_controller.dart';

class SummaryPage extends StatelessWidget {
  final SummaryController controller = Get.put(SummaryController());

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
                        height: controller.savedRecommendations.isEmpty
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
                              DataCell(Text("1. ยาคุมกำเนิดชนิดฮอร์โมนรวม",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ...buildMethodValues("first"),
                            ]),
                            DataRow(cells: [
                              DataCell(Text(
                                  "2. ยาเม็ดคุมกำเนิดชนิดฮอร์โมนเดี่ยว\n(มีโปรเจสโตเจนอย่างเดียว)",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ...buildMethodValues("second"),
                            ]),
                            DataRow(cells: [
                              DataCell(Text(
                                  "3. ยาฉีดคุมกำเนิดชนิดฮอร์โมนเดี่ยว",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ...buildMethodValues("third"),
                            ]),
                            DataRow(cells: [
                              DataCell(Text("4. ยาฝังคุมกำเนิดชนิด 3 ปี/5 ปี",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ...buildMethodValues("four"),
                            ]),
                            DataRow(cells: [
                              DataCell(Text("5. ห่วงอนามัยชนิดมีฮอร์โมน",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ...buildMethodValues("five"),
                            ]),
                            DataRow(cells: [
                              DataCell(Text(
                                  "6. ห่วงอนามัยชนิดทองแดง \n(ไม่มีฮอร์โมน)",
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
                        "คำอธิบายตาราง:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text("หมวด 1 = ใช้วิธีนี้ได้ทุกกรณี",
                          style: TextStyle(fontSize: 14)),
                      Text(
                          "หมวด 2 = ใช้วิธีนี้ได้โดยทั่วไป (หากใช้ได้ทั้งวิธีในหมวด 1 และ 2 ให้เลือกใช้หมวด 1 ก่อน)",
                          style: TextStyle(fontSize: 14)),
                      Text(
                          "หมวด 3 = ไม่ควรใช้วิธีนี้ ยกเว้นไม่สามารถจัดหาวิธีที่เหมาะสมกว่านี้ ใช้ได้ภายใต้ข้อพิจารณาของบุคลากรทางการแพทย์",
                          style: TextStyle(fontSize: 14)),
                      Text("หมวด 4 = ห้ามใช้วิธีนี้",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(
                          "หมายเหตุ: ทุกวิธีแนะนำให้ใช้ร่วมกับถุงยางอนามัยสำหรับผู้ชายหรือผู้หญิง เพื่อป้องกันโรคติดต่อทางเพศสัมพันธ์/ เชื้อเอชไอวี",
                          style: TextStyle(
                              fontSize: 14, fontStyle: FontStyle.italic)),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '• วิธีคุมกำเนิดที่ปลอดภัยสำหรับคุณ (เรียงตามหมวด 1-4) คือ ',
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

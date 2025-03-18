import 'package:fam_care/controller/disease_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummaryPage extends StatelessWidget {
  SummaryPage({super.key});
  final DiseaseController controller = Get.put(DiseaseController());

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
                            ..._buildConditionColumns(),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(Text("1. ยาคุมกำเนิดชนิดฮอร์โมนรวม",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ..._buildMethodValues("first"),
                            ]),
                            DataRow(cells: [
                              DataCell(Text(
                                  "2. ยาเม็ดคุมกำเนิดชนิดฮอร์โมนเดี่ยว\n(มีโปรเจสโตเจนอย่างเดียว)",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ..._buildMethodValues("second"),
                            ]),
                            DataRow(cells: [
                              DataCell(Text(
                                  "3. ยาฉีดคุมกำเนิดชนิดฮอร์โมนเดี่ยว",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ..._buildMethodValues("third"),
                            ]),
                            DataRow(cells: [
                              DataCell(Text("4. ยาฝังคุมกำเนิดชนิด 3 ปี/5 ปี",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ..._buildMethodValues("four"),
                            ]),
                            DataRow(cells: [
                              DataCell(Text("5. ห่วงอนามัยชนิดมีฮอร์โมน",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ..._buildMethodValues("five"),
                            ]),
                            DataRow(cells: [
                              DataCell(Text(
                                  "6. ห่วงอนามัยชนิดทองแดง \n(ไม่มีฮอร์โมน)",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              ..._buildMethodValues("six"),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ส่วนคำอธิบายด้านล่างตาราง
              Container(
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
                          "หมายเหตุ: ทุกวิธีแนะนำให้ใช้ร่วมกับถุงยางอนามัยสำหรับผู้ชายหรือผู้หญิง เพื่อป้องกันโรคติดต่อทางเพศสัมพันธ์/เชื้อเอชไอวี",
                          style: TextStyle(
                              fontSize: 14, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  List<DataColumn> _buildConditionColumns() {
    Map<String, List<String>> uniqueDiseaseAttributes = {};

    for (var recommendation in controller.savedRecommendations) {
      String diseaseType = recommendation.diseaseType;

      if (!uniqueDiseaseAttributes.containsKey(diseaseType)) {
        uniqueDiseaseAttributes[diseaseType] = [];
      }

      for (var selection in recommendation.selections) {
        if (!uniqueDiseaseAttributes[diseaseType]!
            .contains(selection.attribute)) {
          uniqueDiseaseAttributes[diseaseType]!.add(selection.attribute);
        }
      }
    }

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

  List<DataCell> _buildMethodValues(String methodKey) {
    List<DataCell> cells = [];
    Map<String, List<String>> uniqueDiseaseAttributes = {};
    Map<String, Map<String, String>> methodValues = {};

    for (var recommendation in controller.savedRecommendations) {
      String diseaseType = recommendation.diseaseType;

      if (!uniqueDiseaseAttributes.containsKey(diseaseType)) {
        uniqueDiseaseAttributes[diseaseType] = [];
      }

      for (var selection in recommendation.selections) {
        if (!uniqueDiseaseAttributes[diseaseType]!
            .contains(selection.attribute)) {
          uniqueDiseaseAttributes[diseaseType]!.add(selection.attribute);
        }

        String key = "$diseaseType-${selection.attribute}";
        if (!methodValues.containsKey(key)) {
          methodValues[key] = {};
        }

        if (selection.recommendLevels.containsKey(methodKey)) {
          methodValues[key]![methodKey] =
              selection.recommendLevels[methodKey].toString();
        }
      }
    }

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
}

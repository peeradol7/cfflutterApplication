import 'dart:io';

import 'package:docx_template/docx_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:path_provider/path_provider.dart';

class SurveyForm extends StatefulWidget {
  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  TextEditingController ageController = TextEditingController();
  String maritalStatus = "โสด";
  bool hasChildren = false;
  String healthIssue = "ไม่มี";
  String birthPlan = "ใช่";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("แบบสอบถาม")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("อายุ"),
            TextField(
                controller: ageController, keyboardType: TextInputType.number),
            SizedBox(height: 10),
            Text("สถานภาพ"),
            DropdownButton<String>(
              value: maritalStatus,
              items: ["โสด", "สมรส/มีคู่", "หย่าร้าง"].map((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  maritalStatus = newValue!;
                });
              },
            ),
            SizedBox(height: 10),
            Text("มีบุตรแล้วหรือไม่"),
            Switch(
              value: hasChildren,
              onChanged: (bool value) {
                setState(() {
                  hasChildren = value;
                });
              },
            ),
            SizedBox(height: 10),
            Text("ปัญหาสุขภาพ"),
            DropdownButton<String>(
              value: healthIssue,
              items: ["ไม่มี", "มี"].map((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  healthIssue = newValue!;
                });
              },
            ),
            SizedBox(height: 10),
            Text("คุณวางแผนมีบุตรหรือไม่"),
            DropdownButton<String>(
              value: birthPlan,
              items: ["ใช่", "ไม่ใช่"].map((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  birthPlan = newValue!;
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                generateWordFile();
              },
              child: Text("บันทึกเป็น Word"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateWordFile() async {
    try {
      final ByteData data = await rootBundle.load('assets/survey.docx');
      final Uint8List bytes = data.buffer.asUint8List();
      final docx = await DocxTemplate.fromBytes(bytes);

      String age = ageController.text;
      String hasChildrenText = hasChildren ? "มี" : "ไม่มี";

      Content content = Content();
      content
        ..add(TextContent("age", age))
        ..add(TextContent("marital_status", maritalStatus))
        ..add(TextContent("has_children", hasChildrenText))
        ..add(TextContent("health_issue", healthIssue))
        ..add(TextContent("birth_plan", birthPlan));

      final docGenerated = await docx.generate(content);
      if (docGenerated != null) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = "${directory.path}/survey.docx";
        final file = File(filePath);
        await file.writeAsBytes(docGenerated);

        print("ไฟล์ถูกสร้างที่: $filePath");
      }
    } catch (e) {
      print("เกิดข้อผิดพลาด: $e");
    }
  }
}

void main() {
  runApp(MaterialApp(home: SurveyForm()));
}

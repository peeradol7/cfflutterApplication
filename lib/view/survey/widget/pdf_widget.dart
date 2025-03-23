import 'dart:io';

import 'package:fam_care/constatnt/contraception_survey_constants.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfWidget extends StatefulWidget {
  const PdfWidget({super.key});

  @override
  State<PdfWidget> createState() => _PdfWidgetState();
}

class _PdfWidgetState extends State<PdfWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => generateAndOpenPDF(context),
        child: Text('Generate PDF'),
      ),
    );
  }

  late AnimationController _controller;
  Map<String, dynamic> generalAnswers = {};
  Map<String, dynamic> healthAnswers = {};
  Map<String, dynamic> planningAnswers = {};
  Map<String, dynamic> knowledgeAnswers = {};
  Map<String, dynamic> convenienceAnswers = {};
  Map<String, dynamic> riskAnswers = {};
  Map<String, dynamic> opinionAnswers = {};
  Map<String, dynamic> consultationAnswers = {};

  Map<String, List<String>> multipleSelectionAnswers = {
    'reason_for_contraception': [],
    'previous_methods': [],
    'important_factors': [],
  };

  Map<String, TextEditingController> textControllers = {};
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> generateAndOpenPDF(BuildContext context) async {
    final font = await PdfGoogleFonts.sarabunRegular();
    final boldFont = await PdfGoogleFonts.sarabunBold();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                ContraceptionSurveyConstants.FORM_TITLE,
                style: pw.TextStyle(font: boldFont, fontSize: 20),
              ),
            ),
            pw.SizedBox(height: 20),

            // ส่วนที่ 1: ข้อมูลทั่วไป
            _buildPdfSection(
              ContraceptionSurveyConstants.SECTION_1_TITLE,
              ContraceptionSurveyConstants.GENERAL_INFO,
              generalAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),

            // ส่วนที่ 2: สุขภาพทั่วไป
            _buildPdfSection(
              ContraceptionSurveyConstants.SECTION_2_TITLE,
              ContraceptionSurveyConstants.HEALTH_INFO,
              healthAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),

            // ส่วนที่ 3: การวางแผนคุมกำเนิด
            _buildPdfSection(
              ContraceptionSurveyConstants.SECTION_3_TITLE,
              ContraceptionSurveyConstants.PLANNING_INFO,
              planningAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),
            pw.SizedBox(height: 20),

            // ส่วนที่ 4: ความรู้เกี่ยวกับวิธีการคุมกำเนิด
            _buildPdfSection(
              ContraceptionSurveyConstants.SECTION_4_TITLE,
              ContraceptionSurveyConstants.KNOWLEDGE_INFO,
              knowledgeAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),

            // ส่วนที่ 5: ความสะดวกสบายและความสม่ำเสมอในการใช้
            _buildPdfSection(
              ContraceptionSurveyConstants.SECTION_5_TITLE,
              ContraceptionSurveyConstants.CONVENIENCE_INFO,
              convenienceAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),

            // ส่วนที่ 6: ความต้องการในอนาคตและความเสี่ยง
            _buildPdfSection(
              ContraceptionSurveyConstants.SECTION_6_TITLE,
              ContraceptionSurveyConstants.RISK_INFO,
              riskAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),

            // ส่วนที่ 7: ความคิดเห็นส่วนตัว
            _buildPdfSection(
              ContraceptionSurveyConstants.SECTION_7_TITLE,
              ContraceptionSurveyConstants.PERSONAL_OPINION,
              opinionAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),
            pw.SizedBox(height: 20),
            pw.SizedBox(height: 20),

            // ส่วนที่ 8: การปรึกษาผู้เชี่ยวชาญ
            _buildPdfSection(
              ContraceptionSurveyConstants.SECTION_8_TITLE,
              ContraceptionSurveyConstants.EXPERT_CONSULTATION,
              consultationAnswers,
              font,
              boldFont,
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file =
        File('${output.path}/${ContraceptionSurveyConstants.PDF_FILENAME}');
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ContraceptionSurveyConstants.PDF_SUCCESS),
        duration: Duration(seconds: 2),
      ),
    );

    await OpenFile.open(file.path);
  }

  pw.Widget _buildPdfSection(
    String title,
    Map<String, dynamic> sectionData,
    Map<String, dynamic> answers,
    pw.Font font,
    pw.Font boldFont,
  ) {
    List<pw.Widget> fields = [];

    fields.add(
      pw.Text(
        title,
        style: pw.TextStyle(font: boldFont, fontSize: 16),
      ),
    );

    fields.add(pw.SizedBox(height: 10));

    sectionData.forEach((key, data) {
      bool shouldDisplay = true;
      if (data.containsKey('dependent_on')) {
        Map<String, String> dependencies = data['dependent_on'];
        dependencies.forEach((depKey, depValue) {
          if (depKey.startsWith('reason_for_contraception') ||
              depKey.startsWith('previous_methods') ||
              depKey.startsWith('important_factors')) {
            if (!multipleSelectionAnswers.containsKey(depKey) ||
                !multipleSelectionAnswers[depKey]!.contains(depValue)) {
              shouldDisplay = false;
            }
          } else {
            if (generalAnswers[depKey] != depValue &&
                healthAnswers[depKey] != depValue &&
                planningAnswers[depKey] != depValue &&
                knowledgeAnswers[depKey] != depValue &&
                convenienceAnswers[depKey] != depValue &&
                riskAnswers[depKey] != depValue &&
                opinionAnswers[depKey] != depValue &&
                consultationAnswers[depKey] != depValue) {
              shouldDisplay = false;
            }
          }
        });
      }

      if (shouldDisplay) {
        fields.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 8.0, bottom: 5.0),
            child: pw.Text(
              data['label'],
              style: pw.TextStyle(font: font, fontSize: 12),
            ),
          ),
        );

        if (data['type'] == 'text') {
          String answer = '';
          if (sectionData == ContraceptionSurveyConstants.GENERAL_INFO) {
            answer = generalAnswers[key] ?? '';
          } else if (sectionData == ContraceptionSurveyConstants.HEALTH_INFO) {
            answer = healthAnswers[key] ?? '';
          } else if (sectionData ==
              ContraceptionSurveyConstants.PLANNING_INFO) {
            answer = planningAnswers[key] ?? '';
          } else if (sectionData ==
              ContraceptionSurveyConstants.KNOWLEDGE_INFO) {
            answer = knowledgeAnswers[key] ?? '';
          } else if (sectionData ==
              ContraceptionSurveyConstants.PERSONAL_OPINION) {
            answer = opinionAnswers[key] ?? '';
          }

          fields.add(
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 16.0, bottom: 10.0),
              child: pw.Text(
                'คำตอบ: $answer',
                style: pw.TextStyle(font: font, fontSize: 12),
              ),
            ),
          );
        } else if (data['type'] == 'radio') {
          String answer = answers[key] ?? 'ไม่ได้ระบุ';
          fields.add(
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 16.0, bottom: 10.0),
              child: pw.Text(
                'คำตอบ: $answer',
                style: pw.TextStyle(font: font, fontSize: 12),
              ),
            ),
          );
        } else if (data['type'] == 'checkbox' ||
            data['type'] == 'checkbox_limited') {
          List<String> selectedOptions = multipleSelectionAnswers[key] ?? [];
          if (selectedOptions.isNotEmpty) {
            fields.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 16.0, bottom: 10.0),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'คำตอบที่เลือก:',
                      style: pw.TextStyle(font: font, fontSize: 12),
                    ),
                    pw.SizedBox(height: 5),
                    ...selectedOptions.map((option) {
                      return pw.Padding(
                        padding:
                            const pw.EdgeInsets.only(left: 8.0, bottom: 2.0),
                        child: pw.Text(
                          '• $option',
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          } else {
            fields.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 16.0, bottom: 10.0),
                child: pw.Text(
                  'คำตอบ: ไม่ได้เลือกข้อใด',
                  style: pw.TextStyle(font: font, fontSize: 12),
                ),
              ),
            );
          }
        }
      }
    });

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: fields,
    );
  }
}

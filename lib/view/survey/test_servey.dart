import 'dart:io';

import 'package:fam_care/constatnt/app_colors.dart';
import 'package:fam_care/constatnt/survey_constants.dart';
import 'package:fam_care/controller/user_controller.dart';
import 'package:fam_care/service/shared_prefercense_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ContraceptionFormPage extends StatefulWidget {
  @override
  _ContraceptionSurveyPageState createState() =>
      _ContraceptionSurveyPageState();
}

class _ContraceptionSurveyPageState extends State<ContraceptionFormPage> {
  final UserController controller = Get.put(UserController());
  int? loadedAge;
  Map<String, dynamic> generalAnswers = {};
  Map<String, dynamic> healthAnswers = {};
  Map<String, dynamic> planningAnswers = {};
  Map<String, dynamic> knowledgeAnswers = {};
  Map<String, dynamic> convenienceAnswers = {};
  Map<String, dynamic> riskAnswers = {};
  Map<String, dynamic> opinionAnswers = {};
  Future<void>? _initialLoadFuture;
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
    initTextControllers(SurveyConstants.GENERAL_INFO);
    initTextControllers(SurveyConstants.HEALTH_INFO);
    initTextControllers(SurveyConstants.PLANNING_INFO);
    initTextControllers(SurveyConstants.KNOWLEDGE_INFO);
    initTextControllers(SurveyConstants.PERSONAL_OPINION);
    _initialLoadFuture = loadInitialData();
  }

  void initTextControllers(Map<String, dynamic> sectionData) {
    sectionData.forEach((key, value) {
      if (value['type'] == 'text') {
        textControllers[key] = TextEditingController();
      }
    });
  }

  Future<void> loadInitialData() async {
    if (loadedAge == null) {
      loadedAge = await loadAge();
    }
  }

  @override
  void dispose() {
    textControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialLoadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Loading...')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return Scaffold(
              appBar: AppBar(
                title: Text(SurveyConstants.FORM_TITLE),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(SurveyConstants.SECTION_1_TITLE),
                      buildSectionAge(
                          SurveyConstants.GENERAL_INFO, generalAnswers),
                      SizedBox(height: 20),
                      _buildSectionTitle(SurveyConstants.SECTION_2_TITLE),
                      _buildSection(SurveyConstants.HEALTH_INFO, healthAnswers),
                      SizedBox(height: 20),
                      _buildSectionTitle(SurveyConstants.SECTION_3_TITLE),
                      _buildSection(
                          SurveyConstants.PLANNING_INFO, planningAnswers),
                      SizedBox(height: 20),
                      _buildSectionTitle(SurveyConstants.SECTION_4_TITLE),
                      _buildSection(
                          SurveyConstants.KNOWLEDGE_INFO, knowledgeAnswers),
                      SizedBox(height: 20),
                      _buildSectionTitle(SurveyConstants.SECTION_5_TITLE),
                      _buildSection(
                          SurveyConstants.CONVENIENCE_INFO, convenienceAnswers),
                      SizedBox(height: 20),
                      _buildSectionTitle(SurveyConstants.SECTION_6_TITLE),
                      _buildSection(SurveyConstants.RISK_INFO, riskAnswers),
                      SizedBox(height: 20),
                      _buildSectionTitle(SurveyConstants.SECTION_7_TITLE),
                      _buildSection(
                          SurveyConstants.PERSONAL_OPINION, opinionAnswers),
                      SizedBox(height: 20),
                      _buildSectionTitle(SurveyConstants.SECTION_8_TITLE),
                      _buildSection(SurveyConstants.EXPERT_CONSULTATION,
                          consultationAnswers),
                      SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            generateAndOpenPDF(context);
                          },
                          child: Text(SurveyConstants.PDF_BUTTON),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ));
        }
      },
    );
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
    String age = generalAnswers['age'] ?? '$loadedAge';
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
        String labelText = data['label'];
        if (key == 'age') {
          labelText = 'อายุ : $age';
        }
        fields.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 8.0, bottom: 5.0),
            child: pw.Text(
              labelText,
              style: pw.TextStyle(font: font, fontSize: 12),
            ),
          ),
        );

        if (data['type'] == 'text') {
          String answer = '';
          if (sectionData == SurveyConstants.GENERAL_INFO) {
            answer = generalAnswers[key] ?? '';
          } else if (sectionData == SurveyConstants.HEALTH_INFO) {
            answer = healthAnswers[key] ?? '';
          } else if (sectionData == SurveyConstants.PLANNING_INFO) {
            answer = planningAnswers[key] ?? '';
          } else if (sectionData == SurveyConstants.KNOWLEDGE_INFO) {
            answer = knowledgeAnswers[key] ?? '';
          } else if (sectionData == SurveyConstants.PERSONAL_OPINION) {
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
        } else if (data['type'] == 'dropdown') {
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
        }
      }
    });

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: fields,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<int> loadAge() async {
    final data = await SharedPrefercenseService().getUser();
    if (data?.birthDay != null) {
      final age = controller.calculateAge(data!.birthDay!);
      return age;
    } else {
      return 0;
    }
  }

  Widget buildSectionAge(
      Map<String, dynamic> sectionData, Map<String, dynamic> answers) {
    List<Widget> fields = [];

    String age = generalAnswers['age'] ?? '$loadedAge';

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
        String labelText = data['label'];
        if (key == 'age') {
          labelText = 'อายุ : $age';
        }

        fields.add(
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
            child: Text(
              labelText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );

        if (data['type'] == 'radio') {
          for (String option in data['options']) {
            fields.add(
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                child: Row(
                  children: [
                    Radio<String>(
                      value: option,
                      groupValue: answers[key],
                      onChanged: (value) {
                        setState(() {
                          answers[key] = value;
                        });
                      },
                    ),
                    Text(
                      option,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }
        }
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields,
    );
  }

  Widget _buildSection(
      Map<String, dynamic> sectionData, Map<String, dynamic> answers) {
    List<Widget> fields = [];

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
        String labelText = data['label'];

        fields.add(
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
            child: Text(
              labelText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );

        if (data['type'] == 'text') {
          fields.add(
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: TextField(
                controller: textControllers[key],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  setState(() {
                    if (sectionData == SurveyConstants.GENERAL_INFO) {
                      generalAnswers[key] = value;
                    } else if (sectionData == SurveyConstants.HEALTH_INFO) {
                      healthAnswers[key] = value;
                    } else if (sectionData == SurveyConstants.PLANNING_INFO) {
                      planningAnswers[key] = value;
                    } else if (sectionData == SurveyConstants.KNOWLEDGE_INFO) {
                      knowledgeAnswers[key] = value;
                    } else if (sectionData ==
                        SurveyConstants.PERSONAL_OPINION) {
                      opinionAnswers[key] = value;
                    }
                  });
                },
              ),
            ),
          );
        } else if (data['type'] == 'radio') {
          for (String option in data['options']) {
            fields.add(
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                child: Row(
                  children: [
                    Radio<String>(
                      value: option,
                      groupValue: answers[key],
                      onChanged: (value) {
                        setState(() {
                          answers[key] = value;
                        });
                      },
                    ),
                    Text(
                      option,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }
        } else if (data['type'] == 'dropdown') {
          fields.add(
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                child: DropdownButton<String>(
                  dropdownColor: AppColors.secondary,
                  iconEnabledColor: AppColors.color5,

                  isExpanded: true, // ทำให้ dropdown ขยายเต็มความกว้าง
                  value: answers[key], // ค่าที่เลือกใน dropdown
                  onChanged: (String? newValue) {
                    setState(() {
                      answers[key] = newValue; // อัปเดตคำตอบเมื่อเลือก
                    });
                  },
                  items: data['options']
                      .map<DropdownMenuItem<String>>((String option) {
                    return DropdownMenuItem<String>(
                      value: option, // ค่าของตัวเลือก
                      child: Text(option), // ข้อความที่แสดงใน dropdown
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        } else if (data['type'] == 'checkbox' ||
            data['type'] == 'checkbox_limited') {
          int maxSelection =
              data['type'] == 'checkbox_limited' ? data['max_selection'] : 999;

          if (data['type'] == 'checkbox_limited') {
            fields.add(
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                child: Text(
                  SurveyConstants.SELECTED_COUNT
                      .replaceAll(
                          '{count}',
                          multipleSelectionAnswers[key]?.length.toString() ??
                              '0')
                      .replaceAll('{max}', maxSelection.toString()),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            );
          }
          for (String option in data['options']) {
            fields.add(
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: multipleSelectionAnswers[key]?.contains(option) ??
                          false,
                      onChanged: (bool? value) {
                        setState(() {
                          if (!multipleSelectionAnswers.containsKey(key)) {
                            multipleSelectionAnswers[key] = [];
                          }

                          if (value == true) {
                            if (multipleSelectionAnswers[key]!.length <
                                maxSelection) {
                              multipleSelectionAnswers[key]!.add(option);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    SurveyConstants.MAX_SELECTION_WARNING
                                        .replaceAll(
                                            '{max}', maxSelection.toString()),
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } else {
                            multipleSelectionAnswers[key]!.remove(option);
                          }
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        option,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields,
    );
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
                SurveyConstants.FORM_TITLE,
                style: pw.TextStyle(font: boldFont, fontSize: 20),
              ),
            ),
            pw.SizedBox(height: 20),

            _buildPdfSection(
              SurveyConstants.SECTION_1_TITLE,
              SurveyConstants.GENERAL_INFO,
              generalAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),

            _buildPdfSection(
              SurveyConstants.SECTION_2_TITLE,
              SurveyConstants.HEALTH_INFO,
              healthAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),

            _buildPdfSection(
              SurveyConstants.SECTION_3_TITLE,
              SurveyConstants.PLANNING_INFO,
              planningAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),
            pw.SizedBox(height: 20),

            // ส่วนที่ 4: ความรู้เกี่ยวกับวิธีการคุมกำเนิด
            _buildPdfSection(
              SurveyConstants.SECTION_4_TITLE,
              SurveyConstants.KNOWLEDGE_INFO,
              knowledgeAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),

            // ส่วนที่ 5: ความสะดวกสบายและความสม่ำเสมอในการใช้
            _buildPdfSection(
              SurveyConstants.SECTION_5_TITLE,
              SurveyConstants.CONVENIENCE_INFO,
              convenienceAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),

            // ส่วนที่ 6: ความต้องการในอนาคตและความเสี่ยง
            _buildPdfSection(
              SurveyConstants.SECTION_6_TITLE,
              SurveyConstants.RISK_INFO,
              riskAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),

            // ส่วนที่ 7: ความคิดเห็นส่วนตัว
            _buildPdfSection(
              SurveyConstants.SECTION_7_TITLE,
              SurveyConstants.PERSONAL_OPINION,
              opinionAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),
            pw.SizedBox(height: 20),
            pw.SizedBox(height: 20),

            _buildPdfSection(
              SurveyConstants.SECTION_8_TITLE,
              SurveyConstants.EXPERT_CONSULTATION,
              consultationAnswers,
              font,
              boldFont,
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/${SurveyConstants.PDF_FILENAME}');
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(SurveyConstants.PDF_SUCCESS),
        duration: Duration(seconds: 2),
      ),
    );

    await OpenFile.open(file.path);
  }
}

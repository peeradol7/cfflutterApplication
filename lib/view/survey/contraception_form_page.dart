import 'dart:io';

import 'package:fam_care/constatnt/app_colors.dart';
import 'package:fam_care/constatnt/survey_constants.dart';
import 'package:fam_care/controller/form_controller.dart';
import 'package:fam_care/controller/user_controller.dart';
import 'package:fam_care/model/contraception_form_model.dart';
import 'package:fam_care/service/shared_prefercense_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  final formController = Get.put(FormController());
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
    final userId = controller.userData.value!.userId;
    controller.fetchUserDataById(userId!);
    controller.loadIsSurveyCompleted();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialLoadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading...', style: TextStyle(color: Colors.white)),
              backgroundColor: AppColors.color5,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'กำลังโหลดข้อมูล...',
                    style: TextStyle(
                      color: AppColors.color5,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: AppColors.color8,
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error', style: TextStyle(color: Colors.white)),
              backgroundColor: AppColors.color5,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red[300],
                    size: 60,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'เกิดข้อผิดพลาด',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.color5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            backgroundColor: AppColors.color8,
          );
        } else {
          return Scaffold(
            backgroundColor: AppColors.color8,
            appBar: AppBar(
              backgroundColor: AppColors.color5,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              title: Text(
                SurveyConstants.FORM_TITLE,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.color8, Colors.white],
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(
                                  SurveyConstants.SECTION_1_TITLE),
                              buildSectionAge(
                                  SurveyConstants.GENERAL_INFO, generalAnswers),
                              SizedBox(height: 20),
                              _buildSectionTitle(
                                  SurveyConstants.SECTION_2_TITLE),
                              _buildSection(
                                  SurveyConstants.HEALTH_INFO, healthAnswers),
                              SizedBox(height: 20),
                              _buildSectionTitle(
                                  SurveyConstants.SECTION_3_TITLE),
                              _buildSection(SurveyConstants.PLANNING_INFO,
                                  planningAnswers),
                              SizedBox(height: 20),
                              _buildSectionTitle(
                                  SurveyConstants.SECTION_4_TITLE),
                              _buildSection(SurveyConstants.KNOWLEDGE_INFO,
                                  knowledgeAnswers),
                              SizedBox(height: 20),
                              _buildSectionTitle(
                                  SurveyConstants.SECTION_5_TITLE),
                              _buildSection(SurveyConstants.CONVENIENCE_INFO,
                                  convenienceAnswers),
                              SizedBox(height: 20),
                              _buildSectionTitle(
                                  SurveyConstants.SECTION_6_TITLE),
                              _buildSection(
                                  SurveyConstants.RISK_INFO, riskAnswers),
                              SizedBox(height: 20),
                              _buildSectionTitle(
                                  SurveyConstants.SECTION_7_TITLE),
                              _buildSection(SurveyConstants.PERSONAL_OPINION,
                                  opinionAnswers),
                              SizedBox(height: 20),
                              _buildSectionTitle(
                                  SurveyConstants.SECTION_8_TITLE),
                              _buildSection(SurveyConstants.EXPERT_CONSULTATION,
                                  consultationAnswers),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.color6.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: [AppColors.color5, AppColors.color6],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              generateAndOpenPDF(context);
                              controller.loadIsSurveyCompleted();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              textStyle: TextStyle(fontSize: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.picture_as_pdf, color: Colors.white),
                                SizedBox(width: 12),
                                Text(
                                  SurveyConstants.PDF_BUTTON,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
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
              depKey.startsWith('important_factors') ||
              depKey.startsWith('knowledge_methods') ||
              depKey.startsWith('health_issues') ||
              depKey.startsWith('side_effects') ||
              depKey.startsWith('plan_contraception') ||
              depKey.startsWith('planned_duration') ||
              depKey.startsWith('current_situation') ||
              depKey.startsWith('side_effects_detail') ||
              depKey.startsWith('history_drug_allergy_detail') ||
              depKey.startsWith('reversible_method') ||
              depKey.startsWith('hormone_side_effects') ||
              depKey.startsWith('interested_method') ||
              depKey.startsWith('consulted_expert') ||
              depKey.startsWith('want_consultation')) {
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

          if (selectedOptions.contains('ไม่รู้จักเลย')) {
            selectedOptions = ['ไม่รู้จักเลย'];
          }

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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.color5, AppColors.color6],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.color5.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
              depKey.startsWith('important_factors') ||
              depKey.startsWith('current_situation') ||
              depKey.startsWith('side_effects_detail') ||
              depKey.startsWith('history_drug_allergy_detail') ||
              depKey.startsWith('plan_contraception') ||
              depKey.startsWith('planned_duration')) {
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
            padding:
                const EdgeInsets.only(left: 12.0, bottom: 16.0, right: 12.0),
            child: Text(
              labelText,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.color5,
              ),
            ),
          ),
        );

        if (data['type'] == 'text') {
          String hintText = data.containsKey('placeholder')
              ? data['placeholder']
              : 'กรอกข้อมูล';
          fields.add(
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.color6, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.color7.withOpacity(0.3),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: textControllers[key],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    hintText: hintText,
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (sectionData == SurveyConstants.GENERAL_INFO) {
                        generalAnswers[key] = value;
                      } else if (sectionData == SurveyConstants.HEALTH_INFO) {
                        healthAnswers[key] = value;
                      } else if (sectionData == SurveyConstants.PLANNING_INFO) {
                        planningAnswers[key] = value;
                      } else if (sectionData ==
                          SurveyConstants.KNOWLEDGE_INFO) {
                        knowledgeAnswers[key] = value;
                      } else if (sectionData ==
                          SurveyConstants.PERSONAL_OPINION) {
                        opinionAnswers[key] = value;
                      }
                    });
                  },
                ),
              ),
            ),
          );
        } else if (data['type'] == 'radio') {
          fields.add(
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.color7.withOpacity(0.3),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: data['options'].map<Widget>((option) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.color8,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 2.0),
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
                              activeColor: AppColors.color5,
                            ),
                            Expanded(
                              child: Text(
                                option,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        } else if (data['type'] == 'dropdown') {
          fields.add(
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.color6, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.color7.withOpacity(0.3),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    iconEnabledColor: AppColors.color5,
                    icon: Icon(Icons.arrow_drop_down_circle),
                    isExpanded: true,
                    value: answers[key],
                    onChanged: (String? newValue) {
                      setState(() {
                        answers[key] = newValue;
                      });
                    },
                    items: data['options']
                        .map<DropdownMenuItem<String>>((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: TextStyle(
                            color: AppColors.color5,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
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
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 12.0, right: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    SurveyConstants.SELECTED_COUNT
                        .replaceAll(
                            '{count}',
                            multipleSelectionAnswers[key]?.length.toString() ??
                                '0')
                        .replaceAll('{max}', maxSelection.toString()),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: AppColors.color5,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }

          fields.add(
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.color7.withOpacity(0.3),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: data['options'].map<Widget>((option) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.color8,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 2.0),
                        child: Row(
                          children: [
                            Checkbox(
                              value: multipleSelectionAnswers[key]
                                      ?.contains(option) ??
                                  false,
                              onChanged: (bool? value) {
                                setState(() {
                                  multipleSelectionAnswers[key] ??= [];

                                  bool isUnknownOption =
                                      option == 'ไม่รู้จักเลย';

                                  if (isUnknownOption) {
                                    if (value == true) {
                                      // เลือก "ไม่รู้จักเลย" -> ล้างตัวเลือกอื่น
                                      multipleSelectionAnswers[key] = [
                                        'ไม่รู้จักเลย'
                                      ];
                                    } else {
                                      // ยกเลิก "ไม่รู้จักเลย"
                                      multipleSelectionAnswers[key]!
                                          .remove('ไม่รู้จักเลย');
                                    }
                                  } else {
                                    // ถ้ามี "ไม่รู้จักเลย" อยู่ -> ลบออกก่อน
                                    multipleSelectionAnswers[key]!
                                        .remove('ไม่รู้จักเลย');

                                    if (value == true) {
                                      // ตรวจสอบ max selection
                                      if (multipleSelectionAnswers[key]!
                                                  .length <
                                              maxSelection ||
                                          maxSelection == 999) {
                                        multipleSelectionAnswers[key]!
                                            .add(option);
                                      } else {
                                        // เตือนถ้าเกินจำนวนที่อนุญาต
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              SurveyConstants
                                                  .MAX_SELECTION_WARNING
                                                  .replaceAll('{max}',
                                                      maxSelection.toString()),
                                            ),
                                            duration: Duration(seconds: 2),
                                            backgroundColor: AppColors.color3,
                                          ),
                                        );
                                      }
                                    } else {
                                      // ยกเลิกเลือก
                                      multipleSelectionAnswers[key]!
                                          .remove(option);
                                    }
                                  }
                                });
                              },
                              activeColor: AppColors.color5,
                              checkColor: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                option,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
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
    final userId = await SharedPrefercenseService().getUserId();
    final isCompleted = await controller.updateIsSurveyCompleted(userId!);
    SharedPrefercenseService().updateIsServeyCompleted(isCompleted);
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
            pw.SizedBox(height: 20),
            pw.SizedBox(height: 20),
            _buildPdfSection(
              SurveyConstants.SECTION_4_TITLE,
              SurveyConstants.KNOWLEDGE_INFO,
              knowledgeAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),
            _buildPdfSection(
              SurveyConstants.SECTION_5_TITLE,
              SurveyConstants.CONVENIENCE_INFO,
              convenienceAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 20),
            _buildPdfSection(
              SurveyConstants.SECTION_6_TITLE,
              SurveyConstants.RISK_INFO,
              riskAnswers,
              font,
              boldFont,
            ),
            pw.SizedBox(height: 180),
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
    final userData = await SharedPrefercenseService().getUser();
    final firstName = userData!.firstName;
    final lastName = userData.lastName;
    final age = controller.calculateAge(userData.birthDay!);
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$firstName $lastName $currentDate.pdf';

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(SurveyConstants.PDF_SUCCESS),
        duration: Duration(seconds: 2),
      ),
    );
    final data = ContraceptionFormModel(
      role: generalAnswers['role'] ?? 'ไม่ได้ป้อนข้อมูล',
      createBy: '$firstName $lastName',
      age: '$age',
      maritalStatus: generalAnswers['marital_status'] ?? 'ไม่ได้ป้อนข้อมูล',
      haveChildren: generalAnswers['have_children'] ?? 'ไม่ได้ป้อนข้อมูล',
      planChildren: generalAnswers['plan_children'] ?? 'ไม่ได้ป้อนข้อมูล',
      healthIssues: healthAnswers['health_issues'] ?? 'ไม่ได้ป้อนข้อมูล',
      sideEffects: healthAnswers['side_effects'] ?? 'ไม่ได้ป้อนข้อมูล',
      planContraception:
          planningAnswers['plan_contraception'] ?? 'ไม่ได้ป้อนข้อมูล',
      historyDrugAllergy:
          healthAnswers['history_drug_allergy'] ?? 'ไม่ได้ป้อนข้อมูล',
      plannedDuration:
          planningAnswers['planned_duration'] ?? 'ไม่ได้ป้อนข้อมูล',
      knowledge: knowledgeAnswers['knowledge'] ?? 'ไม่ได้ป้อนข้อมูล',
      regularUse: convenienceAnswers['regular_use'] ?? 'ไม่ได้ป้อนข้อมูล',
      followUp: convenienceAnswers['follow_up'] ?? 'ไม่ได้ป้อนข้อมูล',
      riskyActivities: riskAnswers['risky_activities'] ?? 'ไม่ได้ป้อนข้อมูล',
      reversibleMethod: riskAnswers['reversible_method'] ?? 'ไม่ได้ป้อนข้อมูล',
      hormoneSideEffects:
          riskAnswers['hormone_side_effects'] ?? 'ไม่ได้ป้อนข้อมูล',
      interestedMethod:
          opinionAnswers['interested_method'] ?? 'ไม่ได้ป้อนข้อมูล',
      consultedExpert:
          consultationAnswers['consulted_expert'] ?? 'ไม่ได้ป้อนข้อมูล',
      wantConsultation:
          consultationAnswers['want_consultation'] ?? 'ไม่ได้ป้อนข้อมูล',
    );

    await formController.saveData(data);

    await OpenFile.open(file.path);
  }
}

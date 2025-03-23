import 'package:fam_care/constatnt/contraception_survey_constants.dart';
import 'package:fam_care/controller/user_controller.dart';
import 'package:fam_care/view/survey/widget/first_section_widget.dart';
import 'package:fam_care/view/survey/widget/pdf_widget.dart';
import 'package:fam_care/view/survey/widget/section_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'PDF Form Generator',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ContraceptionFormPage(),
//     );
//   }
// }

class ContraceptionFormPage extends StatefulWidget {
  @override
  _ContraceptionSurveyPageState createState() =>
      _ContraceptionSurveyPageState();
}

class _ContraceptionSurveyPageState extends State<ContraceptionFormPage> {
  final UserController controller = Get.put(UserController());
  Map<String, dynamic> generalAnswers = {};

  Map<String, TextEditingController> textControllers = {};

  @override
  void initState() {
    super.initState();
    initTextControllers(ContraceptionSurveyConstants.GENERAL_INFO);
    initTextControllers(ContraceptionSurveyConstants.HEALTH_INFO);
    initTextControllers(ContraceptionSurveyConstants.PLANNING_INFO);
    initTextControllers(ContraceptionSurveyConstants.KNOWLEDGE_INFO);
    initTextControllers(ContraceptionSurveyConstants.PERSONAL_OPINION);
  }

  void initTextControllers(Map<String, dynamic> sectionData) {
    sectionData.forEach((key, value) {
      if (value['type'] == 'text') {
        textControllers[key] = TextEditingController();
      }
    });
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
    return Scaffold(
      appBar: AppBar(
        title: Text(ContraceptionSurveyConstants.FORM_TITLE),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(ContraceptionSurveyConstants.SECTION_1_TITLE),
              FirstSectionWidget(
                  sectionData: ContraceptionSurveyConstants.GENERAL_INFO,
                  answers: generalAnswers),
              SizedBox(height: 20),
              _buildSectionTitle(ContraceptionSurveyConstants.SECTION_2_TITLE),
              SectionWidget(
                sectionData: ContraceptionSurveyConstants.HEALTH_INFO,
                answers: generalAnswers,
              ),
              _buildSectionTitle(ContraceptionSurveyConstants.SECTION_3_TITLE),
              // _buildSection(
              //     ContraceptionSurveyConstants.PLANNING_INFO, planningAnswers),
              SectionWidget(
                sectionData: ContraceptionSurveyConstants.PLANNING_INFO,
                answers: generalAnswers,
              ),
              SizedBox(height: 20),
              _buildSectionTitle(ContraceptionSurveyConstants.SECTION_4_TITLE),
              // _buildSection(ContraceptionSurveyConstants.KNOWLEDGE_INFO,
              //     knowledgeAnswers),
              SectionWidget(
                sectionData: ContraceptionSurveyConstants.KNOWLEDGE_INFO,
                answers: generalAnswers,
              ),
              SizedBox(height: 20),
              _buildSectionTitle(ContraceptionSurveyConstants.SECTION_5_TITLE),
              // _buildSection(ContraceptionSurveyConstants.CONVENIENCE_INFO,
              //     convenienceAnswers),
              SectionWidget(
                sectionData: ContraceptionSurveyConstants.CONVENIENCE_INFO,
                answers: generalAnswers,
              ),
              SizedBox(height: 20),
              _buildSectionTitle(ContraceptionSurveyConstants.SECTION_6_TITLE),
              // _buildSection(
              //     ContraceptionSurveyConstants.RISK_INFO, riskAnswers),
              SectionWidget(
                sectionData: ContraceptionSurveyConstants.RISK_INFO,
                answers: generalAnswers,
              ),
              SizedBox(height: 20),
              _buildSectionTitle(ContraceptionSurveyConstants.SECTION_7_TITLE),
              // _buildSection(ContraceptionSurveyConstants.PERSONAL_OPINION,
              //     opinionAnswers),
              SectionWidget(
                sectionData: ContraceptionSurveyConstants.PERSONAL_OPINION,
                answers: generalAnswers,
              ),
              SizedBox(height: 20),
              _buildSectionTitle(ContraceptionSurveyConstants.SECTION_8_TITLE),
              // _buildSection(ContraceptionSurveyConstants.EXPERT_CONSULTATION,
              //     consultationAnswers),
              SectionWidget(
                sectionData: ContraceptionSurveyConstants.EXPERT_CONSULTATION,
                answers: generalAnswers,
              ),
              SizedBox(height: 30),
              PdfWidget(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
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
}

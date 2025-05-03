import 'package:fam_care/app_routes.dart';
import 'package:fam_care/constatnt/app_colors.dart';
import 'package:fam_care/controller/user_controller.dart';
import 'package:fam_care/service/knowledge_service.dart';
import 'package:fam_care/service/shared_prefercense_service.dart';
import 'package:fam_care/view/home_page/widget/logout_dialog_widget.dart';
import 'package:fam_care/view/home_page/widget/person_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../widget/app_snackbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController _controller = Get.put(UserController());
  final service = KnowledgeService();
  final pref = SharedPrefercenseService();
  bool? isSurveyCompleted;

  @override
  void initState() {
    super.initState();
    _controller.loadUserFromPrefs();
    service.getKnowledgeTitles();
    _controller.loadIsSurveyCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color4,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'หน้าหลัก',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => LogoutDialogWidget(),
              );
            },
            tooltip: 'ออกจากระบบ',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: AppColors.color8,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'ข้อมูลส่วนตัว',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.color5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.color8, width: 2),
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.colorButton,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.color8.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: PersonDataWidget(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      color: AppColors.color8,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            _buildServiceCard(
                                context: context,
                                title: 'ทำแบบสอบถาม',
                                icon: Icons.assignment_rounded,
                                color: AppColors.color5,
                                onTap: () {
                                  context.push(AppRoutes.surveyPage);
                                },
                                isEnabled: true),
                            SizedBox(height: 16),
                            Obx(
                              () => Column(
                                children: [
                                  _buildServiceCard(
                                      context: context,
                                      title: 'เลือกวิธีคุมกำเนิด',
                                      icon: Icons.health_and_safety_rounded,
                                      color: Colors.pinkAccent[100]!,
                                      onTap: () {
                                        context
                                            .push(AppRoutes.selectDiseasePage);
                                      },
                                      isEnabled: _controller.isEnable.value),
                                  SizedBox(height: 16),
                                  _buildServiceCard(
                                    context: context,
                                    title: 'บันทึกรอบประจำเดือน',
                                    icon: Icons.calendar_month_rounded,
                                    color: Colors.redAccent[100]!,
                                    onTap: () {
                                      context.push(AppRoutes.calendarPage);
                                    },
                                    isEnabled: _controller.isEnable.value,
                                  ),
                                  SizedBox(height: 16),
                                  _buildServiceCard(
                                    context: context,
                                    title: 'ความรู้เกี่ยวกับวิธีคุมกำเนิด',
                                    icon: Icons.book,
                                    color: AppColors.secondary,
                                    onTap: () {
                                      context.push(AppRoutes.knowledge);
                                    },
                                    isEnabled: _controller.isEnable.value,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isEnabled,
  }) {
    return InkWell(
      onTap: () async {
        if (isEnabled) {
          await _controller.loadIsSurveyCompleted();
          onTap();
        } else {
          AppSnackbar.error(
            context,
            'กรุณาทำแบบสอบถามก่อน',
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

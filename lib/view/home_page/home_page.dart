import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_care/app_routes.dart';
import 'package:fam_care/constatnt/app_colors.dart';
import 'package:fam_care/controller/user_controller.dart';
import 'package:fam_care/service/knowledge_service.dart';
import 'package:fam_care/view/home_page/widget/logout_dialog_widget.dart';
import 'package:fam_care/view/home_page/widget/person_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController _controller = Get.put(UserController());
  final service = KnowledgeService();

  @override
  void initState() {
    super.initState();
    _controller.loadUserFromPrefs();
    service.getKnowledgeTitles();
  }

  Future<void> addKnowledge() async {
    final knowledgeData = {
      "title": "ยาคุมกำเนิดชนิดฮอร์โมนรวม (Combined Hormonal Contraceptives)",
      "subtopics": [
        {
          "order": 1,
          "subtitle": "คืออะไร",
          "content":
              """วิธีคุมกำเนิดที่มีฮอร์โมนเอสโตรเจนและโปรเจสโตเจนผสมกัน เช่น ยาเม็ดคุมกำเนิดชนิดฮอร์โมนรวม,
แผ่นแปะคุมกำเนิด,วงแหวนช่องคลอด และยาคุมแบบฉีดเดือนละครั้ง โดยฮอร์โมนทั้งสองชนิดจะทำงานร่วมกันเพื่อ
ยับยั้งการตกไข่และป้องกันการตั้งครรภ์""",
        },
        {
          "order": 2,
          "subtitle": "สิ่งที่ควรรู้ก่อนใช้",
          "content":
              """ต้องใช้ให้สม่ำเสมอตามกำหนดเวลา (เช่น กินยาเม็ดทุกวัน เปลี่ยนแผ่นแปะทุกสัปดาห์ หรือใส่วง
แหวน/ฉีดยาทุกเดือนตามชนิดที่เลือก) ไม่เหมาะสำหรับสตรีที่ให้นมบุตรในช่วงหลังคลอดใหม่ๆ เพราะเอสโตรเจน
อาจทำให้น้ำนมลดลงได้นอกจากนี้ ผู้หญิงอายุเกิน 35 ปีที่สูบบุหรี่หนักควรหลีกเลี่ยงวิธีฮอร์โมนรวม เนื่องจากเพิ่ม
ความเสี่ยงต่อผลข้างเคียงรุนแรงบางอย่าง (ควรปรึกษาแพทย์หากมีโรคประจำตัวหรือปัจจัยเสี่ยงอื่นๆเช่น ความดัน
โลหิตสูง หรือไมเกรนรุนแรงก่อนใช้)
""",
        },
        {
          "order": 3,
          "subtitle": "ผลข้างเคียงที่อี่นอาจเกิดขึ้น",
          "content":
              "ต้องใช้ให้สม่ำเสมอตามกำหนดเวลา (เช่น กินยาเม็ดทุกวัน เปลี่ยนแผ่นแปะทุกสัปดาห์ หรือใส่วงแหวน/ฉีดยาทุกเดือนตามชนิดที่เลือก) ไม่เหมาะส าหรับสตรีที่ให้นมบุตรในช่วงหลังคลอดใหม่ๆ เพราะเอสโตรเจนอาจทำให้น้ำนมลดลงได้นอกจากนี้ ผู้หญิงอายุเกิน 35 ปีที่สูบบุหรี่หนักควรหลีกเลี่ยงวิธีฮอร์โมนรวม เนื่องจากเพิ่มความเสี่ยงต่อผลข้างเคียงรุนแรงบางอย่าง (ควรปรึกษาแพทย์หากมีโรคประจำตัวหรือปัจจัยเสี่ยงอื่นๆ เช่น ความดันโลหิตสูง หรือไมเกรนรุนแรงก่อนใช้)",
        }
      ]
    };

    try {
      await FirebaseFirestore.instance
          .collection('knowledge')
          .doc('1')
          .set(knowledgeData);
      print("✅ ข้อมูลถูกบันทึกเรียบร้อยแล้ว");
    } catch (e) {
      print("❌ เกิดข้อผิดพลาด: $e");
    }
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
                              title: 'เลือกวิธีคุมกำเนิด',
                              icon: Icons.health_and_safety_rounded,
                              color: Colors.pinkAccent[100]!,
                              onTap: () {
                                context.push(AppRoutes.selectDiseasePage);
                              },
                            ),
                            SizedBox(height: 16),
                            _buildServiceCard(
                              context: context,
                              title: 'บันทึกรอบประจำเดือน',
                              icon: Icons.calendar_month_rounded,
                              color: Colors.redAccent[100]!,
                              onTap: () {
                                context.push(AppRoutes.calendarPage);
                              },
                            ),
                            SizedBox(height: 16),
                            _buildServiceCard(
                              context: context,
                              title: 'ทำแบบสอบถาม',
                              icon: Icons.assignment_rounded,
                              color: AppColors.color5,
                              onTap: () {
                                context.push(AppRoutes.surveyPage);
                              },
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
  }) {
    return InkWell(
      onTap: onTap,
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

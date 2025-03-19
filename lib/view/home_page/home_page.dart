import 'package:fam_care/app_routes.dart';
import 'package:fam_care/constatnt/app_colors.dart';
import 'package:fam_care/controller/user_controller.dart';
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

  @override
  void initState() {
    super.initState();
    _controller.loadUserFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ข้อมูลส่วนตัว',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.colorButton),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PersonDataWidget(),
                  ),
                ),
                SizedBox(height: 30),
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.push(AppRoutes.selectDiseasePage);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.pinkAccent[100]),
                            width: 300,
                            height: 100,
                            child: Center(
                              child: Text(
                                'เลือกวิธีคุมกำเนิด',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            context.push(AppRoutes.calendarPage);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.redAccent[100]),
                            width: 300,
                            height: 100,
                            child: Center(
                              child: Text(
                                'บันทึกรอบประจำเดือน',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            context.push(AppRoutes.calendarPage);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.color5),
                            width: 300,
                            height: 100,
                            child: Center(
                              child: Text(
                                'ทำแบบสอบถาม',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

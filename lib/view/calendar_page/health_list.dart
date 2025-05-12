import 'package:fam_care/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../constatnt/app_colors.dart';
import '../../controller/health_controller.dart';
import '../../model/health_model.dart';

class HealthList extends StatefulWidget {
  const HealthList({super.key});

  @override
  State<HealthList> createState() => _HealthListState();
}

class _HealthListState extends State<HealthList> {
  final controller = Get.find<HealthController>();

  @override
  void initState() {
    controller.fetchHealthData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color8,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        backgroundColor: AppColors.primary,
        title: Text(
          'สภาวะร่างการต่อวัน',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (controller.healthData.isEmpty) {
            return Center(
              child: Text(
                '',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.color5,
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: controller.healthData.length,
              itemBuilder: (context, index) {
                final healthRecord = controller.healthData[index];
                final DateTime parsedDate = DateTime.parse(healthRecord.date);
                final formattedDate =
                    DateFormat('d MMMM yyyy', 'th_TH').format(parsedDate);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: HealthRecordCard(
                    healthRecord: healthRecord,
                    formattedDate: formattedDate,
                    onTap: () {
                      var id = healthRecord.id;
                      context.push(
                        '${AppRoutes.healthDataPage}/$id',
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: const Color.fromRGBO(255, 255, 255, 1)),
        onPressed: () {
          context.push(AppRoutes.create);
        },
      ),
    );
  }
}

class HealthRecordCard extends StatelessWidget {
  final HealthModel healthRecord;
  final String formattedDate;
  final VoidCallback onTap;

  const HealthRecordCard({
    required this.healthRecord,
    required this.formattedDate,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.color7, AppColors.color6],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'อาการของวันที่ $formattedDate',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
              SizedBox(height: 10),
              // _buildSymptomsList(),
            ],
          ),
        ),
      ),
    );
  }
}

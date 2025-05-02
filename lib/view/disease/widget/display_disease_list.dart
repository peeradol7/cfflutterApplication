import 'package:fam_care/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../controller/disease_controller.dart';

class DisplayDiseaseList extends StatelessWidget {
  DisplayDiseaseList({super.key});

  final DiseaseController controller = Get.put(DiseaseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Disease List')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.amber.withOpacity(0.3),
            child: const Text(
              'กรุณาตรวจสอบให้ครบทุกข้อและเลือกเงื่อนไขสุขภาพที่มีผลกระทบต่อร่างกายมากที่สุดก่อน',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.diseaseList.isEmpty) {
                return Center(child: Text('No diseases found.'));
              }

              return ListView.builder(
                itemCount: controller.diseaseList.length,
                itemBuilder: (context, index) {
                  final disease = controller.diseaseList[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        disease.type,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () {
                          // แสดงข้อมูลเพิ่มเติมของ disease
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('ข้อมูลเพิ่มเติม'),
                              content: Text('รายละเอียดของ ${disease.type}'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('ปิด'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      onTap: () {
                        final id = disease.id;
                        final path = AppRoutes.diseaseDetail;
                        context.push('$path/$id');
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

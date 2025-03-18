import 'package:fam_care/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../controller/disease_controller.dart';

class DisplayDiseaseList extends StatelessWidget {
  DisplayDiseaseList({super.key});

  final DiseaseController controller = Get.put(DiseaseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Disease List')),
      body: Obx(() {
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
              child: GestureDetector(
                onTap: () {
                  final id = disease.id;
                  final path = AppRoutes.diseaseDetail;
                  context.push('$path/$id');
                },
                child: ListTile(
                  title: Text(
                    disease.type,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

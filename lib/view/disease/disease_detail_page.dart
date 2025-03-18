import 'package:fam_care/controller/disease_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class DiseaseDetailPage extends StatefulWidget {
  final String id;
  const DiseaseDetailPage({super.key, required this.id});

  @override
  State<DiseaseDetailPage> createState() => _DiseaseDetailPageState();
}

class _DiseaseDetailPageState extends State<DiseaseDetailPage> {
  final DiseaseController controller = Get.put(DiseaseController());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      controller.fetchRecommend(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("Disease: ${controller.diseaseType.value}")),
        actions: [
          Obx(() => controller.selectedAttributesData.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () async {
                    controller.saveSelectedRecommendation(widget.id);
                    controller.loadSavedDiseases();
                    context.pop();
                    context.pop();
                  },
                )
              : SizedBox()),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.recomendation.isEmpty) {
          return const Center(child: Text("No recommendations found"));
        }

        return ListView.builder(
          itemCount: controller.recomendation.length,
          itemBuilder: (context, index) {
            final rec = controller.recomendation[index];

            bool isAttributeAlreadySelected = false;

            controller.selectedAttributesData.forEach((key, selectedRec) {
              if (key != rec.id && selectedRec['attribute'] == rec.attribute) {
                isAttributeAlreadySelected = true;
              }
            });

            return Card(
              margin: EdgeInsets.all(8),
              child: InkWell(
                onTap: isAttributeAlreadySelected
                    ? null
                    : () {
                        controller.selectAttributeWithLevels(
                            rec.id, rec.attribute, rec.recommendLevel);
                      },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(() => Text(
                              rec.attribute,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isAttributeAlreadySelected
                                    ? Colors.grey
                                    : controller.selectedId == rec.id
                                        ? Colors.blue
                                        : Colors.black,
                              ),
                            )),
                      ),
                      if (controller.selectedId == rec.id)
                        Icon(Icons.check_circle, color: Colors.blue)
                      else if (isAttributeAlreadySelected)
                        Icon(Icons.block, color: Colors.grey)
                      else
                        SizedBox(),
                    ],
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

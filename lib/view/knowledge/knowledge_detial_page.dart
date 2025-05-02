import 'package:fam_care/controller/knowledge_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../constatnt/app_colors.dart';
import '../../model/knowledge_model.dart';

class KnowledgeDetailPage extends StatefulWidget {
  final String id;
  const KnowledgeDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<KnowledgeDetailPage> createState() => _KnowledgeDetailPageState();
}

class _KnowledgeDetailPageState extends State<KnowledgeDetailPage> {
  final controller = Get.find<KnowledgeController>();

  @override
  void initState() {
    super.initState();
    controller.getKnowledgeById(widget.id);
  }

  @override
  void dispose() {
    controller.knowledge.value = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Obx(() {
          final knowledge = controller.knowledge.value;
          return Text(
            knowledge?.title ?? 'Loading...',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
        }),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        final knowledge = controller.knowledge.value;

        if (knowledge == null) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }

        final sortedSubtopics = List<Subtopic>.from(knowledge.subtopics)
          ..sort((a, b) => a.order.compareTo(b.order));

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    knowledge.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // Subtopics
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sortedSubtopics.length,
                  itemBuilder: (context, index) {
                    final subtopic = sortedSubtopics[index];
                    final List<Color> sectionColors = [
                      AppColors.colorButton,
                      AppColors.color7.withOpacity(0.7),
                      AppColors.color8,
                      AppColors.color4.withOpacity(0.7),
                      AppColors.color3.withOpacity(0.3),
                      AppColors.secondary.withOpacity(0.4),
                    ];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: sectionColors[index % sectionColors.length],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        subtopic.order.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      subtopic.subtitle,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Html(
                                  data: subtopic.content,
                                  style: {
                                    "body": Style(
                                      fontSize: FontSize(16.0),
                                      color: Colors.black87,
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                    ),
                                    "p": Style(
                                      margin: Margins.only(bottom: 10),
                                    ),
                                    "strong": Style(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    "ul": Style(
                                      margin: Margins.only(left: 20),
                                    ),
                                    "li": Style(
                                      margin: Margins.only(bottom: 5),
                                    ),
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

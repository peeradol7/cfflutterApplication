import 'package:flutter/material.dart';

import '../../../model/disease_object.dart';

class DiseaseDetailCard extends StatelessWidget {
  final SelectedRecommendation recommendation;
  final VoidCallback onRemove;

  const DiseaseDetailCard({
    Key? key,
    required this.recommendation,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Row(
          children: [
            Expanded(
              child: Text(
                recommendation.diseaseType,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red, size: 20),
              onPressed: onRemove,
              tooltip: "ลบโรคนี้",
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var selection in recommendation.selections)
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selection.attribute,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                if (recommendation.selections.isEmpty)
                  Center(
                    child: Text(
                      "ไม่มีคำแนะนำที่เลือกสำหรับโรคนี้",
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

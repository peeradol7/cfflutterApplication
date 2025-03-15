import 'package:fam_care/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectDiseasePage extends StatefulWidget {
  const SelectDiseasePage({super.key});

  @override
  _SelectDiseasePageState createState() => _SelectDiseasePageState();
}

class _SelectDiseasePageState extends State<SelectDiseasePage> {
  List<String> selectedDiseases = [];

  void _removeDisease(int index) {
    setState(() {
      selectedDiseases.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("เพิ่มโรคประจำตัว")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: selectedDiseases.map((disease) {
                int index = selectedDiseases.indexOf(disease);
                return GestureDetector(
                  onTap: () => _removeDisease(index),
                  child: Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              disease,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.close, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context.push(AppRoutes.displayDiseaseList);
              },
              icon: Icon(Icons.add),
              label: Text("เพิ่มโรค"),
            ),
          ],
        ),
      ),
    );
  }
}

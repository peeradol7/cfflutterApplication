import 'package:fam_care/constatnt/contraception_survey_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/user_controller.dart';
import '../../../service/shared_prefercense_service.dart';

class FirstSectionWidget extends StatelessWidget {
  final Map<String, dynamic> sectionData;
  final Map<String, dynamic> answers;

  FirstSectionWidget({required this.sectionData, required this.answers});
  final UserController controller = Get.put(UserController());
  final Map<String, dynamic> generalAnswers = {};
  final Map<String, dynamic> healthAnswers = {};
  final Map<String, dynamic> planningAnswers = {};
  final Map<String, dynamic> knowledgeAnswers = {};
  final Map<String, dynamic> convenienceAnswers = {};
  final Map<String, dynamic> riskAnswers = {};
  final Map<String, dynamic> opinionAnswers = {};
  final Map<String, dynamic> consultationAnswers = {};
  final Map<String, List<String>> multipleSelectionAnswers = {
    'reason_for_contraception': [],
    'previous_methods': [],
    'important_factors': [],
  };

  Future<int> loadAge() async {
    final data = await SharedPrefercenseService().getUser();
    if (data?.birthDay != null) {
      final age = await controller.calculateAge(data!.birthDay!);
      return age;
    } else {
      return 0;
    }
  }

  Future<Widget> _buildSectionAge(BuildContext context) async {
    List<Widget> fields = [];
    final calAge = await loadAge();
    print('calAge Value***$calAge');
    String age = answers['age'] ?? '$calAge';

    sectionData.forEach((key, data) {
      bool shouldDisplay = true;
      if (data.containsKey('dependent_on')) {
        Map<String, String> dependencies = data['dependent_on'];
        dependencies.forEach((depKey, depValue) {
          if (depKey.startsWith('reason_for_contraception') ||
              depKey.startsWith('previous_methods') ||
              depKey.startsWith('important_factors')) {
            if (!multipleSelectionAnswers.containsKey(depKey) ||
                !multipleSelectionAnswers[depKey]!.contains(depValue)) {
              shouldDisplay = false;
            }
          } else {
            if (answers[depKey] != depValue) {
              shouldDisplay = false;
            }
          }
        });
      }

      if (shouldDisplay) {
        String labelText = data['label'];
        if (key == 'age') {
          labelText = 'อายุ : $age ปี';
        }

        fields.add(
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
            child: Text(
              labelText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );

        if (data['type'] == 'text') {
          fields.add(
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: TextField(
                controller: TextEditingController(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  answers[key] = value;
                },
              ),
            ),
          );
        } else if (data['type'] == 'radio') {
          for (String option in data['options']) {
            fields.add(
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                child: Row(
                  children: [
                    Radio<String>(
                      value: option,
                      groupValue: answers[key],
                      onChanged: (value) {
                        answers[key] = value;
                      },
                    ),
                    Text(
                      option,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }
        } else if (data['type'] == 'checkbox' ||
            data['type'] == 'checkbox_limited') {
          int maxSelection =
              data['type'] == 'checkbox_limited' ? data['max_selection'] : 999;

          if (data['type'] == 'checkbox_limited') {
            fields.add(
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                child: Text(
                  ContraceptionSurveyConstants.SELECTED_COUNT
                      .replaceAll(
                          '{count}',
                          multipleSelectionAnswers[key]?.length.toString() ??
                              '0')
                      .replaceAll('{max}', maxSelection.toString()),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            );
          }
          for (String option in data['options']) {
            fields.add(
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: multipleSelectionAnswers[key]?.contains(option) ??
                          false,
                      onChanged: (bool? value) {
                        if (value == true) {
                          if (multipleSelectionAnswers[key]!.length <
                              maxSelection) {
                            multipleSelectionAnswers[key]!.add(option);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  ContraceptionSurveyConstants
                                      .MAX_SELECTION_WARNING
                                      .replaceAll(
                                          '{max}', maxSelection.toString()),
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          multipleSelectionAnswers[key]!.remove(option);
                        }
                      },
                    ),
                    Expanded(
                      child: Text(
                        option,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _buildSectionAge(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return snapshot.data ?? SizedBox(); // Display the section when done
        }
      },
    );
  }
}

import 'package:fam_care/constatnt/contraception_survey_constants.dart';
import 'package:flutter/material.dart';

class SectionWidget extends StatefulWidget {
  final Map<String, dynamic> sectionData;
  final Map<String, dynamic> answers;

  SectionWidget({
    required this.sectionData,
    required this.answers,
  });

  @override
  _SectionWidgetState createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  Map<String, TextEditingController> textControllers = {};
  Map<String, dynamic> generalAnswers = {};
  Map<String, dynamic> healthAnswers = {};
  Map<String, dynamic> planningAnswers = {};
  Map<String, dynamic> knowledgeAnswers = {};
  Map<String, dynamic> convenienceAnswers = {};
  Map<String, dynamic> riskAnswers = {};
  Map<String, dynamic> opinionAnswers = {};
  Map<String, dynamic> consultationAnswers = {};

  Map<String, List<String>> multipleSelectionAnswers = {
    'reason_for_contraception': [],
    'previous_methods': [],
    'important_factors': [],
  };

  @override
  void initState() {
    super.initState();
    // Initializing text controllers
    widget.sectionData.forEach((key, data) {
      if (data['type'] == 'text') {
        textControllers[key] = TextEditingController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fields = [];

    widget.sectionData.forEach((key, data) {
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
            if (generalAnswers[depKey] != depValue &&
                healthAnswers[depKey] != depValue &&
                planningAnswers[depKey] != depValue &&
                knowledgeAnswers[depKey] != depValue &&
                convenienceAnswers[depKey] != depValue &&
                riskAnswers[depKey] != depValue &&
                opinionAnswers[depKey] != depValue &&
                consultationAnswers[depKey] != depValue) {
              shouldDisplay = false;
            }
          }
        });
      }

      if (shouldDisplay) {
        fields.add(
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
            child: Text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              data['label'],
              style: TextStyle(fontSize: 16),
            ),
          ),
        );

        if (data['type'] == 'text') {
          fields.add(
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: TextField(
                controller: textControllers[key],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  setState(() {
                    widget.answers[key] = value;
                  });
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
                      groupValue: widget.answers[key],
                      onChanged: (value) {
                        setState(() {
                          widget.answers[key] = value;
                        });
                      },
                    ),
                    Text(
                      option,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  ContraceptionSurveyConstants.SELECTED_COUNT
                      .replaceAll(
                          '{count}',
                          multipleSelectionAnswers[key]?.length.toString() ??
                              '0')
                      .replaceAll('{max}', maxSelection.toString()),
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
                        setState(() {
                          if (!multipleSelectionAnswers.containsKey(key)) {
                            multipleSelectionAnswers[key] = [];
                          }

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
                        });
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
}

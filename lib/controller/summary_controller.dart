import 'package:get/get.dart';

import '../model/disease_object.dart';
import '../model/history_model.dart';
import '../service/history_service.dart';
import '../service/shared_prefercense_service.dart';

class SummaryController extends GetxController {
  final HistoryService _historyService = HistoryService();
  final prefs = SharedPrefercenseService();

  final RxList<SelectedRecommendation> savedRecommendations =
      <SelectedRecommendation>[].obs;
  RxString selectedSafeMethod = "".obs;
  RxString selectedPreferredMethod = "".obs;

  List<String> getSafeMethods() {
    if (savedRecommendations.isEmpty) {
      return ["ไม่มีข้อมูล"];
    }

    Map<int, List<String>> methodsByCategory = {1: [], 2: []};
    Map<String, String> methodNames = {
      "first": "1. ยาคุมกำเนิดชนิดฮอร์โมนรวม",
      "second": "2. ยาเม็ดคุมกำเนิดชนิดฮอร์โมนเดี่ยว",
      "third": "3. ยาฉีดคุมกำเนิดชนิดฮอร์โมนเดี่ยว",
      "four": "4. ยาฝังคุมกำเนิดชนิด 3 ปี/5 ปี",
      "five": "5. ห่วงอนามัยชนิดมีฮอร์โมน",
      "six": "6. ห่วงอนามัยชนิดทองแดง",
    };

    Set<String> addedMethods = {};
    Set<String> excludedMethods = {};

    for (var recommendation in savedRecommendations) {
      for (var selection in recommendation.selections) {
        methodNames.forEach((key, name) {
          if (selection.recommendLevels.containsKey(key)) {
            int category =
                int.tryParse(selection.recommendLevels[key].toString()) ?? 0;
            if (category > 2) {
              excludedMethods.add(name);
            }
          }
        });
      }
    }

    // Second pass: add methods with category 1 or 2 that aren't excluded
    for (var recommendation in savedRecommendations) {
      for (var selection in recommendation.selections) {
        methodNames.forEach((key, name) {
          if (selection.recommendLevels.containsKey(key)) {
            int category =
                int.tryParse(selection.recommendLevels[key].toString()) ?? 0;
            if ((category == 1 || category == 2) &&
                !excludedMethods.contains(name) &&
                !addedMethods.contains(name)) {
              methodsByCategory[category]!.add(name);
              addedMethods.add(name);
            }
          }
        });
      }
    }

    List<String> sortedMethods = [];

    for (int i = 1; i <= 2; i++) {
      if (methodsByCategory[i]!.isNotEmpty) {
        methodsByCategory[i]!.sort();
        sortedMethods.addAll(methodsByCategory[i]!);
      }
    }

    return sortedMethods.isEmpty ? ["ไม่มีข้อมูล"] : sortedMethods;
  }

  List<String> getAllMethods() {
    return [
      "1. ยาคุมกำเนิดชนิดฮอร์โมนรวม",
      "2. ยาเม็ดคุมกำเนิดชนิดฮอร์โมนเดี่ยว",
      "3. ยาฉีดคุมกำเนิดชนิดฮอร์โมนเดี่ยว",
      "4. ยาฝังคุมกำเนิดชนิด 3 ปี/5 ปี",
      "5. ห่วงอนามัยชนิดมีฮอร์โมน",
      "6. ห่วงอนามัยชนิดทองแดง",
    ];
  }

  Future<bool> saveToFirestore() async {
    try {
      List<String> conditions = [];
      for (var recommendation in savedRecommendations) {
        for (var selection in recommendation.selections) {
          conditions.add(selection.attribute);
        }
      }

      final userData = await prefs.getUser();
      final userId = userData.userId;

      HistoryModel history = HistoryModel(
        selectedSafeMethod: selectedSafeMethod.value,
        selectedPreferredMethod: selectedPreferredMethod.value,
        createdAt: DateTime.now(),
        userId: userId,
        conditions: conditions,
      );

      await _historyService.saveHistory(history);
      return true;
    } catch (e) {
      print("Error saving to Firestore: $e");
      return false;
    }
  }

  Map<String, List<String>> getUniqueDiseaseAttributes() {
    Map<String, List<String>> uniqueDiseaseAttributes = {};

    for (var recommendation in savedRecommendations) {
      String diseaseType = recommendation.diseaseType;

      if (!uniqueDiseaseAttributes.containsKey(diseaseType)) {
        uniqueDiseaseAttributes[diseaseType] = [];
      }

      for (var selection in recommendation.selections) {
        if (!uniqueDiseaseAttributes[diseaseType]!
            .contains(selection.attribute)) {
          uniqueDiseaseAttributes[diseaseType]!.add(selection.attribute);
        }
      }
    }

    return uniqueDiseaseAttributes;
  }

  Map<String, Map<String, String>> getMethodValues() {
    Map<String, Map<String, String>> methodValues = {};

    for (var recommendation in savedRecommendations) {
      String diseaseType = recommendation.diseaseType;

      for (var selection in recommendation.selections) {
        String key = "$diseaseType-${selection.attribute}";
        if (!methodValues.containsKey(key)) {
          methodValues[key] = {};
        }

        // Add values for all method keys
        ["first", "second", "third", "four", "five", "six"]
            .forEach((methodKey) {
          if (selection.recommendLevels.containsKey(methodKey)) {
            methodValues[key]![methodKey] =
                selection.recommendLevels[methodKey].toString();
          }
        });
      }
    }

    return methodValues;
  }
}

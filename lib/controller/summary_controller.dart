import 'package:fam_care/controller/disease_controller.dart';
import 'package:get/get.dart';

import '../model/disease_object.dart';
import '../model/history_model.dart';
import '../service/history_service.dart';
import '../service/shared_prefercense_service.dart';

class SummaryController extends GetxController {
  final HistoryService _historyService = HistoryService();
  final prefs = SharedPrefercenseService();
  final DiseaseController diseaseController = Get.put(DiseaseController());
  final isDescriptionVisible = false.obs;

  final RxList<SelectedRecommendation> savedRecommendations =
      <SelectedRecommendation>[].obs;
  RxString selectedSafeMethod = "".obs;
  RxString selectedPreferredMethod = "".obs;
  @override
  void onInit() {
    super.onInit();
  }

  List<String> getSafeMethods() {
    if (diseaseController.savedRecommendations.isEmpty) {
      return ["ไม่มีข้อมูล"];
    }

    Map<int, List<String>> methodsByCategory = {1: [], 2: []};
    Map<String, String> methodNames = {
      "first": "ยาคุมกำเนิดชนิดฮอร์โมนรวม",
      "second": "ยาเม็ดคุมกำเนิดชนิดฮอร์โมนเดี่ยว",
      "third": "ยาฉีดคุมกำเนิดชนิดฮอร์โมนเดี่ยว",
      "four": "ยาฝังคุมกำเนิดชนิด 3 ปี/5 ปี",
      "five": "ห่วงอนามัยชนิดมีฮอร์โมน",
      "six": "ห่วงอนามัยชนิดทองแดง",
    };

    Set<String> addedMethods = {};
    Set<String> excludedMethods = {};

    for (var recommendation in diseaseController.savedRecommendations) {
      for (var selection in recommendation.selections) {
        methodNames.forEach((key, name) {
          if (selection.recommendLevels.containsKey(key)) {
            var rawValue = selection.recommendLevels[key];

            // ตรวจสอบถ้าเป็นลิสต์หรือค่าปกติ
            List<int> values;
            if (rawValue is List) {
              values =
                  rawValue.map((v) => int.tryParse(v.toString()) ?? 0).toList();
            } else {
              values = [int.tryParse(rawValue.toString()) ?? 0];
            }

            // ถ้ามีค่า 3 หรือ 4 → ห้ามใช้วิธีนี้
            if (values.contains(3) || values.contains(4)) {
              excludedMethods.add(name);
            }
          }
        });
      }
    }

    for (var recommendation in diseaseController.savedRecommendations) {
      for (var selection in recommendation.selections) {
        methodNames.forEach((key, name) {
          if (selection.recommendLevels.containsKey(key)) {
            var rawValue = selection.recommendLevels[key];

            List<int> values;
            if (rawValue is List) {
              values =
                  rawValue.map((v) => int.tryParse(v.toString()) ?? 0).toList();
            } else {
              values = [int.tryParse(rawValue.toString()) ?? 0];
            }

            // ถ้ามีแค่ 1 หรือ 2 และไม่ถูก exclude
            if (!excludedMethods.contains(name) &&
                !addedMethods.contains(name) &&
                (values.contains(1) || values.contains(2))) {
              int category = values.contains(1) ? 1 : 2;
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
      "ยาคุมกำเนิดชนิดฮอร์โมนรวม",
      "ยาเม็ดคุมกำเนิดชนิดฮอร์โมนเดี่ยว",
      "ยาฉีดคุมกำเนิดชนิดฮอร์โมนเดี่ยว",
      "ยาฝังคุมกำเนิดชนิด 3 ปี/5 ปี",
      "ห่วงอนามัยชนิดมีฮอร์โมน",
      "ห่วงอนามัยชนิดทองแดง",
    ];
  }

  Future<bool> saveToFirestore() async {
    try {
      List<String> conditions = [];
      for (var recommendation in diseaseController.savedRecommendations) {
        for (var selection in recommendation.selections) {
          conditions.add(selection.attribute);
        }
      }

      final userData = await prefs.getUser();
      final userId = userData!.userId;

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

    print("🔍 กำลังโหลดข้อมูลจาก savedRecommendations...");

    for (var recommendation in diseaseController.savedRecommendations) {
      print("📌 เจอโรค: ${recommendation.diseaseType}");

      String diseaseType = recommendation.diseaseType;

      if (!uniqueDiseaseAttributes.containsKey(diseaseType)) {
        uniqueDiseaseAttributes[diseaseType] = [];
      }

      for (var selection in recommendation.selections) {
        print("   ✅ Attribute: ${selection.attribute}");

        if (!uniqueDiseaseAttributes[diseaseType]!
            .contains(selection.attribute)) {
          uniqueDiseaseAttributes[diseaseType]!.add(selection.attribute);
        }
      }
    }

    print("🎯 ข้อมูลที่ได้: $uniqueDiseaseAttributes");
    return uniqueDiseaseAttributes;
  }

  Map<String, Map<String, String>> getMethodValues() {
    Map<String, Map<String, String>> methodValues = {};

    print("🔍 กำลังโหลด method values จาก savedRecommendations...");

    for (var recommendation in diseaseController.savedRecommendations) {
      print("📌 โรค: ${recommendation.diseaseType}");

      String diseaseType = recommendation.diseaseType;

      for (var selection in recommendation.selections) {
        String key = "$diseaseType-${selection.attribute}";
        print("   🔹 Attribute: ${selection.attribute}");

        if (!methodValues.containsKey(key)) {
          methodValues[key] = {};
        }

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

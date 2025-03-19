import 'package:fam_care/model/disease_model.dart';
import 'package:fam_care/service/disease_service.dart';
import 'package:get/get.dart';

import '../model/disease_object.dart';

class DiseaseController extends GetxController {
  final DiseaseService service = DiseaseService();
  RxList<DiseaseModel> diseaseList = <DiseaseModel>[].obs;
  RxList<Recommendation> recomendation = <Recommendation>[].obs;
  var diseaseType = ''.obs;
  final RxList<SelectedRecommendation> savedRecommendations =
      <SelectedRecommendation>[].obs;
  var selectedDiseases = <String>[].obs;
  final _selectedId = Rxn<String>();
  final RxString selectedSafeMethod = "".obs;
  final RxString selectedPreferredMethod = "".obs;
  String? get selectedId => _selectedId.value;
  final isSelect = false.obs;
  var isLoading = true.obs;
  final selectedLevels = <String, String>{}.obs;
  final selectedAttributes = <String>[].obs;
  final selectedAttributesData = <String, Map<String, dynamic>>{}.obs;

  @override
  void onInit() {
    fetchDisease();
    super.onInit();
  }

  Future<void> fetchDisease() async {
    try {
      isLoading.value = true;
      final data = await service.fetchAllDiseases();
      diseaseList.value = data;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRecommend(String diseaseId) async {
    try {
      isLoading.value = true;

      final DiseaseModel disease =
          await service.fetchDiseaseWithRecommendations(diseaseId: diseaseId);

      diseaseType.value = disease.type;
      recomendation.value = disease.recommendations;

      selectedAttributes.clear();
      selectedAttributesData.clear();
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectAttribute(String recommendationId, String attribute) {
    if (selectedAttributes.contains(recommendationId)) {
      selectedAttributes.remove(recommendationId);
    } else {
      selectedAttributes.add(recommendationId);
    }
  }

  // บันทึกค่า recommendLevel ที่เลือก
  void selectRecommendLevel(String recommendationId, String level) {
    selectedLevels[recommendationId] = level;
  }

  void selectAttributeWithLevels(
      String id, String attribute, Map<String, dynamic> recommendLevels) {
    if (_selectedId.value == id) {
      _selectedId.value = null;
      selectedAttributesData.clear();
    } else {
      _selectedId.value = id;
      selectedAttributesData.clear();
      selectedAttributesData[id] = {
        'attribute': attribute,
        'recommendLevels': recommendLevels,
        'isSelect': true,
      };
    }

    isSelect.value = selectedAttributesData.isNotEmpty;
  }

  SelectedRecommendation getSelectedRecommendation(String diseaseId) {
    List<RecommendationSelection> selections = [];

    if (_selectedId.value != null) {
      var data = selectedAttributesData[_selectedId.value];
      if (data != null) {
        selections.add(RecommendationSelection(
          recommendationId: _selectedId.value!,
          attribute: data['attribute'],
          recommendLevels: Map<String, dynamic>.from(data['recommendLevels']),
        ));
      }
    } else {
      for (var id in selectedAttributes) {
        var data = selectedAttributesData[id];
        if (data != null) {
          selections.add(RecommendationSelection(
            recommendationId: id,
            attribute: data['attribute'],
            recommendLevels: Map<String, dynamic>.from(data['recommendLevels']),
          ));
        }
      }
    }

    return SelectedRecommendation(
      diseaseId: diseaseId,
      diseaseType: diseaseType.value,
      selections: selections,
    );
  }

  void loadSavedDiseases() {
    for (var recommendation in savedRecommendations) {
      if (!selectedDiseases.contains(recommendation.diseaseType)) {
        selectedDiseases.add(recommendation.diseaseType);
      }
    }
  }

  void removeDisease(String diseaseType) {
    selectedDiseases.remove(diseaseType);
    savedRecommendations
        .removeWhere((element) => element.diseaseType == diseaseType);
  }

  void saveSelectedRecommendation(String diseaseId) {
    SelectedRecommendation selection = getSelectedRecommendation(diseaseId);
    print('Saving recommendation for disease: ${selection.diseaseType}');
    print('Disease ID: ${selection.diseaseId}');
    print('Number of selections: ${selection.selections.length}');

    // Debug the selected recommendation
    print('Selected recommendation details:');
    for (var sel in selection.selections) {
      print('  Attribute: ${sel.attribute}');
      print('  RecommendationID: ${sel.recommendationId}');
      print('  RecommendLevels: ${sel.recommendLevels}');
    }

    int existingIndex = savedRecommendations
        .indexWhere((element) => element.diseaseId == diseaseId);

    if (existingIndex >= 0) {
      savedRecommendations[existingIndex] = selection;
      print('Updated existing recommendation at index $existingIndex');
    } else {
      savedRecommendations.add(selection);
      print('Added new recommendation');
    }

    if (!selectedDiseases.contains(selection.diseaseType)) {
      selectedDiseases.add(selection.diseaseType);
      print('Added disease type to selectedDiseases');
    }
  }
}

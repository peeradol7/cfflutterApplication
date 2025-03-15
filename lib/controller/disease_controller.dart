import 'package:fam_care/model/disease_model.dart';
import 'package:fam_care/service/disease_service.dart';
import 'package:get/get.dart';

class DiseaseController extends GetxController {
  final DiseaseService service = DiseaseService();
  RxList<DiseaseModel> diseaseList = <DiseaseModel>[].obs;
  final recomendation = Rxn(Recommendation);
  var isLoading = true.obs;

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
}

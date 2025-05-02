import 'package:fam_care/model/knowledge_list_response.dart';
import 'package:fam_care/model/knowledge_model.dart';
import 'package:fam_care/service/knowledge_service.dart';
import 'package:get/get.dart';

class KnowledgeController extends GetxController {
  final service = KnowledgeService();
  RxList<KnowledgeListResponse> knowledgeList = <KnowledgeListResponse>[].obs;
  final Rxn<KnowledgeModel> knowledge = Rxn<KnowledgeModel>();

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getknowledgeList();
  }

  Future<void> getknowledgeList() async {
    final data = await service.getKnowledgeTitles();
    knowledgeList.value = data;
  }

  Future<KnowledgeModel?> getKnowledgeById(String id) async {
    final data = await service.getKnowledgeById(id);
    knowledge.value = data;
    return data;
  }
}

import 'package:fam_care/model/knowledge_list_response.dart';
import 'package:fam_care/service/knowledge_service.dart';
import 'package:get/get.dart';

class KnowledgeController extends GetxController {
  final service = KnowledgeService();
  RxList<KnowledgeListResponse> knowledgeList = <KnowledgeListResponse>[].obs;

  Future<void> getknowledgeList() async {
    final data = await service.getKnowledgeTitles();
    knowledgeList.value = data;
  }

  // Future<Knoow?> getKnowledgeById(String id) async {
  //   final result = await service.getKnowledgeById(id);
  //   return result;
  // }
}

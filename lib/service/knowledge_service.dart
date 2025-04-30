import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_care/model/knowledge_list_response.dart';

import '../model/knowledge_model.dart';

class KnowledgeService {
  final CollectionReference _knowledgeCollection =
      FirebaseFirestore.instance.collection('knowledge');

  Future<List<KnowledgeListResponse>> getKnowledgeTitles() async {
    final querySnapshot = await _knowledgeCollection.get();
    return querySnapshot.docs.map((doc) {
      return KnowledgeListResponse.fromMap(
          doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<KnowledgeModel?> getKnowledgeById(String id) async {
    final docSnapshot = await _knowledgeCollection.doc(id).get();
    if (docSnapshot.exists) {
      return KnowledgeModel.fromJson(
          docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
    }
    return null;
  }
}

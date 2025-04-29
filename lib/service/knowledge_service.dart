import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/knowledge_model.dart';

class KnowledgeService {
  final CollectionReference _knowledgeCollection =
      FirebaseFirestore.instance.collection('knowledges');

  Future<List<Map<String, dynamic>>> getKnowledgeTitles() async {
    final querySnapshot = await _knowledgeCollection.get();
    return querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'title': doc['title'],
      };
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

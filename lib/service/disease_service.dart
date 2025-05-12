import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_care/model/disease_model.dart';

class DiseaseService {
  static final String diseaseCollection = 'disease';
  static final String recommendCollection = 'recommendations';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DiseaseModel>> fetchAllDiseases() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(diseaseCollection).orderBy('seq').get();

      return querySnapshot.docs
          .map(
            (doc) => DiseaseModel.fromJson(
                {'id': doc.id, ...doc.data() as Map<String, dynamic>}, doc.id),
          )
          .toList();
    } catch (e) {
      print('Error fetching diseases: $e');
      return [];
    }
  }

  Future<DiseaseModel> fetchDiseaseWithRecommendations(
      {required String diseaseId}) async {
    try {
      DocumentSnapshot diseaseDoc =
          await _firestore.collection(diseaseCollection).doc(diseaseId).get();

      if (!diseaseDoc.exists) {
        throw Exception("Disease not found");
      }

      Map<String, dynamic> diseaseData =
          diseaseDoc.data() as Map<String, dynamic>;
      String type = diseaseData['type'] ?? '';

      QuerySnapshot recommendations = await _firestore
          .collection(diseaseCollection)
          .doc(diseaseId)
          .collection(recommendCollection)
          .get();

      List<Recommendation> recommendationsList = [];

      int index = 1;
      for (var doc in recommendations.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data['recommendLevel'] != null && data['recommendLevel'] is Map) {
          (data['recommendLevel'] as Map).forEach((key, value) {});
        }

        Recommendation recommendation = Recommendation(
          id: doc.id,
          attribute: data['attibute'] ?? '',
          recommendLevel: data['recommendLevel'] ?? {},
        );

        recommendationsList.add(recommendation);
        index++;
      }

      DiseaseModel result = DiseaseModel(
        id: diseaseId,
        seq: index,
        type: type,
        info: diseaseData['info'] ?? '',
        recommendations: recommendationsList,
      );

      return result;
    } catch (e) {
      throw e;
    }
  }
}

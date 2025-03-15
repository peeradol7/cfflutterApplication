import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_care/model/disease_model.dart';

class DiseaseService {
  static final String diseaseCollection = 'disease';
  static final String recommendCollection = 'recommendations';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DiseaseModel>> fetchAllDiseases() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(diseaseCollection).get();

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

  Future<List<Map<String, dynamic>>> fetchRecommendations(
      String diseaseId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(diseaseCollection)
          .doc(diseaseId)
          .collection(recommendCollection)
          .get();
      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      print('Error fetching recommendations for disease $diseaseId: $e');
      return [];
    }
  }
}

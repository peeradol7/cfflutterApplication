import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_care/model/health_model.dart';

class HealthService {
  final _firestore = FirebaseFirestore.instance;
  final String healthCollection = 'health';

  Future<List<HealthModel>> fetchHealthData(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(healthCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No health data found for this user.');
      }

      return querySnapshot.docs
          .map(
              (doc) => HealthModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching health data: $e');
      rethrow;
    }
  }

  Future<bool> saveHealthData(HealthModel health) async {
    try {
      final querySnapshot = await _firestore
          .collection(healthCollection)
          .where('userId', isEqualTo: health.userId)
          .where('date', isEqualTo: health.date)
          .get();

      final docExists = querySnapshot.docs.isNotEmpty;

      if (docExists) {
        return false;
      }

      final newDocRef =
          await _firestore.collection(healthCollection).add(health.toJson());

      health.id = newDocRef.id;
      await newDocRef.update({'id': health.id});
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateHealthData({
    required String healthId,
    required List<String> selectedMoods,
    required List<String> selectedSymptoms,
    required List<String> selectedBehaviors,
    required List<String> selectedDischarge,
    required List<String> selectedSexualActivity,
    required String date,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(healthCollection)
          .where('id', isEqualTo: healthId)
          .where('date', isEqualTo: date)
          .get();

      final docExists = querySnapshot.docs.isNotEmpty;

      if (docExists) {
        return false;
      }

      final dataToUpdate = {
        'selectedMoods': selectedMoods.toList(),
        'selectedSymptoms': selectedSymptoms.toList(),
        'selectedBehaviors': selectedBehaviors.toList(),
        'selectedDischarge': selectedDischarge.toList(),
        'sexualActivity': selectedSexualActivity.toList(),
        'date': date,
      };

      await _firestore
          .collection(healthCollection)
          .doc(healthId)
          .update(dataToUpdate);
      return true;
    } catch (e) {
      print('Error updating health data: $e');
      rethrow;
    }
  }

  Future<HealthModel> getDataById(String healthId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(healthCollection).doc(healthId).get();

      if (doc.exists) {
        return HealthModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('Health data not found');
      }
    } catch (e) {
      print('Error fetching health data: $e');
      rethrow;
    }
  }

  Future<void> deleteHealthData(String healthId) async {
    try {
      await _firestore.collection(healthCollection).doc(healthId).delete();
    } catch (e) {
      print('Error deleting health data: $e');
      rethrow;
    }
  }
}

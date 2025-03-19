import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_care/model/history_model.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String diseasesHistory = 'history';

  Future<String> saveHistory(HistoryModel history) async {
    try {
      DocumentReference docRef =
          await _firestore.collection(diseasesHistory).add(history.toMap());

      return docRef.id;
    } catch (e) {
      print('Error saving history: $e');
      rethrow;
    }
  }

  Future<List<HistoryModel>> getUserHistory(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(diseasesHistory)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => HistoryModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching history: $e');
      return [];
    }
  }

  Future<void> deleteHistory(String historyId) async {
    try {
      await _firestore.collection(diseasesHistory).doc(historyId).delete();
    } catch (e) {
      print('Error deleting history: $e');
      rethrow;
    }
  }
}

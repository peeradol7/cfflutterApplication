import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  String? id;
  List<String> conditions;
  String selectedSafeMethod;
  String selectedPreferredMethod;
  DateTime createdAt;
  String? userId;

  HistoryModel({
    this.id,
    required this.conditions,
    required this.selectedSafeMethod,
    required this.selectedPreferredMethod,
    required this.createdAt,
    this.userId,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'conditions': conditions,
      'selectedSafeMethod': selectedSafeMethod,
      'selectedPreferredMethod': selectedPreferredMethod,
      'createdAt': createdAt,
      'userId': userId,
    };
  }

  // Create from Firestore document
  factory HistoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return HistoryModel(
      id: doc.id,
      conditions: List<String>.from(data['conditions'] ?? []),
      selectedSafeMethod: data['selectedSafeMethod'] ?? '',
      selectedPreferredMethod: data['selectedPreferredMethod'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      userId: data['userId'],
    );
  }
}

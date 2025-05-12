class HealthModel {
  String? id;
  final String userId;
  final String date;
  final List<String> selectedMoods;
  final List<String> selectedSymptoms;
  final List<String> selectedBehaviors;
  final List<String> selectedDischarge;
  final List<String> sexualActivity;

  HealthModel({
    this.id,
    required this.userId,
    required this.date,
    required this.selectedMoods,
    required this.selectedSymptoms,
    required this.selectedBehaviors,
    required this.selectedDischarge,
    required this.sexualActivity,
  });
  factory HealthModel.fromJson(Map<String, dynamic> json) {
    return HealthModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      date: json['date'] ?? DateTime.now().toIso8601String(),
      selectedMoods: List<String>.from(json['selectedMoods'] ?? []),
      selectedSymptoms: List<String>.from(
        json['selectedSymptoms'] ?? [],
      ),
      selectedBehaviors: List<String>.from(json['selectedBehaviors'] ?? []),
      selectedDischarge: List<String>.from(
        json['selectedDischarge'] ?? [],
      ),
      sexualActivity: List<String>.from(
        json['sexualActivity'] ?? [],
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'date': date,
      'selectedMoods': selectedMoods,
      'selectedSymptoms': selectedSymptoms,
      'selectedBehaviors': selectedBehaviors,
      'selectedDischarge': selectedDischarge,
      'sexualActivity': sexualActivity,
    };
  }
}

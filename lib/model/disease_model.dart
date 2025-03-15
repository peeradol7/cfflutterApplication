class DiseaseModel {
  String id;
  String type;
  List<Recommendation> recommendations;

  DiseaseModel({
    required this.id,
    required this.type,
    required this.recommendations,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json, String id) {
    return DiseaseModel(
      id: id,
      type: json['type'] ?? '',
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'recommendations': recommendations.map((e) => e.toJson()).toList(),
    };
  }
}

class Recommendation {
  String id;
  String attribute;
  Map<String, dynamic> recommendLevel;

  Recommendation({
    required this.id,
    required this.attribute,
    required this.recommendLevel,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'] as String,
      attribute: json['attribute'] as String,
      recommendLevel: json['recommendLevel'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attribute': attribute,
      'recommendLevel': recommendLevel,
    };
  }
}

class SelectedRecommendation {
  final String diseaseId;
  final String diseaseType;
  final List<RecommendationSelection> selections;

  SelectedRecommendation({
    required this.diseaseId,
    required this.diseaseType,
    required this.selections,
  });
}

class RecommendationSelection {
  final String recommendationId;
  final String attribute;
  final Map<String, dynamic> recommendLevels;

  RecommendationSelection({
    required this.recommendationId,
    required this.attribute,
    required this.recommendLevels,
  });
}

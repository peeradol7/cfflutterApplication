class KnowledgeListResponse {
  final String id;
  final String title;

  KnowledgeListResponse({required this.id, required this.title});

  factory KnowledgeListResponse.fromMap(String id, Map<String, dynamic> data) {
    return KnowledgeListResponse(
      id: id,
      title: data['title'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}

class KnowledgeModel {
  final String id;
  final String title;
  final List<Subtopic> subtopics;

  KnowledgeModel({
    required this.id,
    required this.title,
    required this.subtopics,
  });

  factory KnowledgeModel.fromJson(Map<String, dynamic> json, String id) {
    return KnowledgeModel(
      id: id,
      title: json['title'],
      subtopics: (json['subtopics'] as List)
          .map((item) => Subtopic.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtopics': subtopics.map((item) => item.toJson()).toList(),
    };
  }
}

class Subtopic {
  final int order;
  final String subtitle;
  final String content;

  Subtopic({
    required this.order,
    required this.subtitle,
    required this.content,
  });

  factory Subtopic.fromJson(Map<String, dynamic> json) {
    return Subtopic(
      order: json['order'],
      subtitle: json['subtitle'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'subtitle': subtitle,
      'content': content,
    };
  }
}

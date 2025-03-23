enum QuestionType {
  radio,
  checkbox,
  limitedCheckbox,
  textField,
}

class Question {
  final String id;
  String? question;
  final QuestionType? type;
  final List<String> options;
  final String hint;
  final String textInputSuffix;
  final (String, String)? dependsOn;
  final int? maxSelections;

  Question({
    required this.id,
    this.question,
    this.type,
    this.options = const [],
    this.hint = '',
    this.textInputSuffix = '',
    this.dependsOn,
    this.maxSelections,
  });
}

class Answer {
  final String questionId;
  dynamic value;

  Answer({required this.questionId, this.value});

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'value': value,
    };
  }

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      questionId: json['questionId'],
      value: json['value'],
    );
  }
}

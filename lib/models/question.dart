class Question {
  String question;
  String? option;

  Question({required this.question, this.option});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      option: json['option'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'option': "",
    };
  }
}

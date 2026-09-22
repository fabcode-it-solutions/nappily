class QuestionModel {
  final String question;
  bool? answer;

  QuestionModel({required this.question, this.answer});

  Map<String, dynamic> toMap() => {
    'question': question,
    'answer': answer ?? false,
  };
}

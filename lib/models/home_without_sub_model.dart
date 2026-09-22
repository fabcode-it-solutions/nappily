class HomeWithoutSubModel {
  final String title;
  final String description;
  final String question;

  HomeWithoutSubModel({
    required this.title,
    required this.description,
    required this.question,
  });

  factory HomeWithoutSubModel.fromMap(Map<String, dynamic> map) {
    return HomeWithoutSubModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      question: map['question'] ?? '',
    );
  }
}

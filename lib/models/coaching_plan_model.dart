class CoachingPlanModel {
  final String title;
  final String description;

  CoachingPlanModel({required this.title, required this.description});

  factory CoachingPlanModel.fromMap(Map<String, dynamic> map) {
    return CoachingPlanModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }
}

class FinishingModel {
  final String description;

  FinishingModel({required this.description});

  factory FinishingModel.fromMap(Map<String, dynamic> map) {
    return FinishingModel(description: map['description'] ?? '');
  }
}

class ExpertAdviceModel {
  final String id;
  final String name;
  final String price;
  final String billingCycle;
  final String planCycle;
  final List<String> rates;
  final List<String> features;

  ExpertAdviceModel({
    required this.id,
    required this.name,
    required this.price,
    required this.billingCycle,
    required this.planCycle,
    required this.rates,
    required this.features,
  });

  factory ExpertAdviceModel.fromMap(Map<String, dynamic> map, String id) {
    return ExpertAdviceModel(
      id: id,
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      billingCycle: map['billingCycle'] ?? '',
      planCycle: map['planCycle'] ?? '',
      rates: List<String>.from(map['rates'] ?? []),
      features: List<String>.from(map['features'] ?? []),
    );
  }
}

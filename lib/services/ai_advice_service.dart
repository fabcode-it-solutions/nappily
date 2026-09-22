import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notizen/models/ai_advice_model.dart';

class AiAdviceService {
  final _collection = FirebaseFirestore.instance.collection('app-data');

  Future<List<AiAdviceModel>> fetchAllPlans() async {
    final query = await _collection.doc("8ogHvb5M7PX5CXe9lCAE").get();
    if (query.exists) {
      final data = query.data()!;
      final List<dynamic> list = data['expert-plan'];
      return list.map((doc) {
        return AiAdviceModel.fromMap(doc, query.id);
      }).toList();
    } else {
      return [];
    }
  }
}

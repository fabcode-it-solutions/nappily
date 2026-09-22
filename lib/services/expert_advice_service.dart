import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notizen/models/exprt_advice_model.dart';

class ExpertAdviceService {
  final _collection = FirebaseFirestore.instance.collection('app-data');

  Future<List<ExpertAdviceModel>> fetchAllPlans(String type) async {
    final query = await _collection.doc("8ogHvb5M7PX5CXe9lCAE").get();
    if (query.exists) {
      final data = query.data()!;
      final List<dynamic> list = data[type];
      return list.map((doc) {
        return ExpertAdviceModel.fromMap(doc, query.id);
      }).toList();
    } else {
      return [];
    }
  }
}

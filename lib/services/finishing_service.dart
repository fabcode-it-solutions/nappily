import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notizen/models/finishing_model.dart';

class FinishingService {
  final _collection = FirebaseFirestore.instance.collection('app-data');

  Future<List<FinishingModel>> fetchResults() async {
    final doc = await _collection.doc("8ogHvb5M7PX5CXe9lCAE").get();
    final data = doc.data();

    if (data == null || data['finishing'] == null) return [];

    final List<dynamic> resultList = data['finishing'];
    return resultList.map((item) => FinishingModel.fromMap(item)).toList();
  }
}

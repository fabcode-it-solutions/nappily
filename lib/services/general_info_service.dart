import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notizen/models/general_info_model.dart';

class GeneralInfoService {
  final _collection = FirebaseFirestore.instance.collection('app-data');

  Future<List<Section>> fetchSections() async {
    final snapshot = await _collection.doc('8ogHvb5M7PX5CXe9lCAE').get();
    if (!snapshot.exists) return [];
    final data = snapshot.data();

    if (data == null || data['general-info'] == null) return [];
    final List<dynamic> resultList = data['general-info'];
    return resultList.map((doc) => Section.fromMap(doc)).toList();
  }
}

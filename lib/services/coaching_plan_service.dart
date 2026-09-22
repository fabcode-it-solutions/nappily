import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notizen/models/coaching_plan_model.dart';

class CoachingPlanService {
  final _collection = FirebaseFirestore.instance.collection('app-data');

  Future<List<CoachingPlanModel>> fetchResults() async {
    final docId = '8ogHvb5M7PX5CXe9lCAE';
    final doc = await _collection.doc(docId).get();
    final data = doc.data();

    if (data == null || data['coaching-plans'] == null) return [];

    final List<dynamic> resultList = data['coaching-plans'];
    // return resultList.map((item) => CoachingPlanModel.fromMap(item)).toList();
    final allSuggestions =
        resultList.map((doc) => CoachingPlanModel.fromMap(doc)).toList();

    allSuggestions.shuffle(Random());
    return allSuggestions.take(2).toList();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notizen/models/question_result_model.dart';

class ResultService {
  final _collection = FirebaseFirestore.instance.collection('questionnaires');

  Future<List<QuestionResultModel>> fetchResults(String userId) async {
    final doc = await _collection.doc(userId).get();
    final data = doc.data();

    if (data == null || data['answers'] == null) return [];

    final List<dynamic> resultList = data['answers'];
    return resultList.map((item) => QuestionResultModel.fromMap(item)).toList();
  }
}

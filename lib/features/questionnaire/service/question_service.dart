import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notizen/features/questionnaire/model/question_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuestionService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<List<QuestionModel>> fetchQuestions() async {
    final doc =
        await _db.collection('app-data').doc('8ogHvb5M7PX5CXe9lCAE').get();
    final List<dynamic> questions = doc.data()?['questions'] ?? [];
    return questions.map((q) => QuestionModel(question: q.toString())).toList();
  }

  Future<bool> saveUserResponses(List<QuestionModel> responses) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;
      final answers = responses.map((q) => q.toMap()).toList();

      await _db.collection('questionnaires').doc(user.uid).set({
        'answers': answers,
        'timestamp': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}

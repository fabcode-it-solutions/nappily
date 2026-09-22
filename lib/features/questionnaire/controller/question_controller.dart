import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/features/questionnaire/model/question_model.dart';
import 'package:notizen/features/questionnaire/service/question_service.dart';

final questionServiceProvider = Provider((ref) => QuestionService());

final questionListProvider = FutureProvider<List<QuestionModel>>((ref) async {
  final service = ref.read(questionServiceProvider);
  return await service.fetchQuestions();
});

final questionStateProvider =
    StateNotifierProvider<QuestionStateController, List<QuestionModel>>((ref) {
      return QuestionStateController([]);
    });

class QuestionStateController extends StateNotifier<List<QuestionModel>> {
  QuestionStateController(super.initial);

  void setQuestions(List<QuestionModel> questions) {
    state = questions;
  }

  void setAnswer(int index, bool answer) {
    if (index < 0 || index >= state.length) return;
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          QuestionModel(question: state[i].question, answer: answer)
        else
          state[i],
    ];
  }

  double get progress {
    if (state.isEmpty) return 0;
    final answered = state.where((q) => q.answer != null).length;
    return answered / state.length;
  }
}

final pageProvider = StateProvider<int>((ref) => 0);
final submitLoadingProvider = StateProvider<int>((ref) => 0);
final isResponseSaved = StateProvider<bool>((ref) => false);

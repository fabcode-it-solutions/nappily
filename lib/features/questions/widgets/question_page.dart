import 'package:flutter/material.dart';
import 'package:notizen/features/questions/widgets/question_card.dart';

class QuestionPage extends StatelessWidget {
  final List<dynamic> questions;
  final Function(String, String) onAnswerChanged;

  const QuestionPage({
    Key? key,
    required this.questions,
    required this.onAnswerChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: questions.length,
      itemBuilder: (context, index) {        
        return Padding(
          padding: const EdgeInsets.only(bottom: 22),
          child: QuestionCard(
            question: questions[index],
            index: index,
            onAnswerChanged: onAnswerChanged,
          ),
        );
      },
    );
  }
}

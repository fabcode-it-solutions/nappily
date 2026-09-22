import 'package:flutter/material.dart';
import 'package:notizen/features/questionnaire/controller/question_controller.dart';
import 'package:notizen/features/questionnaire/model/question_model.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({
    super.key,
    required this.controller,
    required this.realIndex,
    required this.question,
    required this.title,
    required this.fieldValue,
  });

  final QuestionStateController controller;
  final int realIndex;
  final QuestionModel question;
  final String title;
  final bool fieldValue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.setAnswer(realIndex, fieldValue),
      child: Container(
        padding: const EdgeInsets.only(bottom: 8, left: 5),
        child: Row(
          children: [
            Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color:
                          question.answer == fieldValue
                              ? Color(0XFF5CA99F)
                              : Colors.transparent,
                      border:
                          question.answer == fieldValue
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.white, width: 1),
                    ),
                    margin: EdgeInsets.all(0),
                  ),
                ),
                Icon(
                  Icons.check,
                  color:
                      question.answer == fieldValue
                          ? Colors.white
                          : Colors.transparent,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(width: 3),
            Text(
              title,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

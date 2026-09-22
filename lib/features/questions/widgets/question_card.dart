import 'package:flutter/material.dart';

class QuestionCard extends StatefulWidget {
  final dynamic question;
  final int index;
  final Function(String, String) onAnswerChanged;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.index,
    required this.onAnswerChanged,
  }) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String isSelected = '';
  @override
  Widget build(BuildContext context) {
    List<String> displayOptions = ['Yes', 'No'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0x1A5CA99F), 
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
            child: Text(
              "Q${widget.question?['index'] + 1}: ${widget.question?['text']}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontFamily: 'Poppins',
                letterSpacing: 0,
                height: 1.2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        Row(
          children:
              displayOptions.map((option) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected = option;
                            // widget.onAnswerChanged(widget.question.id, option);
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color:
                                    isSelected == option
                                        ? const Color(0xFF5CA99F)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(
                                  color:
                                      isSelected == option
                                          ? const Color(0xFF5CA99F)
                                          : Color(0xFFFFFFFF),
                                  width: 1,
                                ),
                              ),
                              child:
                                  isSelected == option
                                      ? const Icon(
                                        Icons.check,
                                        size: 8,
                                        color: Colors.white,
                                      )
                                      : null,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              option,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}

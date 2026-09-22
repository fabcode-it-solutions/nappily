import 'package:flutter/material.dart';

class CustomRadioWidget extends StatelessWidget {
  const CustomRadioWidget({
    super.key,
    required this.successAnswer,
    required this.onTap,
    required this.value,
    required this.title,
  });

  final bool? successAnswer;
  final VoidCallback onTap;
  final bool value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                          successAnswer == value
                              ? Color(0XFF5CA99F)
                              : Colors.transparent,
                      border:
                          successAnswer == value
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.white, width: 1),
                    ),
                    margin: EdgeInsets.all(0),
                  ),
                ),
                Icon(
                  Icons.check,
                  color:
                      successAnswer == value
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

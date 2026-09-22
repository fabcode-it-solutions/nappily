import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.onTap,
    required this.fieldKey,
    required this.title,
    required this.fieldValue,
    this.checkboxRadius,
    this.iconSize,
    this.mainContainerPadding,
    this.strikethrough,
  });

  final VoidCallback onTap;
  final String fieldKey;
  final String title;
  final String fieldValue;
  final double? checkboxRadius;
  final double? iconSize;
  final EdgeInsetsGeometry? mainContainerPadding;
  final bool? strikethrough;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: mainContainerPadding ?? EdgeInsets.only(bottom: 16, left: 5),
        child: Row(
          children: [
            Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(checkboxRadius ?? 3),
                      color:
                          fieldKey == fieldValue
                              ? Color(0XFF5CA99F)
                              : Colors.transparent,
                      border:
                          fieldKey == fieldValue
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.white, width: 1),
                    ),
                    margin: EdgeInsets.all(0),
                  ),
                ),
                Icon(
                  Icons.check,
                  color:
                      fieldKey == fieldValue
                          ? Colors.white
                          : Colors.transparent,
                  size: iconSize ?? 16,
                ),
              ],
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color:
                    fieldKey == fieldValue && strikethrough == true
                        ? Color(0XFF5CA99F)
                        : Colors.white,
                decoration:
                    fieldKey == fieldValue && strikethrough == true
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,

                decorationColor: Color(0XFF5CA99F),
                decorationThickness: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

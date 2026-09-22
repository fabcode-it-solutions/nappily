import 'package:flutter/material.dart';

class CustomButtonRightIcon extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool isOutlined;
  final Alignment buttonTextAlign;
  final double buttonTextSize;
  final FontWeight buttonFontWeight;

  final Icon rightIcon;

  const CustomButtonRightIcon({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0XFF5CA99F),
    this.textColor = Colors.white,
    this.isOutlined = false,
    this.buttonTextAlign = Alignment.center,
    this.buttonTextSize = 16,
    this.buttonFontWeight = FontWeight.w500,
    this.rightIcon = const Icon(Icons.navigate_next, size: 30),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutlined ? Colors.transparent : backgroundColor,
        foregroundColor: textColor,
        side:
            isOutlined
                ? BorderSide(color: textColor, width: 1)
                : BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Color(0XFFFFFFFF),
              fontSize: buttonTextSize,
              fontWeight: buttonFontWeight,
              fontFamily: "Poppins",
            ),
          ),
          rightIcon,
        ],
      ),

      // child: Align(
      //   alignment: buttonTextAlign,
      //   child:
      // Text(
      //     text,
      //     style: TextStyle(
      //       color: Color(0XFFFFFFFF),
      //       fontSize: buttonTextSize,
      //       fontWeight: buttonFontWeight,
      //       fontFamily: "Poppins",
      //     ),
      //   ),
      // ),
    );
  }
}

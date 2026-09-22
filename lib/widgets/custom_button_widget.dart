import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool isOutlined;
  final Alignment buttonTextAlign;
  final double buttonTextSize;
  final FontWeight buttonFontWeight;
  final double height;
  final EdgeInsets? buttonPadding;

  const CustomButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0XFF5CA99F),
    this.textColor = Colors.white,
    this.isOutlined = false,
    this.buttonTextAlign = Alignment.center,
    this.buttonTextSize = 16,
    this.buttonFontWeight = FontWeight.w500,
    this.height = 64,
    this.buttonPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: buttonPadding,
          backgroundColor: isOutlined ? Colors.transparent : backgroundColor,
          foregroundColor: textColor,
          side:
              isOutlined
                  ? BorderSide(color: textColor, width: 1)
                  : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Align(
          alignment: buttonTextAlign,
          child: Text(
            text,
            style: TextStyle(
              color: Color(0XFFFFFFFF),
              fontSize: buttonTextSize,
              fontWeight: buttonFontWeight,
              fontFamily: "Poppins",
            ),
          ),
        ),
      ),
    );
  }
}

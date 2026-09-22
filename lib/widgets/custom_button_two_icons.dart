import 'package:flutter/material.dart';

class CustomButtonTwoIcons extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool isOutlined;
  final Alignment buttonTextAlign;
  final double buttonTextSize;
  final FontWeight buttonFontWeight;
  final ImageIcon leftIcon;
  final Icon rightIcon;

  const CustomButtonTwoIcons({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0XFF5CA99F),
    this.textColor = Colors.white,
    this.isOutlined = false,
    this.buttonTextAlign = Alignment.center,
    this.buttonTextSize = 16,
    this.buttonFontWeight = FontWeight.w500,
    this.leftIcon = const ImageIcon(
      AssetImage("assets/images/icons/info-icon.png"),
      color: Colors.white,
      size: 20,
    ),
    this.rightIcon = const Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.white,
      size: 20,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
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
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            leftIcon,
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
      ),
    );
  }
}

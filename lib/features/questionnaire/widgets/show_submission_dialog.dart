import 'package:flutter/material.dart';
import 'package:notizen/widgets/custom_button_right_icon.dart';
import 'package:notizen/widgets/custom_button_widget.dart';

void showFullScreenSubmissionDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Submission Dialog",
    pageBuilder: (context, animation, secondaryAnimation) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F0D1D), Color(0xFF443B83)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      "Subscribe to Unlock More!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(height: 24),

                    Card(
                      elevation: 0,
                      color: Color(0X1A5CA99F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                        side: BorderSide.none,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Multiple sleeping barriers detected. Let's tackle them together to get your baby and yourself a good sleep.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    CustomButtonRightIcon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: "Experts Advice",
                      rightIcon: Icon(
                        Icons.info,
                        color: Color(0XFF5CA99F),
                        size: 20,
                      ),
                      isOutlined: true,
                    ),
                    const SizedBox(height: 16),
                    CustomButtonRightIcon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: "AI Advice",
                      rightIcon: Icon(
                        Icons.info,
                        color: Color(0XFF5CA99F),
                        size: 20,
                      ),
                      isOutlined: true,
                    ),

                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      width: double.infinity,
                      child: CustomButtonWidget(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: "Continue without Expert and AI Advice",
                        isOutlined: true,
                        buttonTextSize: 12,
                        height: 50,
                      ),
                    ),
                    const SizedBox(height: 50),

                    CustomButtonWidget(
                      text: "Subscribe Now",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

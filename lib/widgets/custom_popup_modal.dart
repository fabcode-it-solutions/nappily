import 'package:flutter/material.dart';
import 'package:notizen/widgets/custom_button_widget.dart';

class CustomPopupModal extends StatelessWidget {
  final String title;
  final String message;
  final String? plan;
  final String? renewalDate;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Icon icon;
  final bool planDetails;

  const CustomPopupModal({
    super.key,
    required this.title,
    required this.message,
    this.plan,
    this.renewalDate,
    required this.buttonText,
    required this.onButtonPressed,
    this.icon = const Icon(
      Icons.check_circle_outline_sharp,
      size: 90,
      color: Colors.white,
      weight: 200,
    ),
    this.planDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Color(0X1A5CA99F),
        child: Container(
          width: MediaQuery.of(context).size.width - 48,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0XFF5CA99F)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: "Poppins",
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (planDetails)
                Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Plan:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          plan ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white),
                    Row(
                      children: [
                        const Text(
                          "Renewal Date:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          renewalDate ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              CustomButtonWidget(text: buttonText, onPressed: onButtonPressed),
            ],
          ),
        ),
      ),
    );
  }
}

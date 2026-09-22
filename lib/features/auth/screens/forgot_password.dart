import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/auth/controller/forgot_password_controller.dart';
import 'package:notizen/widgets/custom_button_widget.dart';
import 'package:notizen/widgets/text_field_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ForgotPasswordController controller = ForgotPasswordController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0D1D), Color(0xFF443B83)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.mirror,
          ),
        ),
        child: Center(
          widthFactor: double.infinity,
          heightFactor: double.infinity,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
                minWidth:
                    MediaQuery.of(context).size.width -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 25,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0XFF5CA99F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SvgPicture.asset(
                        'assets/images/password-key.svg',
                        height: 58,
                        width: 58,
                      ),
                    ),
                    SizedBox(height: 25),
                    CustomTextField(
                      controller: controller.emailController,
                      placeholder: 'Email',
                      obscureText: false,
                    ),
                    SizedBox(height: 20),
                    CustomButtonWidget(
                      text: 'Reset Password',
                      backgroundColor: Color(0XFF5CA99F),
                      onPressed: () => controller.resetPassword(context),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).go('/login');
                      },
                      child: const Text(
                        "Back to login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0X80FFFFFF),
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

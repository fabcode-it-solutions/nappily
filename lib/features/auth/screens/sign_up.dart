import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:notizen/features/auth/controller/signup_controller.dart';
import 'package:notizen/features/auth/widgets/social_buttons.dart';
import 'package:notizen/widgets/custom_button_widget.dart';
import 'package:notizen/widgets/text_field_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signupController = SignupController();

  @override
  void dispose() {
    _signupController.dispose();
    super.dispose();
  }

  Future<void> handleSignup(state) async {
    final errorMessage = await _signupController.signUp(state);
    if (errorMessage != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } else {
      if (!mounted) return;
      GoRouter.of(context).push("/verify-email");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                    color: Color(0XFFFFFFFF),
                    fontFamily: "Poppins",
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  placeholder: "Name",
                  controller: _signupController.nameController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  placeholder: "Email",
                  controller: _signupController.emailController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  placeholder: "Password",
                  controller: _signupController.passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  placeholder: "Confirm Password",
                  controller: _signupController.confirmPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                CustomButtonWidget(
                  text: "Sign Up",
                  backgroundColor: Color(0XFF5CA99F),
                  onPressed: () {
                    handleSignup(this);
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Color(0X80FFFFFF),
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push('/login');
                      },
                      child: const Text(
                        "(Log in)",
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
                const SizedBox(height: 20),
                const Text(
                  "Or",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: "Poppins",
                  ),
                ),
                const SizedBox(height: 20),
                SocialButtons(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

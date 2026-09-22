import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/auth/controller/login_controller.dart';
import 'package:notizen/features/auth/widgets/social_buttons.dart';
import 'package:notizen/widgets/custom_button_widget.dart';
import 'package:notizen/widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = LoginController();

  @override
  void dispose() {
    loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Login Your Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: loginController.emailController,
                    placeholder: 'Email',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: loginController.passwordController,
                    placeholder: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  CustomButtonWidget(
                    text: "Login",
                    backgroundColor: Color(0XFF5CA99F),
                    onPressed: () async {
                      final user = await loginController.loginUser(this);
                      if (user != null) {
                        if (!context.mounted) return;
                        GoRouter.of(context).go("/settings");
                      } else {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Login Failed. Please try again later.",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).push('/forgot-password');
                    },
                    child: const Text(
                      "Forgot password?",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0X80FFFFFF),
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don’t have account? ",
                        style: TextStyle(
                          color: Color(0X80FFFFFF),
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push('/sign-up');
                        },
                        child: const Text(
                          "Signup",
                          style: TextStyle(
                            color: Color(0XCCFFFFFF),
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
                    textAlign: TextAlign.center,
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
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/auth/controller/auth_controller.dart';

class SocialButtons extends StatelessWidget {
  SocialButtons({super.key});
  final authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            final user = await authController.signInWithApple();
            if (user != null) {
              // print("Google sign-in successful: ${user.user?.email}");
              // Navigate or update UI
            } else {
              print("Google sign-in failed.");
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              'assets/images/apple-icon.png',
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () async {
            final user = await authController.signInWithGoogle(context);
            if (user != null) {
              if (context.mounted) {
                GoRouter.of(context).go("/settings");
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Google Sign up failed. Please try again"),
                  ),
                );
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              'assets/images/google-icon.png',
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () async {
            final user = await authController.signInWithFacebook();
            if (user != null) {
              print("Google sign-in successful: ${user.user?.email}");
              // Navigate or update UI
            } else {
              print("Google sign-in failed.");
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              'assets/images/fb-icon.png',
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

extension on User {
  get user => null;
}

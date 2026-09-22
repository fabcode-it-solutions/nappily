import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/auth/auth.dart';
import 'package:notizen/models/user_model.dart';
import 'package:notizen/services/user_firestore_service.dart';
import 'package:notizen/utils/user_local_storage.dart';

class LoginController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<User?> loginUser(State state) async {
    try {
      final auth = FirebaseAuth.instance;
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        if (!user.emailVerified) {
          if (state.mounted) {
            ScaffoldMessenger.of(state.context).showSnackBar(
              SnackBar(
                content: Text(
                  "You have not verify your email yet. Please verify your email then login again.",
                ),
              ),
            );
          }
          if (state.mounted) {
            GoRouter.of(state.context).push("/verify-email");
          }
          return null;
        }
        final userService = UserFirestoreService();
        UserModel? userData = await userService.getUser(user.uid);
        if (userData != null) {
          await UserLocalStorage.saveUserData(
            email: userData.email,
            name: userData.name,
            uid: user.uid,
          );
          if (state.mounted) {
            await AppAuth.of(state.context).signIn();
          }
        } else {
          await UserLocalStorage.saveUserData(
            email: email,
            name: email,
            uid: user.uid,
          );
        }
        if (state.mounted) {
          await AppAuth.of(state.context).signIn();
        }
      }

      return user;
    } catch (e) {
      if (kDebugMode) {
        print("Login Failed: ${e.toString()}");
      }
      return null;
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

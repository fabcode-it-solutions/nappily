import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notizen/models/user_model.dart';
import 'package:notizen/services/user_firestore_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:notizen/utils/user_local_storage.dart';

class SignupController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? validateInputs() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return "Please fill all fields";
    }

    if (!EmailValidator.validate(email)) {
      return "Enter a valid email";
    }

    if (password.length < 6) {
      return "Password must be at least 6 characters";
    }

    if (password != confirmPassword) {
      return "Passwords do not match";
    }

    return null;
  }

  Future<String?> signUp(State state) async {
    try {
      final error = validateInputs();
      if (error != null) return error;

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final uid = userCredential.user!.uid;
      final email = emailController.text.trim();
      final name = nameController.text.trim();

      final userService = UserFirestoreService();
      await userService.createUser(
        UserModel(uid: uid, email: email, name: name),
      );
      await UserLocalStorage.saveUserData(email: email, name: name, uid: uid);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      if (state.mounted) {
        ScaffoldMessenger.of(state.context).showSnackBar(
          SnackBar(content: Text("Signup Failed: ${e.toString()}")),
        );
      }
      return null;
    }
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}

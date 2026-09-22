import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notizen/features/auth/auth.dart';
import 'package:notizen/models/user_model.dart';
import 'package:notizen/services/user_firestore_service.dart';
import 'package:notizen/utils/user_local_storage.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final email = userCredential.user?.email ?? "";
      final name = userCredential.user?.displayName ?? "";
      final uid = userCredential.user?.uid ?? "";
      await UserLocalStorage.saveUserData(email: email, name: name, uid: uid);

      final userService = UserFirestoreService();
      await userService.createUser(
        UserModel(uid: uid, email: email, name: name),
      );
      if (context.mounted) {
        await AppAuth.of(context).signIn();
      }
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print("Google Sign-In Failed: $e");
      }
      return null;
    }
  }

  Future<void> signOut() async {
    if (await _googleSignIn.isSignedIn()) {
      _googleSignIn.signOut();
      GoogleSignIn().disconnect();
    }
    _auth.signOut();
  }

  Future<User?> signInWithApple() async {
    return null;
  }

  Future<User?> signInWithFacebook() async {
    return null;
  }
}

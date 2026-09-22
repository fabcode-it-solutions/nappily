import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/models/user_model.dart';
import 'package:notizen/services/user_firestore_service.dart';

final userServiceProvider = Provider((ref) => UserFirestoreService());
final _auth = FirebaseAuth.instance;
File? babyImage;
String? base64Image;

final userControllerProvider =
    StateNotifierProvider<UserController, AsyncValue<UserModel?>>((ref) {
      return UserController(ref);
    });

class UserController extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref ref;
  UserController(this.ref) : super(const AsyncValue.loading()) {
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      final uid = _auth.currentUser?.uid;
      final user = await ref.read(userServiceProvider).getUser(uid!);

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateUser(UserModel updatedUser) async {
    try {
      await ref.read(userServiceProvider).updateUserProfile(updatedUser);
      state = AsyncValue.data(updatedUser);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

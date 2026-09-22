import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notizen/models/user_model.dart';

class UserFirestoreService {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  final _auth = FirebaseAuth.instance;

  Future<void> createUser(UserModel user) async {
    await users.doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await users.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await users.doc(uid).update(data);
  }

  Future<void> deleteUser(String uid) async {
    await users.doc(uid).delete();
  }

  Future<void> updateUserProfile(UserModel user) async {
    await users.doc(user.uid).update(user.toMap());
    await _auth.currentUser?.updateDisplayName(user.name);
    // await _auth.currentUser?.updatePhoneNumber(
    //   PhoneAuthProvider.credential(
    //     verificationId: '',
    //     smsCode: '',
    //   ),
    // );
  }
}

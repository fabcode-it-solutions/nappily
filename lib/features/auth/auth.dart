import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:notizen/utils/user_local_storage.dart';

class AppAuth extends ChangeNotifier {
  bool _signedIn = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool get signedIn => _signedIn;
  AppAuth() {
    _initAuth();
  }
  Future<void> _initAuth() async {
    var data = await UserLocalStorage.getUserData();
    _signedIn = data != null;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No authenticated user");
    await _firestore.collection('users').doc(user.uid).delete();
    await user.delete();
  }

  Future<void> signOut() async {
    _signedIn = false;
    notifyListeners();
  }

  Future<bool> signIn() async {
    var data = await UserLocalStorage.getUserData();
    if (data != null) {
      _signedIn = true;
    }
    notifyListeners();
    return _signedIn;
  }

  Future<void> reauthenticate(String email, String password) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await user?.reauthenticateWithCredential(cred);
  }

  @override
  bool operator ==(Object other) =>
      other is AppAuth && other._signedIn == _signedIn;

  @override
  int get hashCode => _signedIn.hashCode;

  static AppAuth of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppAuthScope>();
    if (scope == null || scope.notifier == null) {
      throw FlutterError(
        'AppAuth.of() called with a context that does not contain AppAuth.\n'
        'Make sure AppAuthScope is above your context in the widget tree.',
      );
    }
    return scope.notifier!;
  }
}

class AppAuthScope extends InheritedNotifier<AppAuth> {
  const AppAuthScope({
    required super.notifier,
    required super.child,
    super.key,
  });
}

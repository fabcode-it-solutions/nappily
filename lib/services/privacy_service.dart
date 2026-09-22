import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notizen/models/privacy_model.dart';

class PrivacyPolicyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PrivacyPolicyOption>> fetchUserOptions(String userId) async {
    final doc = await _firestore.collection('app-data').doc(userId).get();
    final data = doc.data()?['privacy-consents'] ?? [];

    return List<Map<String, dynamic>>.from(data).map((e) {
      return PrivacyPolicyOption.fromMap(e);
    }).toList();
  }

  Future<void> saveUserOptions(
    String userId,
    List<PrivacyPolicyOption> options,
  ) async {
    await _firestore.collection('privacy-consents').doc(userId).set({
      'privacyPolicy': options.map((e) => e.toMap()).toList(),
    }, SetOptions(merge: true));
  }
}

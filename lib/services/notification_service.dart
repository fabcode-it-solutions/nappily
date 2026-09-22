import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notizen/models/notification_preference.dart';

class NotificationService {
  final _firestore = FirebaseFirestore.instance;

  Future<NotificationSettingsModel?> getNotificationSettings(uid) async {
    if (uid == null) return null;

    final doc = await _firestore.collection('notifications').doc(uid).get();
    if (doc.exists) {
      return NotificationSettingsModel.fromMap(doc.data()!);
    } else {
      return null;
    }
  }

  Future<void> saveNotificationSettings(
    NotificationSettingsModel settings,
    uid,
  ) async {
    if (uid == null) throw Exception('User not logged in');

    await _firestore.collection('notifications').doc(uid).set(settings.toMap());
  }
}

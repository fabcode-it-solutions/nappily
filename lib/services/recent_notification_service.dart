import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notizen/models/recent_notification_model.dart';

class AppNotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveNotification(
    String userId,
    AppNotification notification,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(notification.toMap());
  }

  Future<void> markNotificationAsRead({
    required String userId,
    required String notificationId,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId);

    await docRef.update({'isRead': true});
  }

  Future<List<AppNotification>> fetchNotifications({
    required String userId,
    required int limit,
    DateTime? startAfterTimestamp,
    String? startAfterId,
    bool newestFirst = true,
  }) async {
    Query query = _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        // .orderBy('timestamp', descending: newestFirst)
        .orderBy('id', descending: newestFirst)
        .limit(limit);

    if (startAfterTimestamp != null && startAfterId != null) {
      query = query.startAfter([startAfterId]);
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) => AppNotification.fromDoc(doc)).toList();
  }

  Future<void> markAllAsRead(String userId) async {
    final batch = _firestore.batch();
    final unread =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .where('isRead', isEqualTo: false)
            .get();

    for (var doc in unread.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  Future<void> markAsRead(String userId, String notificationId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  Future<void> deleteNotification(String userId, String notificationId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notizen/models/home_model.dart';
import 'package:notizen/utils/time_coversion.dart';

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<HomeModel>> fetchHurdles(String userId) async {
    final doc =
        await _firestore
            .collection('app-data')
            .doc("8ogHvb5M7PX5CXe9lCAE")
            .get();
    final data = doc.data();
    if (data == null || data['home-items']['hurdles'] == null) return [];

    return List<HomeModel>.from(
      (data['home-items']['hurdles'] as List).map((e) => HomeModel.fromMap(e)),
    );
  }

  Future<List> fetchSolvedHurdleIds(String userId) async {
    final doc =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection("hurdle_responses")
            .where("status", whereIn: ["completed", "started"])
            .get();
    if (doc.docs.isEmpty) return [];
    final data = doc.docs;
    return data.map((e) => e.data()).toList();
  }

  Future<String?> fetchHurdleOfTheDay(String userId) async {
    final doc = await _firestore.collection('user_hurdles').doc(userId).get();
    final data = doc.data();
    return data?['hurdleOfTheDay'];
  }

  Future<void> markHurdleAsSolved(String userId, String hurdleId) async {
    final ref = _firestore.collection('user_hurdles').doc(userId);
    await ref.set({
      'solved': FieldValue.arrayUnion([hurdleId]),
    }, SetOptions(merge: true));
  }

  Future<DateTime?> fetchSleepTime(String userId) async {
    final doc =
        await _firestore
            .collection('baby_profiles')
            .where("userId", isEqualTo: userId)
            .get();
    if (doc.docs.isNotEmpty) {
      final data = doc.docs.first.data();
      final sleepTime = TimeConverter.convertStringToTimeOfDay(
        data['sleepTime'],
      );
      final now = DateTime.now();
      return DateTime(
        now.year,
        now.month,
        now.day,
        sleepTime.hour,
        sleepTime.minute,
      );
    } else {
      return null;
    }
  }

  DocumentReference<Map<String, dynamic>> _responseDoc(
    String hurdleId,
    String userId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('hurdle_responses')
        .doc(hurdleId);
  }

  Future<List<ChecklistItem>> getChecklist(
    String hurdleId,
    List<String> checklistIds,
    String userId,
  ) async {
    final doc = await _responseDoc(hurdleId, userId).get();
    if (doc.exists && doc.data()?['checklist'] != null) {
      return (doc['checklist'] as List)
          .map((e) => ChecklistItem.fromMap(e))
          .toList();
    } else {
      return checklistIds
          .map((id) => ChecklistItem(id: id, isChecked: false))
          .toList();
    }
  }

  Stream<List<ChecklistItem>> listenChecklist(
    String hurdleId,
    List<String> checklistIds,
    String userId,
  ) {
    return _responseDoc(hurdleId, userId).snapshots().map((doc) {
      if (doc.exists && doc.data()?['checklist'] != null) {
        return (doc['checklist'] as List)
            .map((e) => ChecklistItem.fromMap(e))
            .toList();
      } else {
        return checklistIds
            .map((id) => ChecklistItem(id: id, isChecked: false))
            .toList();
      }
    });
  }

  Future<void> updateChecklist(
    String hurdleId,
    List<ChecklistItem> checklist,
    String userId,
  ) async {
    final checkedCount = checklist.where((item) => item.isChecked).length;
    final status =
        checkedCount == 0
            ? 'not_started'
            : checkedCount == checklist.length
            ? 'completed'
            : 'started';

    await _responseDoc(hurdleId, userId).set({
      'checklist': checklist.map((e) => e.toMap()).toList(),
      'status': status,
      'hurdleId': hurdleId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<String?> getHurdleStatus(String hurdleId, String userId) {
    return _responseDoc(hurdleId, userId).snapshots().map((doc) {
      return doc.exists ? doc.data()!['status'] as String? : 'not_started';
    });
  }
}

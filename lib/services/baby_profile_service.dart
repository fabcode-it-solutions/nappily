import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notizen/models/baby_profile_model.dart';

class BabyProfileService {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'baby_profiles';

  Future<void> addBabyProfile(BabyProfile profile) async {
    await _firestore
        .collection(_collection)
        .doc(profile.id)
        .set(profile.toJson(), SetOptions(merge: true));
  }

  Future<BabyProfile?> getBabyProfile(String userId) async {
    try {
      final doc =
          await _firestore
              .collection(_collection)
              .where("userId", isEqualTo: userId)
              .get();
      if (doc.docs.isNotEmpty) {
        return BabyProfile.fromJson(doc.docs.first.data());
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching baby profile: $e');
      return null;
    }
  }
}

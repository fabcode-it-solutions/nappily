import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notizen/models/home_without_sub_model.dart';

final homeWithoutSubProvider = FutureProvider<HomeWithoutSubModel>((ref) async {
  try {
    final doc =
        await FirebaseFirestore.instance
            .collection('app-data')
            .doc('8ogHvb5M7PX5CXe9lCAE')
            .get();

    if (!doc.exists) {
      throw Exception("Document not found");
    }
    final data = doc.data()!;
    final list = data['home-without-subscription'];
    return HomeWithoutSubModel.fromMap(list);
  } catch (e, stack) {
    debugPrint('Error in contentProvider: $e');
    debugPrintStack(stackTrace: stack);
    rethrow;
  }
});

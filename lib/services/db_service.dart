import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  Future<void> updateArrayField({
    required String collectionPath,
    required String documentId,
    required String arrayField,
    required dynamic newValue,
  }) async {
    try {
      final docRef = _firestore.collection(collectionPath).doc(documentId);

      await docRef.update({
        arrayField: FieldValue.arrayUnion([newValue]),
      });

      print('Array field updated successfully.');
    } catch (e) {
      print('Error updating array field: $e');
    }
  }
}

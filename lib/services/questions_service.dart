import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionsService {
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
  Future<dynamic> getFieldFromDocument({
  required String collectionPath,
  required String documentId,
  required String fieldName,
}) async {
  try {    
    final docRef = _firestore.collection(collectionPath).doc(documentId);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      return docSnapshot.data()?[fieldName];
    } else {    
      return null;
    }
  } catch (e) {
    
    return null;
  }
}
}




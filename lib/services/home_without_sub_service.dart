import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notizen/models/home_without_sub_model.dart';

class HomeWithoutSubService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<HomeWithoutSubModel?> fetchContent() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('content').doc('screen1').get();

      if (doc.exists) {
        return HomeWithoutSubModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error fetching content: $e");
      return null;
    }
  }
}

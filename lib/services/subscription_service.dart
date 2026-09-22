import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notizen/models/subscription_plan_model.dart';
import 'package:notizen/utils/user_local_storage.dart';

class SubscriptionService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<SubscriptionPlanModel>> fetchSubscriptionPlans() async {
    final doc =
        await _firestore
            .collection('app-data')
            .doc('8ogHvb5M7PX5CXe9lCAE')
            .get();

    if (!doc.exists) {
      throw Exception('Subscription plans not found');
    }

    final data = doc.data()!;
    final subscriptionPlans =
        data['subscription-plans'] as Map<String, dynamic>;

    List<SubscriptionPlanModel> plans = [];

    subscriptionPlans.forEach((key, value) {
      plans.add(
        SubscriptionPlanModel(
          name: key,
          price: value['plan_price'] ?? '0.0',
          popular: value['popular'] ?? false,
        ),
      );
    });

    return plans;
  }

  Future<void> saveUserSubscription(
    String selectedPlanName,
    String selectedPlanPrice,
  ) async {
    final user = await UserLocalStorage.getUserData();
    if (user == null) throw Exception('User not logged in');

    await _firestore.collection('user-subscriptions').doc(user['uid']).set({
      'plan_name': selectedPlanName,
      'plan_price': selectedPlanPrice,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<String?> fetchUserSelectedPlanName() async {
    final user = await UserLocalStorage.getUserData();
    if (user == null) throw Exception('User not logged in');

    final doc =
        await _firestore
            .collection('user-subscriptions')
            .doc(user['uid'])
            .get();
    if (doc.exists) {
      return doc.data()?['plan_name'];
    } else {
      return null;
    }
  }
}

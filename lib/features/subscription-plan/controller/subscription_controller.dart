import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notizen/models/subscription_plan_model.dart';
import 'package:notizen/services/subscription_service.dart';

class SubscriptionController extends ChangeNotifier {
  final SubscriptionService _service = SubscriptionService();

  List<SubscriptionPlanModel> plans = [];
  bool isLoading = false;
  SubscriptionPlanModel? selectedPlan;

  Future<void> loadSubscriptionPlans() async {
    isLoading = true;
    notifyListeners();

    try {
      plans = await _service.fetchSubscriptionPlans();
      final selectedPlanName = await _service.fetchUserSelectedPlanName();

      if (selectedPlanName != null) {
        selectedPlan = plans.firstWhere(
          (plan) => plan.name == selectedPlanName,
          orElse: () => plans.first,
        );
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectPlan(SubscriptionPlanModel plan) {
    selectedPlan = plan;
    notifyListeners();
  }

  Future<void> saveSelectedPlan(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      if (selectedPlan == null) {
        isLoading = false;
        notifyListeners();
        throw ("Please select any Plan first.");
      }
      await _service.saveUserSubscription(
        selectedPlan!.name,
        selectedPlan!.price,
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print("Subscription saved Error:  $e");
      }
    }
  }
}

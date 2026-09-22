import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/models/exprt_advice_model.dart';
import 'package:notizen/services/expert_advice_service.dart';

final subscriptionControllerProvider = StateNotifierProvider.autoDispose<
  SubscriptionController,
  AsyncValue<List<ExpertAdviceModel>>
>((ref) {
  return SubscriptionController();
});

class SubscriptionController
    extends StateNotifier<AsyncValue<List<ExpertAdviceModel>>> {
  final _service = ExpertAdviceService();

  SubscriptionController() : super(const AsyncValue.loading()) {
    fetchSubscription('expert-plan');
  }

  void fetchSubscription(String type) async {
    state = const AsyncValue.loading();
    try {
      final sub = await _service.fetchAllPlans(type);
      state = AsyncValue.data(sub);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

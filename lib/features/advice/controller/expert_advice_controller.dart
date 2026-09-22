import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/models/exprt_advice_model.dart';
import 'package:notizen/services/expert_advice_service.dart';

final expertAdviceServiceProvider = Provider((ref) => ExpertAdviceService());

final expertPlansProvider = FutureProvider<List<ExpertAdviceModel>>((
  ref,
) async {
  final service = ref.read(expertAdviceServiceProvider);
  return service.fetchAllPlans('expert-plan');
});

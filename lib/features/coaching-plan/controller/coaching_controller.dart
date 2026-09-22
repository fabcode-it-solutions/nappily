import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/models/coaching_plan_model.dart';
import 'package:notizen/services/coaching_plan_service.dart';

final coachingServiceProvider = Provider((ref) => CoachingPlanService());

final coachingProvider = FutureProvider<List<CoachingPlanModel>>((ref) async {
  final service = ref.read(coachingServiceProvider);

  return service.fetchResults();
});

final successStateProvider = StateProvider<bool?>((ref) => null);

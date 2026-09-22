import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/models/ai_advice_model.dart';
import 'package:notizen/services/ai_advice_service.dart';

final aiAdviceServiceProvider = Provider((ref) => AiAdviceService());

final aiPlansProvider = FutureProvider<List<AiAdviceModel>>((ref) async {
  final service = ref.read(aiAdviceServiceProvider);
  return service.fetchAllPlans();
});

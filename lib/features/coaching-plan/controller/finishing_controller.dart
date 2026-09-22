import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/models/finishing_model.dart';
import 'package:notizen/services/finishing_service.dart';

final finishingServiceProvider = Provider((ref) => FinishingService());

final finishingProvider = FutureProvider<List<FinishingModel>>((ref) async {
  final service = ref.read(finishingServiceProvider);

  return service.fetchResults();
});

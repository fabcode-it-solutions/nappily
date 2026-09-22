import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/models/question_result_model.dart';
import 'package:notizen/services/result_service.dart';
import 'package:notizen/utils/user_local_storage.dart';

final resultServiceProvider = Provider((ref) => ResultService());

final resultProvider = FutureProvider<List<QuestionResultModel>>((ref) async {
  final service = ref.read(resultServiceProvider);
  final user = await UserLocalStorage.getUserData();
  if (user == null) return [];
  final userId = user['uid'];
  ref.keepAlive();
  return service.fetchResults(userId);
});

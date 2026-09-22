import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/models/home_model.dart';
import 'package:notizen/services/home_service.dart';

final hurdleResponseServiceProvider = Provider((ref) => HomeService());
final FirebaseAuth _auth = FirebaseAuth.instance;
final user = _auth.currentUser;
final userId = user?.uid ?? '';

final hurdleChecklistControllerProvider = StateNotifierProvider.family<
  HurdleChecklistController,
  List<ChecklistItem>,
  HomeModel
>((ref, hurdle) {
  final service = ref.watch(hurdleResponseServiceProvider);
  return HurdleChecklistController(hurdle: hurdle, service: service);
});

class HurdleChecklistController extends StateNotifier<List<ChecklistItem>> {
  final HomeModel hurdle;
  final HomeService service;

  HurdleChecklistController({required this.hurdle, required this.service})
    : super([]) {
    _loadInitial();
  }

  void _loadInitial() async {
    state = await service.getChecklist(
      hurdle.id,
      List.generate(
        hurdle.checklist.length,
        (index) => '${hurdle.checklist[index]['id']}',
      ),
      userId,
    );
  }

  void toggle(int index) {
    final current = state[index];
    final updated = ChecklistItem(
      id: current.id,
      isChecked: !current.isChecked,
    );
    state = [
      for (int i = 0; i < state.length; i++) i == index ? updated : state[i],
    ];
    _save();
  }

  void _save() {
    service.updateChecklist(hurdle.id, state, userId);
  }
}

final hurdleStatusProvider = StreamProvider.family<String?, String>((
  ref,
  hurdleId,
) {
  final service = ref.watch(hurdleResponseServiceProvider);
  return service.getHurdleStatus(hurdleId, userId);
});

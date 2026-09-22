import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/models/privacy_model.dart';
import 'package:notizen/services/privacy_service.dart';
import 'package:notizen/utils/user_local_storage.dart';

final privacyPolicyServiceProvider = Provider((ref) => PrivacyPolicyService());

final privacyPolicyOptionsProvider =
    StateNotifierProvider<PrivacyPolicyController, List<PrivacyPolicyOption>>((
      ref,
    ) {
      final service = ref.read(privacyPolicyServiceProvider);
      return PrivacyPolicyController(service: service)..load();
    });

class PrivacyPolicyController extends StateNotifier<List<PrivacyPolicyOption>> {
  final PrivacyPolicyService service;

  PrivacyPolicyController({required this.service})
    : super([
        PrivacyPolicyOption(
          id: 'age',
          label:
              'I am at least 18 years old or have the consent of my parents.',
          accepted: false,
        ),
        PrivacyPolicyOption(
          id: 'agree_policy',
          label: 'I have read the privacy policy and agree.',
          accepted: false,
        ),
        PrivacyPolicyOption(
          id: 'data_consent',
          label:
              'I consent to the processing of my data for the purposes mentioned.',
          accepted: false,
        ),
        PrivacyPolicyOption(
          id: 'marketing_emails',
          label:
              'I would like to receive emails with tips and updates about the app.',
          accepted: false,
        ),
      ]);

  Future<void> load() async {
    final user = await UserLocalStorage.getUserData();
    if (user == null) return;
    final userId = "8ogHvb5M7PX5CXe9lCAE"; // user['uid'];
    final fetched = await service.fetchUserOptions(userId);
    if (fetched.isNotEmpty) state = fetched;
  }

  void toggle(String id) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(accepted: !item.accepted) else item,
    ];
  }

  Future<void> save() async {
    final user = await UserLocalStorage.getUserData();
    if (user == null) return;
    final userId = user['uid'];
    await service.saveUserOptions(userId, state);
  }
}

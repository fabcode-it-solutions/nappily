import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/ai-chat/screens/ai_screen.dart';
import 'package:notizen/models/home_without_sub_model.dart';
import 'package:notizen/services/home_without_sub_service.dart';

class HomeWithoutSubController extends ChangeNotifier {
  final HomeWithoutSubService _service = HomeWithoutSubService();
  HomeWithoutSubModel? _content;
  bool _isLoading = true;

  HomeWithoutSubModel? get content => _content;
  bool get isLoading => _isLoading;

  Future<void> loadContent() async {
    _isLoading = true;
    notifyListeners();

    _content = await _service.fetchContent();

    _isLoading = false;
    notifyListeners();
  }

  Function(int) onTabChanged(BuildContext context) {
    return (int index) {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final user = auth.currentUser;
      switch (index) {
        case 0:
          GoRouter.of(context).push("/home");
          break;
        case 1:
          GoRouter.of(context).push("/music");
          break;
        case 2:
          GoRouter.of(context).push("/add-post");
          break;
        case 3:
          GoRouter.of(context).push("/recent-notifications");
          break;
        case 4:
          // GoRouter.of(context).push("/ai-agent");
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            isDismissible: true,
            useRootNavigator: true,
            anchorPoint: Offset(0, 0),
            builder: (_) => ChatModal(userId: user!.uid),
          );
          break;
      }
    };
  }
}

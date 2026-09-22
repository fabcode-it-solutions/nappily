import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/features/recent-notifications/controller/notification_controller.dart';
import 'package:notizen/models/recent_notification_model.dart';

final selectedNotificationProvider = StateProvider<AppNotification?>(
  (ref) => null,
);

final unreadNotificationCountProvider = Provider<int>((ref) {
  final state = ref.watch(notificationControllerProvider);
  return state.allNotifications.where((n) => !n.isRead).length;
});

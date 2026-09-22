import 'package:flutter/material.dart';
import 'package:notizen/models/notification_preference.dart';
import 'package:notizen/services/notification_service.dart';
import 'package:notizen/utils/user_local_storage.dart';

class NotificationController extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  bool sleepReminder = false;
  bool hurdleReminder = false;
  bool infoReminder = false;

  bool isLoading = false;

  Future<void> loadNotificationSettings() async {
    isLoading = true;
    notifyListeners();
    final user = await UserLocalStorage.getUserData();
    if (user != null) {
      final settings = await _service.getNotificationSettings(user['uid']);
      if (settings != null) {
        sleepReminder = settings.sleepReminder;
        hurdleReminder = settings.hurdleReminder;
        infoReminder = settings.infoReminder;
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> saveNotificationSettings() async {
    try {
      final settings = NotificationSettingsModel(
        sleepReminder: sleepReminder,
        hurdleReminder: hurdleReminder,
        infoReminder: infoReminder,
      );
      final user = await UserLocalStorage.getUserData();
      if (user != null) {
        await _service.saveNotificationSettings(settings, user['uid']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void updateSleepReminder(bool value) {
    sleepReminder = value;
    notifyListeners();
  }

  void updateHurdleReminder(bool value) {
    hurdleReminder = value;
    notifyListeners();
  }

  void updateInfoReminder(bool value) {
    infoReminder = value;
    notifyListeners();
  }
}

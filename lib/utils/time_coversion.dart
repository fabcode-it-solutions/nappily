import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeConverter {
  static String convertTimeOfDayToString(TimeOfDay timeOfDay) {
    try {
      final now = DateTime.now();
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      if (kDebugMode) {
        print('Error converting TimeOfDay to String: $e');
      }
      throw Exception('Invalid time format');
    }
  }

  static TimeOfDay convertStringToTimeOfDay(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) {
      return TimeOfDay.now();
    }
    try {
      final parts = timeStr.split(':');
      if (parts.length != 2) throw FormatException('Invalid time format');

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        throw RangeError('Hour must be between 0-23 and minute between 0-59');
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      if (kDebugMode) {
        print('Error converting String to TimeOfDay: $e');
      }
      rethrow;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:notizen/utils/time_coversion.dart';

class BabyProfile {
  final String id;
  final String userId;
  final String name;
  final DateTime dob;
  final bool prefersSleepTime;
  final TimeOfDay? sleepTime;
  final int napsPerDay;
  final String babyProfileImg;

  BabyProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.dob,
    required this.prefersSleepTime,
    this.sleepTime,
    required this.napsPerDay,
    required this.babyProfileImg,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'dob': dob.toIso8601String(),
    'prefersSleepTime': prefersSleepTime,
    'sleepTime': TimeConverter.convertTimeOfDayToString(
      sleepTime ?? TimeOfDay.now(),
    ),
    'napsPerDay': napsPerDay,
    'babyProfileImg': babyProfileImg,
  };

  factory BabyProfile.fromJson(Map<String, dynamic> json) => BabyProfile(
    id: json['id'],
    userId: json['userId'],
    name: json['name'],
    dob: DateTime.parse(json['dob']),
    prefersSleepTime: json['prefersSleepTime'],
    sleepTime: TimeConverter.convertStringToTimeOfDay(json['sleepTime']),
    napsPerDay: json['napsPerDay'],
    babyProfileImg: json['babyProfileImg'],
  );
}

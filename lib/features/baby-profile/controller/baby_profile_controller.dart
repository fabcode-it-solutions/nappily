import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notizen/models/baby_profile_model.dart';
import 'package:notizen/services/baby_profile_service.dart';
import 'package:notizen/utils/user_local_storage.dart';
import 'package:uuid/uuid.dart';

class BabyProfileController extends ChangeNotifier {
  final BabyProfileService _service = BabyProfileService();

  final nameController = TextEditingController();
  DateTime? dob;
  final prefersSleepTimeDisabled = TextEditingController();
  bool prefersSleepTime = true;
  final sleepTimeController = TextEditingController();
  final napsController = TextEditingController();
  File? babyImage;
  String? base64Image;
  bool isLoading = false;
  bool _isInitialized = false;
  String? babyProfileId;
  bool _isDisposed = false;
  TimeOfDay? sleepTime;

  bool get isDisposed => _isDisposed;

  final picker = ImagePicker();

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      babyImage = File(image.path);

      // Convert image to base64
      final bytes = await babyImage!.readAsBytes();
      base64Image = base64Encode(bytes);

      notifyListeners();
    }
  }

  void togglePrefersSleep(bool value) {
    prefersSleepTime = value;
    notifyListeners();
  }

  void toggleDob(DateTime value) {
    dob = value;
    notifyListeners();
  }

  void updateSleepTime(TimeOfDay value) {
    sleepTime = value;
    notifyListeners();
  }

  Future<void> submitProfile(context) async {
    if (nameController.text.isEmpty || dob == null || base64Image == null) {
      throw ("All fields are required along with a valid image");
    }
    isLoading = true;
    notifyListeners();

    try {
      final user = await UserLocalStorage.getUserData();
      final id = babyProfileId ?? const Uuid().v4();

      final profile = BabyProfile(
        id: id,
        userId: user?['uid'],
        name: nameController.text,
        dob: dob!,
        prefersSleepTime: prefersSleepTime,
        sleepTime: prefersSleepTime ? sleepTime : null,
        napsPerDay: int.tryParse(napsController.text) ?? 0,
        babyProfileImg: base64Image ?? "",
      );

      await _service.addBabyProfile(profile);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully')),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      throw ("Something went wrong! Please try again");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProfileData(context) async {
    if (_isInitialized) return;
    isLoading = true;
    notifyListeners();
    try {
      final user = await UserLocalStorage.getUserData();
      if (user == null) return;
      print(user['email']);
      final profile = await _service.getBabyProfile(user['uid']);
      if (profile != null) {
        nameController.text = profile.name;
        dob = profile.dob;
        prefersSleepTime = profile.prefersSleepTime;
        sleepTime = (profile.sleepTime ?? TimeOfDay.now()) as TimeOfDay?;
        napsController.text = profile.napsPerDay.toString();
        base64Image = profile.babyProfileImg;
        babyProfileId = profile.id;
        _isInitialized = true;
        notifyListeners();
      } else {
        isLoading = false;
        safeNotifyListeners();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      isLoading = false;
      safeNotifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    sleepTimeController.dispose();
    napsController.dispose();
    prefersSleepTimeDisabled.dispose();
    _isDisposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_isDisposed) {
      Future.microtask(() => notifyListeners());
    }
  }
}

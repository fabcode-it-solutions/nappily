import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/models/general_info_model.dart';
import 'package:notizen/services/general_info_service.dart';

final generalInfoServiceProvider = Provider((ref) => GeneralInfoService());

final generalInfoDataProvider = FutureProvider<List<Section>>((ref) async {
  return ref.read(generalInfoServiceProvider).fetchSections();
});

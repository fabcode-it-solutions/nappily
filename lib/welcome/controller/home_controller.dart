import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/models/home_model.dart';
import 'package:notizen/services/home_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) {
    final user = _auth.currentUser;
    final userId = user?.uid ?? '';
    return HomeController(HomeService(), userId);
  },
);

class HomeState {
  final DateTime? sleepTime;
  final List<HomeModel> allHurdles;
  final List<HomeModel>? unsolved;
  final List<HomeModel>? solved;
  final HomeModel? dailyHurdle;
  bool isLoading;
  final Map<String, String> status;
  final int completedHurdles;

  HomeState({
    required this.sleepTime,
    required this.allHurdles,
    required this.dailyHurdle,
    required this.unsolved,
    required this.solved,
    this.isLoading = false,
    this.status = const {},
    this.completedHurdles = 0,
  });

  factory HomeState.initial() => HomeState(
    sleepTime: null,
    allHurdles: [],
    dailyHurdle: null,
    unsolved: [],
    solved: [],
    isLoading: false,
    status: const {},
    completedHurdles: 0,
  );

  HomeState copyWith({
    DateTime? sleepTime,
    List<HomeModel>? allHurdles,
    List<HomeModel>? unsolved,
    List<HomeModel>? solved,
    HomeModel? dailyHurdle,
    bool? isLoading,
    Map<String, String>? status,
    int? completedHurdles,
  }) {
    return HomeState(
      sleepTime: sleepTime ?? this.sleepTime,
      allHurdles: allHurdles ?? this.allHurdles,
      unsolved: unsolved ?? this.unsolved,
      solved: solved ?? this.solved,
      dailyHurdle: dailyHurdle ?? this.dailyHurdle,
      isLoading: isLoading ?? this.isLoading,
      status: status ?? this.status,
      completedHurdles: completedHurdles ?? this.completedHurdles,
    );
  }
}

class HomeController extends StateNotifier<HomeState> {
  final HomeService _service;
  final String userId;

  HomeController(this._service, this.userId) : super(HomeState.initial()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    try {
      final hurdles = await _service.fetchHurdles(userId);
      final startedOrCompletedHurdles = await _service.fetchSolvedHurdleIds(
        userId,
      );
      final solvedIds =
          startedOrCompletedHurdles
              .map((e) => e['hurdleId'].toString())
              .toSet();

      final completedHurdles =
          startedOrCompletedHurdles
              .where((item) => item['status'] == 'completed')
              .length;

      final Map<String, String> statusMap = {
        for (final item in startedOrCompletedHurdles)
          item['hurdleId'].toString(): item['status'] as String,
      };

      final solvedHurdles =
          hurdles.where((hurdle) => solvedIds.contains(hurdle.id)).map((
            hurdle,
          ) {
            final status = statusMap[hurdle.id] ?? 'not_started';
            state = state.copyWith(
              status: {...state.status, hurdle.id: status},
            );
            return hurdle;
          }).toList();

      final sleepTime = await _service.fetchSleepTime(userId);
      final unsolved =
          hurdles.where((hurdle) => !solvedIds.contains(hurdle.id)).toList();
      final random = unsolved.isNotEmpty ? (unsolved..shuffle()).first : null;

      state = state.copyWith(
        allHurdles: hurdles,
        sleepTime: sleepTime,
        unsolved: unsolved,
        solved: solvedHurdles,
        dailyHurdle: random,
        isLoading: false,
        completedHurdles: completedHurdles,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      if (kDebugMode) {
        print('Error fetching hurdles: $e');
      }
    }
  }

  Future<void> markAsSolved(String hurdleId) async {
    await _service.markHurdleAsSolved(userId, hurdleId);
    _init();
  }
}

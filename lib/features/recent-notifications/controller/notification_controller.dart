import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notizen/models/recent_notification_model.dart';
import 'package:notizen/services/recent_notification_service.dart';

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, NotificationState>((ref) {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid ?? '';
      ref.keepAlive();
      return NotificationController(AppNotificationService(), userId)
        ..loadInitialNotifications();
    });

class NotificationController extends StateNotifier<NotificationState> {
  final AppNotificationService _service;
  final String userId;

  NotificationController(this._service, this.userId)
    : super(NotificationState.initial());

  Future<void> loadInitialNotifications() async {
    state = state.copyWith(isLoading: true);

    final notifications = await _service.fetchNotifications(
      userId: userId,
      limit: 10,
    );

    state = state.copyWith(
      allNotifications: notifications,
      displayedNotifications: notifications,
      lastTimestamp:
          notifications.isNotEmpty ? notifications.last.timestamp : null,
      lastId: notifications.isNotEmpty ? notifications.last.id : null,
      isLoading: false,
      hasMore: notifications.length == 10,
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading ||
        state.lastTimestamp == null ||
        state.lastId == null) {
      return;
    }

    state = state.copyWith(isLoading: true);

    final more = await _service.fetchNotifications(
      userId: userId,
      limit: 10,
      startAfterTimestamp: state.lastTimestamp,
      startAfterId: state.lastId,
    );

    if (more.isEmpty) {
      state = state.copyWith(isLoading: false, hasMore: false);
      return;
    }

    final updated = [...state.allNotifications, ...more];

    state = state.copyWith(
      allNotifications: updated,
      displayedNotifications: _applyFilters(updated),
      lastTimestamp: more.last.timestamp,
      lastId: more.last.id,
      isLoading: false,
      hasMore: true,
    );
  }

  void search(String query) {
    final filtered = _applyFilters(state.allNotifications, query: query);
    state = state.copyWith(
      searchQuery: query,
      displayedNotifications: filtered,
    );
  }

  Future<void> saveNotification(
    String userId,
    AppNotification notification,
  ) async {
    state = state.copyWith(isLoading: true);
    await _service.saveNotification(userId, notification);
    state = state.copyWith(isLoading: false);
  }

  void sortBy(SortOrder order) {
    state = state.copyWith(sortOrder: order);
    final filtered = _applyFilters(state.displayedNotifications, order: order);
    state = state.copyWith(displayedNotifications: filtered);
  }

  Future<void> markAllAsRead() async {
    await _service.markAllAsRead(userId);
    final updated =
        state.allNotifications.map((n) => n.copyWith(isRead: true)).toList();
    state = state.copyWith(
      allNotifications: updated,
      displayedNotifications: _applyFilters(updated),
    );
  }

  Future<void> delete(String id) async {
    await _service.deleteNotification(userId, id);
    final updated = state.allNotifications.where((n) => n.id != id).toList();
    state = state.copyWith(
      allNotifications: updated,
      displayedNotifications: _applyFilters(updated),
    );
  }

  Future<void> markAsRead(String notificationId) async {
    final index = state.allNotifications.indexWhere(
      (n) => n.id == notificationId,
    );
    if (index == -1) return;

    final updated = state.allNotifications[index].copyWith(isRead: true);

    final updatedList = [...state.allNotifications];
    updatedList[index] = updated;

    state = state.copyWith(
      allNotifications: updatedList,
      displayedNotifications: _applyFilters(updatedList),
    );

    await _service.markNotificationAsRead(
      userId: userId,
      notificationId: notificationId,
    );
  }

  List<AppNotification> _applyFilters(
    List<AppNotification> data, {
    String? query,
    SortOrder? order,
  }) {
    query ??= state.searchQuery;
    order ??= state.sortOrder;

    List<AppNotification> filtered = data;

    if (query.isNotEmpty) {
      filtered =
          filtered
              .where(
                (n) => n.title.toLowerCase().contains(query!.toLowerCase()),
              )
              .toList();
    }

    filtered.sort((a, b) {
      if (order == SortOrder.newestFirst) {
        return b.timestamp.compareTo(a.timestamp);
      } else {
        return a.timestamp.compareTo(b.timestamp);
      }
    });

    return filtered;
  }
}

class NotificationState {
  final List<AppNotification> allNotifications;
  final List<AppNotification> displayedNotifications;
  final String searchQuery;
  final SortOrder sortOrder;
  final bool isLoading;
  final DocumentSnapshot? lastDoc;
  final DateTime? lastTimestamp;
  final String? lastId;
  final bool hasMore;

  NotificationState({
    required this.allNotifications,
    required this.displayedNotifications,
    required this.searchQuery,
    required this.sortOrder,
    required this.isLoading,
    required this.lastDoc,
    this.lastTimestamp,
    this.lastId,
    this.hasMore = true,
  });

  factory NotificationState.initial() => NotificationState(
    allNotifications: [],
    displayedNotifications: [],
    searchQuery: '',
    sortOrder: SortOrder.newestFirst,
    isLoading: false,
    lastDoc: null,
  );

  NotificationState copyWith({
    List<AppNotification>? allNotifications,
    List<AppNotification>? displayedNotifications,
    String? searchQuery,
    SortOrder? sortOrder,
    bool? isLoading,
    DocumentSnapshot? lastDoc,
    DateTime? lastTimestamp,
    String? lastId,
    bool? hasMore,
  }) {
    return NotificationState(
      allNotifications: allNotifications ?? this.allNotifications,
      displayedNotifications:
          displayedNotifications ?? this.displayedNotifications,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOrder: sortOrder ?? this.sortOrder,
      isLoading: isLoading ?? this.isLoading,
      lastDoc: lastDoc,
      lastTimestamp: lastTimestamp ?? this.lastTimestamp,
      lastId: lastId ?? this.lastId,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

enum SortOrder { newestFirst, oldestFirst }















// class NotificationController extends StateNotifier<List<AppNotification>> {
//   final Ref ref;
//   DocumentSnapshot? _lastDoc;
//   bool _hasMore = true;

//   NotificationController(this.ref) : super([]);

//   final _service = AppNotificationService();
  

//   Future<void> loadInitial(String userId) async {
//     _lastDoc = null;
//     _hasMore = true;
//     state = [];
//     await loadMore(userId);
//   }

//   Future<void> loadMore(String userId) async {
//     if (!_hasMore) return;

//     final notifications = await _service.fetchNotifications(
//       userId: userId,
//       limit: 10,
//       startAfter: _lastDoc,
//     );

//     if (notifications.isNotEmpty) {
//       final snapshot =
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(userId)
//               .collection('notifications')
//               .orderBy('timestamp', descending: true)
//               .limit(1)
//               .get();

//       _lastDoc = snapshot.docs.first;
//       state = [...state, ...notifications];
//     } else {
//       _hasMore = false;
//     }
//   }

//   Future<void> markAllAsRead(String userId) async {
//     await _service.markAllAsRead(userId);
//     state = [for (var n in state) n.copyWith(isRead: true)];
//   }

//   Future<void> delete(String userId, String id) async {
//     await _service.deleteNotification(userId, id);
//     state = state.where((n) => n.id != id).toList();
//   }

//   Future<void> saveNotification(
//     String userId,
//     AppNotification notification,
//   ) async {
//     await _service.saveNotification(userId, notification);
//     // Don't call loadMore/loadInitial here to avoid setState after dispose issues
//   }
// }

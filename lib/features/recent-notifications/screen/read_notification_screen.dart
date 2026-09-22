import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:notizen/features/recent-notifications/controller/notification_controller.dart';
import 'package:notizen/features/recent-notifications/controller/read_notification_controller.dart';
import 'package:notizen/models/recent_notification_model.dart';
import 'package:notizen/welcome/screens/home_without_sub_screen.dart';
import 'package:notizen/widgets/bottom_navigation_layout.dart';

class NotificationDetailScreen extends ConsumerWidget {
  final String notificationId;
  final AppNotification? notification;

  const NotificationDetailScreen({
    super.key,
    required this.notificationId,
    this.notification,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    final controller = ref.read(notificationControllerProvider.notifier);

    Future.microtask(() {
      if (!notification!.isRead) {
        ref
            .read(notificationControllerProvider.notifier)
            .markAsRead(notificationId);
      }
    });

    if (notification == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notification Details')),
        body: const Center(child: Text('Notification not found.')),
      );
    }
    return BottomNavigationLayout(
      currentIndex: 3,
      onTabChanged: (screenNumber) {
        onTabChanged(context)(screenNumber);
      },
      isFloatingActionButton: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 24.0,
            centerTitle: false,
            title: Row(
              children: [
                GestureDetector(
                  onTap: () => GoRouter.of(context).pop(),
                  child: const Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color(0XFF5CA99F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$unreadCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                width: 49,
                height: 49,
                margin: const EdgeInsets.only(right: 24.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF40377B), Color(0xFF40377B)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const ImageIcon(
                  AssetImage('assets/images/icons/ai-chat-icon.png'),
                  color: Color(0XFFFFFFFF),
                  size: 21,
                ),
              ),
            ],
          ),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 0,
          color: const Color(0X0D5CA99F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification!.title,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  notification!.body,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sent on: ${formatDateOrTime(notification!.timestamp)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0X80FFFFFF),
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await controller.delete(notification!.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Notification deleted")),
                          );
                          GoRouter.of(context).go("/recent-notifications");
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0XFFFF0000),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ImageIcon(
                          AssetImage('assets/images/icons/delete-icon.png'),
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDateOrTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return DateFormat.jm().format(dateTime);
    } else {
      return DateFormat("dd/MM/yy").format(dateTime);
    }
  }
}

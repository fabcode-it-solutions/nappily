import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:notizen/features/recent-notifications/controller/notification_controller.dart';
import 'package:notizen/models/recent_notification_model.dart';
import 'package:notizen/welcome/screens/home_without_sub_screen.dart';
import 'package:notizen/widgets/bottom_navigation_layout.dart';

class RecentNotificationsScreen extends ConsumerStatefulWidget {
  const RecentNotificationsScreen({super.key});

  @override
  ConsumerState<RecentNotificationsScreen> createState() =>
      _RecentNotificationsScreenState();
}

class _RecentNotificationsScreenState
    extends ConsumerState<RecentNotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final controller = ref.read(notificationControllerProvider.notifier);
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        controller.loadMore();
      }
    });
  }

  String selectedValue = 'Newest First';
  final List<String> items = ['Newest First', 'Oldest First'];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationControllerProvider);
    final controller = ref.read(notificationControllerProvider.notifier);

    return BottomNavigationLayout(
      currentIndex: 3,
      onTabChanged: (screenNumber) {
        onTabChanged(context)(screenNumber);
      },
      isFloatingActionButton: false,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => GoRouter.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.white,
            size: 20,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0.0,
        title: const Text(
          'Recent Notifications',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Poppins",
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopControls(controller, state),
            const SizedBox(height: 8),
            Expanded(
              child:
                  state.isLoading && state.displayedNotifications.isEmpty
                      ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0XFF5CA99F),
                        ),
                      )
                      : ListView.separated(
                        controller: _scrollController,
                        itemCount:
                            state.displayedNotifications.length +
                            (state.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= state.displayedNotifications.length) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Color(0XFF5CA99F),
                              ),
                            );
                          }

                          final notification =
                              state.displayedNotifications[index];
                          return GestureDetector(
                            onTap: () {
                              GoRouter.of(context).pushNamed(
                                'notificationDetail',
                                pathParameters: {'id': notification.id},
                                extra: notification,
                              );
                            },
                            child: _dismissibleNotification(
                              notification,
                              controller,
                            ),
                          );
                        },
                        separatorBuilder:
                            (BuildContext context, int index) => Align(
                              alignment: Alignment.center,
                              child: FractionallySizedBox(
                                widthFactor: 1.12,
                                child: Divider(
                                  indent: 0,
                                  endIndent: 0,
                                  color: Color(0X1AFFFFFF),
                                ),
                              ),
                            ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Dismissible _dismissibleNotification(
    AppNotification notification,
    NotificationController controller,
  ) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Color(0XFFFF0000),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: ImageIcon(
          AssetImage('assets/images/icons/delete-icon.png'),
          color: Colors.white,
          size: 18,
        ),
      ),
      onDismissed: (_) => controller.delete(notification.id),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 49,
                  height: 49,
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
                if (!notification.isRead)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontFamily: "Poppins",
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              formatDateOrTime(notification.timestamp),
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0X80FFFFFF),
                                fontFamily: "Poppins",
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Color(0X80FFFFFF),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: Color(0X80FFFFFF),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
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

  Widget _buildTopControls(
    NotificationController controller,
    NotificationState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          TextField(
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              fontFamily: "Poppins",
            ),
            onChanged: controller.search,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search, color: Colors.white, size: 18),
              hintText: "Search",
              hintStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                fontFamily: "Poppins",
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(color: Colors.white, width: 1),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(color: Colors.white, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(color: Colors.white, width: 1),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton<SortOrder>(
                  menuWidth: 250,
                  style: TextStyle(
                    color: Color(0XFF1C1F21),
                    fontSize: 17,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  icon: Icon(Icons.sort, color: Colors.white, size: 24),
                  value: state.sortOrder,
                  onChanged: (value) {
                    if (value != null) controller.sortBy(value);
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return items
                        .map((String item) => SizedBox.shrink())
                        .toList();
                  },
                  items: [
                    DropdownMenuItem(
                      value: SortOrder.newestFirst,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            child:
                                SortOrder.newestFirst.name ==
                                        state.sortOrder.name
                                    ? Icon(
                                      Icons.check,
                                      color: Color(0XFF1C1F21),
                                      size: 20,
                                    )
                                    : null,
                          ),
                          const SizedBox(width: 5),
                          Expanded(child: Text("Newest First")),
                          SvgPicture.asset(
                            "assets/images/icons/accending-icon.svg",
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: SortOrder.oldestFirst,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            child:
                                SortOrder.oldestFirst.name ==
                                        state.sortOrder.name
                                    ? Icon(
                                      Icons.check,
                                      color: Color(0XFF1C1F21),
                                      size: 20,
                                    )
                                    : null,
                          ),
                          const SizedBox(width: 5),
                          Expanded(child: Text("Oldest First")),
                          SvgPicture.asset(
                            "assets/images/icons/decending-icon.svg",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: controller.markAllAsRead,
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 14.25,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      "Mark All As Read",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

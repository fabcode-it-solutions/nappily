import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/notifications/controller/notification_controller.dart';
import 'package:notizen/widgets/custom_button_widget.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationController()..loadNotificationSettings(),
      child: const NotificationScreenBody(),
    );
  }
}

class NotificationScreenBody extends StatelessWidget {
  const NotificationScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<NotificationController>(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
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
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Poppins",
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0D1D), Color(0xFF443B83)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.mirror,
          ),
        ),
        child:
            controller.isLoading
                ? Center(
                  child: CircularProgressIndicator(color: Color(0XFF5CA99F)),
                )
                : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 100,
                      left: 10,
                      right: 10,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom,
                        minWidth:
                            MediaQuery.of(context).size.width -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                _switchInput(
                                  "Sleeping Time Reminder",
                                  controller.sleepReminder,
                                  controller.updateSleepReminder,
                                ),
                                divider(),
                                _switchInput(
                                  "Daily Hurdle Reminder",
                                  controller.hurdleReminder,
                                  controller.updateHurdleReminder,
                                ),
                                divider(),
                                _switchInput(
                                  "Unread General Info Reminder",
                                  controller.infoReminder,
                                  controller.updateInfoReminder,
                                ),
                                const SizedBox(height: 40),

                                CustomButtonWidget(
                                  text: "Save",
                                  backgroundColor: Color(0XFF5CA99F),
                                  onPressed: () async {
                                    bool success =
                                        await controller
                                            .saveNotificationSettings();
                                    if (success) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Notifications saved!',
                                            ),
                                          ),
                                        );
                                        GoRouter.of(context).pop();
                                      }
                                    } else {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Failed to save Notifications please try again!',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      ),
    );
  }

  Align divider() {
    return Align(
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 1.12,
        child: Divider(indent: 0, endIndent: 0, color: Color(0X1AFFFFFF)),
      ),
    );
  }

  SwitchListTile _switchInput(name, valueController, onChange) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      activeColor: Colors.white,
      activeTrackColor: Color(0XFF5CA99F),
      inactiveTrackColor: Colors.transparent,
      inactiveThumbColor: Colors.white,
      title: Text(
        name,
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Poppins",
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      value: valueController,
      onChanged: onChange,
    );
  }
}

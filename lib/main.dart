import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:notizen/features/recent-notifications/controller/notification_controller.dart';
import 'package:notizen/models/recent_notification_model.dart';
import 'package:notizen/services/recent_notification_service.dart';
import 'package:rxdart/rxdart.dart';
import 'routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _messageStreamController = BehaviorSubject<RemoteMessage>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final notification = message.notification;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId != null) {
    final appNotification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: notification?.title ?? '',
      body: notification?.body ?? '',
      timestamp: DateTime.now(),
      isRead: false,
    );

    await AppNotificationService().saveNotification(userId, appNotification);
  }
}

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _initializeFCM();
  await handleForegroundMessages();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(ProviderScope(observers: [Logger()], child: NotizenApp()));
}

Future<void> handleForegroundMessages() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'default_channel_id',
    'Default Notifications',
    description: 'This channel is used for default notifications',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final notification = message.notification;
    final android = notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/launcher_icon',
          ),
        ),
      );

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final appNotification = AppNotification(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: notification.title ?? '',
          body: notification.body ?? '',
          timestamp: DateTime.now(),
          isRead: false,
        );

        final context = navigatorKey.currentContext;
        if (context != null && context.mounted) {
          final container = ProviderScope.containerOf(context);
          final notifier = container.read(
            notificationControllerProvider.notifier,
          );
          await notifier.saveNotification(userId, appNotification);
          await notifier.loadInitialNotifications();
        }
      }
    }

    _messageStreamController.sink.add(message);
  });
}

Future<void> _initializeFCM() async {
  final messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  final token = await messaging.getToken();
  print('FCM Token: $token');
}

class NotizenApp extends StatelessWidget {
  const NotizenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            color: Colors.white,
          ),
          displayLarge: TextStyle(fontFamily: 'Poppins', fontSize: 36),
          bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Routes(),
    );
  }
}

// !!!!!! BELOW CODE MUST BE REMOVED AFTER DEVELOPMENT. IT IS ONLY FOR DEVELOPMENT LOGS. !!!!!!!
class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint(
      '[Provider Updated] ${provider.name ?? provider.runtimeType}: $newValue',
    );
  }

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    debugPrint(
      '[Provider Added] ${provider.name ?? provider.runtimeType}: $value',
    );
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    debugPrint('[Provider Disposed] ${provider.name ?? provider.runtimeType}');
  }
}

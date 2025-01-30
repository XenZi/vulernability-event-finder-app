import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:client/core/router/app.router.dart';

class FirebaseService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    await _initializeLocalNotifications();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Ensure APNs token is retrieved before getting FCM token
    String? apnsToken = await messaging.getAPNSToken();
    if (apnsToken == null) {
      print("⚠️ APNs token not available yet. Retrying...");
      await Future.delayed(Duration(seconds: 3));
      apnsToken = await messaging.getAPNSToken();
    }

    if (apnsToken != null) {
      print("✅ APNs token received: $apnsToken");
      String? fcmToken = await messaging.getToken();
      print("✅ FCM Token: $fcmToken");
    } else {
      print("❌ Failed to get APNs token.");
    }

    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedAppHandler);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    _requestPermissions();
  }

  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS, // ✅ Ensure iOS settings are included
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final payload = response.payload;
        if (payload != null) {
          appRouter.go(payload);
        }
      },
    );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null) {
      _showLocalNotification(
        title: notification.title!,
        body: notification.body!,
        payload: message.data['payload'] ?? '/notifications',
      );
    }
  }

  static void _onMessageHandler(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _showLocalNotification(
        title: notification.title!,
        body: notification.body!,
        payload: '/notifications', // Payload directs to Notification Page
      );
    }
  }

  static void _onMessageOpenedAppHandler(RemoteMessage message) {
    appRouter.go('/notifications'); // Navigate to Notification Page
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'channel_description',
            importance: Importance.max,
            priority: Priority.high);
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);
    await _localNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  static Future<void> _requestPermissions() async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();
    print('User granted permission: ${settings.authorizationStatus}');
  }
}

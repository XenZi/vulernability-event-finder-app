
// import 'package:client/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class FirebaseService {

//   static void initializeService(){
//     Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//     );  
    
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     // Handle notifications when app is in background or terminated
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _handleMessage(message);
//     });

//     Future<void> _requestPermissions() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     NotificationSettings settings = await messaging.requestPermission();
//     print('User granted permission: ${settings.authorizationStatus}');
//     }
  
//   }


// Future<void> _handleMessage(RemoteMessage message) async {

// }

// static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }


// }

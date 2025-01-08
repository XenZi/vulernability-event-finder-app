import 'package:client/features/assets/pages/home_page.dart';
import 'package:client/features/auth/pages/login_page.dart';
import 'package:client/features/auth/pages/register_page.dart';
import 'package:client/features/events/event_page.dart';
import 'package:client/features/notifications/pages/notification_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => NotificationListPage(),
    ),
    GoRoute(
      path: '/event/:id',
      builder: (context, state) => EventPage(),
    )
  ],
  initialLocation: '/login', // Default route when the app starts
);

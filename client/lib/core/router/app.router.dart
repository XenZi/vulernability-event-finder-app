import 'package:client/core/security/secure-storage.component.dart';
import 'package:client/features/assets/pages/assets.page.dart';
import 'package:client/features/assets/pages/home.page.dart';
import 'package:client/features/auth/pages/login.page.dart';
import 'package:client/features/auth/pages/register.page.dart';
import 'package:client/features/events/pages/event.page.dart';
import 'package:client/features/events/pages/events.page.dart';
import 'package:client/features/notifications/pages/notifications.page.dart';
import 'package:go_router/go_router.dart';

Future<bool> isLoggedIn() async {
  final token = await SecureStorage.loadToken();
  return token != null;
}

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
      redirect: (context, state) async {
        if (await isLoggedIn()) {
          return '/';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => NotificationListPage(),
    ),
    GoRoute(
      path: '/events/:id',
      builder: (context, state) => EventListPage(
        goRouterState: state,
      ),
    ),
    GoRoute(
      path: '/event/:id',
      builder: (context, state) => EventPage(
        goRouterState: state,
      ),
    ),
    GoRoute(
      path: '/assets',
      builder: (context, state) => AssetListPage(),
    ),
    GoRoute(
      path: '/logout',
      builder: (context, state) {
        SecureStorage.clearToken();
        return LoginPage();
      },
    ),
  ],
  initialLocation: '/login',
);

import 'package:client/features/auth/pages/login_page.dart';
import 'package:client/features/auth/pages/register_page.dart';
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
  ],
  initialLocation: '/login', // Default route when the app starts
);

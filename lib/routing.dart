import 'package:go_router/go_router.dart';
import 'package:prubea1app/components/app_shell.dart';
import 'package:prubea1app/login_screen.dart';
import 'package:prubea1app/register_screen.dart';
import 'package:prubea1app/views/dashboard/customer_dashboard/notifications_fragment.dart';
import 'package:prubea1app/views/dashboard/customer_dashboard/profile_fragment.dart';
import 'package:prubea1app/views/dashboard/dashboard.dart';

final GoRouter router = GoRouter(
  initialLocation: "/login",
  routes: [
    GoRoute(path: "/login", builder: (context, state) => LoginScreen()),
    GoRoute(path: "/register", builder: (context, state) => RegisterScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, statefulNavigationShell) {
        return AppShell(statefulNavigationShell: statefulNavigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/dashboard",
              builder: (context, state) => Dashboard(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/notifications",
              builder: (context, state) => NotificationsFragment(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/profile",
              builder: (context, state) => ProfileFragment(),
            ),
          ],
        ),
      ],
    ),
  ],
);

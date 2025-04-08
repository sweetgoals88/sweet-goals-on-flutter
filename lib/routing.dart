import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prubea1app/components/app_shell.dart';
import 'package:prubea1app/login_screen.dart';
import 'package:prubea1app/register_screen.dart';
import 'package:prubea1app/views/dashboard/notifications_fragment.dart';
import 'package:prubea1app/views/dashboard/profile_fragment.dart';
import 'package:prubea1app/views/dashboard/dashboard.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _dashboardNavigatorKey = GlobalKey<NavigatorState>();
final _notificationsNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: "/login",
  navigatorKey: _rootNavigatorKey,
  routes: [
    /// Unauthenticated Routes
    GoRoute(
      path: "/login",
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: "/register",
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => RegisterScreen(),
    ),

    /// Authenticated Shell Route
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      builder:
          (context, state, shell) => AppShell(statefulNavigationShell: shell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _dashboardNavigatorKey,
          routes: [
            GoRoute(
              path: "/dashboard",
              builder: (context, state) => const Dashboard(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _notificationsNavigatorKey,
          routes: [
            GoRoute(
              path: "/notifications",
              builder: (context, state) => const NotificationsFragment(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              path: "/profile",
              builder: (context, state) => const ProfileFragment(),
            ),
          ],
        ),
      ],
    ),
  ],
);

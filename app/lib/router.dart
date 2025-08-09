import 'package:app/constants/keys.dart';
import 'package:app/modules/home/home_page.dart';
import 'package:app/modules/login/auth_provider.dart';
import 'package:app/modules/login/login_page.dart';
import 'package:app/modules/more/more_page.dart';
import 'package:app/shell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Create a provider that returns the router
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: authState ? '/home' : '/login',
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      // Get the current auth state
      final container = ProviderScope.containerOf(context);
      final isAuthenticated = container.read(authProvider);

      // If user is not authenticated and trying to access protected routes
      if (!isAuthenticated && state.matchedLocation != '/login') {
        return '/login';
      }

      // If user is authenticated and on login page, redirect to home
      if (isAuthenticated && state.matchedLocation == '/login') {
        return '/home';
      }

      return null;
    },
    routes: <RouteBase>[
      // Login route (public)
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

      // Protected routes (require authentication)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            RootShell(navigationShell: navigationShell),
        branches: [
          // Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
            initialLocation: '/home',
            navigatorKey: homeNavigatorKey,
          ),

          // More
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                builder: (context, state) => const MorePage(),
              ),
            ],
            initialLocation: '/more',
            navigatorKey: moreNavigatorKey,
          ),
        ],
      ),
    ],
  );
});

// Keep the original router for backward compatibility
final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/login',
  debugLogDiagnostics: kDebugMode,
  routes: <RouteBase>[
    // Login route (public)
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

    // Protected routes (require authentication)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          RootShell(navigationShell: navigationShell),
      branches: [
        // Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
          initialLocation: '/home',
          navigatorKey: homeNavigatorKey,
        ),

        // More
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/more',
              builder: (context, state) => const MorePage(),
            ),
          ],
          initialLocation: '/more',
          navigatorKey: moreNavigatorKey,
        ),
      ],
    ),
  ],
);

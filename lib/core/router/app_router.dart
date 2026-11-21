
import 'package:go_router/go_router.dart';

import '../../features/dashboard/dashboard_screen.dart';
import '../../features/creator/creator_screen.dart';
import '../../features/shared/placeholder_screen.dart';
import '../../features/preview/preview_screen.dart';
import '../../models/birthday_config.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => const CreatorScreen(),
    ),
    GoRoute(
      path: '/preview',
      builder: (context, state) {
        final birthday = state.extra as BirthdayConfig;
        return PreviewScreen(birthday: birthday);
      },
    ),
    GoRoute(
      path: '/creations',
      builder: (context, state) => const PlaceholderScreen(
        title: 'My Creations',
        icon: 'creations',
      ),
    ),
    GoRoute(
      path: '/themes',
      builder: (context, state) => const PlaceholderScreen(
        title: 'Explore Themes',
        icon: 'themes',
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const PlaceholderScreen(
        title: 'Settings',
        icon: 'settings',
      ),
    ),
  ],
);

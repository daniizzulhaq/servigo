import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:servigo/core/router/app_routes.dart';
import 'package:servigo/features/api_check/presentation/api_check_screen.dart';
import 'package:servigo/features/home/presentation/theme_preview_screen.dart';
import 'package:servigo/features/home/presentation/welcome_screen.dart';
import 'package:servigo/features/services/presentation/service_detail_placeholder_screen.dart';
import 'package:servigo/features/splash/presentation/splash_screen.dart';
import 'package:servigo/shared/widgets/not_found_screen.dart';

/// Lokasi awal aplikasi: Splash.
/// Dibuat provider agar test bisa menggantinya (override)
/// untuk langsung membuka halaman tertentu atau mensimulasikan deep link.
final initialLocationProvider = Provider<String>(
  (ref) => AppRoutes.splashPath,
);

/// Router aplikasi, disediakan lewat Riverpod.
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: ref.read(initialLocationProvider),
    debugLogDiagnostics: kDebugMode,
    errorBuilder: (context, state) =>
        NotFoundScreen(location: state.uri.toString()),
    routes: [
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcomePath,
        name: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.themePreviewPath,
        name: AppRoutes.themePreview,
        builder: (context, state) => const ThemePreviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.apiCheckPath,
        name: AppRoutes.apiCheck,
        builder: (context, state) => const ApiCheckScreen(),
      ),
      GoRoute(
        path: AppRoutes.serviceDetailPath,
        name: AppRoutes.serviceDetail,
        builder: (context, state) {
          final serviceId = state.pathParameters['id']!;
          final from = state.uri.queryParameters['from'];

          return ServiceDetailPlaceholderScreen(
            serviceId: serviceId,
            from: from,
          );
        },
      ),
    ],
  );

  ref.onDispose(router.dispose);

  return router;
});
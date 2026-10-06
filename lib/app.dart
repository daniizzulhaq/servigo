import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servigo/core/constants/app_constants.dart';
import 'package:servigo/core/router/app_router.dart';
import 'package:servigo/core/theme/app_theme.dart';
import 'package:servigo/core/theme/theme_mode_provider.dart';

/// Widget akar aplikasi.
///
/// ConsumerWidget = StatelessWidget yang punya `ref`.
/// Semua yang berubah-ubah (router, mode tema) sekarang datang dari provider,
/// jadi widget ini tidak perlu lagi menjadi StatefulWidget.
class ServiGoApp extends ConsumerWidget {
  const ServiGoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
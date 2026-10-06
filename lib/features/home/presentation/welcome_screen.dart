import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:servigo/core/constants/app_constants.dart';
import 'package:servigo/core/router/app_routes.dart';
import 'package:servigo/core/theme/app_spacing.dart';
import 'package:servigo/shared/widgets/app_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppLogo(),
              const SizedBox(height: AppSpacing.lg),
              Text(AppConstants.appName, style: textTheme.headlineLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppConstants.tagline,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fondasi project siap! 🎉'),
                      ),
                    );
                  },
                  child: const Text('Mulai'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.pushNamed(AppRoutes.themePreview),
                  child: const Text('Lihat Theme Preview'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => context.pushNamed(
                      AppRoutes.serviceDetail,
                      pathParameters: {'id': '12'},
                      queryParameters: {'from': 'welcome'},
                    ),
                    child: const Text('Contoh Detail Layanan'),
                  ),
                  TextButton(
                    onPressed: () => context.pushNamed(AppRoutes.apiCheck),
                    child: const Text('Cek Koneksi API'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
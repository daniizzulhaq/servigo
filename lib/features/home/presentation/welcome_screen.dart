import 'package:flutter/material.dart';
import 'package:servigo/core/constants/app_constants.dart';
import 'package:servigo/core/theme/app_spacing.dart';
import 'package:servigo/features/home/presentation/theme_preview_screen.dart';
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
                        content: Text('Theme berhasil diterapkan! 🎉'),
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
                  onPressed: () {
                    // Navigasi sementara. Diganti GoRouter di Tahap 4.
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ThemePreviewScreen(),
                      ),
                    );
                  },
                  child: const Text('Lihat Theme Preview'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:servigo/core/router/app_routes.dart';
import 'package:servigo/core/theme/app_spacing.dart';

/// Halaman yang tampil bila alamat rute tidak ditemukan.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, required this.location});

  /// Alamat yang gagal dibuka, ditampilkan agar mudah di-debug.
  final String location;

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
            children: [
              Icon(
                Icons.explore_off_rounded,
                size: 72,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Halaman tidak ditemukan', style: textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                location,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: () => context.goNamed(AppRoutes.welcome),
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
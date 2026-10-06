import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:servigo/core/router/app_routes.dart';
import 'package:servigo/core/theme/app_spacing.dart';

/// Halaman contoh untuk belajar path parameter dan query parameter.
/// Akan diganti halaman detail layanan yang sebenarnya di Tahap 14.
class ServiceDetailPlaceholderScreen extends StatelessWidget {
  const ServiceDetailPlaceholderScreen({
    super.key,
    required this.serviceId,
    this.from,
  });

  final String serviceId;
  final String? from;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Layanan')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID layanan: $serviceId', style: textTheme.titleLarge),
            if (from != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text('Dari: $from', style: textTheme.bodyLarge),
            ],
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => context.goNamed(AppRoutes.welcome),
              child: const Text('Kembali ke Awal (go)'),
            ),
          ],
        ),
      ),
    );
  }
}
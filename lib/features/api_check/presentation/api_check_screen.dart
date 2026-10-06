import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servigo/core/constants/api_constants.dart';
import 'package:servigo/core/network/api_exception.dart';
import 'package:servigo/core/theme/app_colors.dart';
import 'package:servigo/core/theme/app_spacing.dart';
import 'package:servigo/features/api_check/models/api_check_result.dart';
import 'package:servigo/features/api_check/providers/api_check_provider.dart';

/// Layar sementara untuk menguji koneksi ke API dan melihat
/// state loading / sukses / error.
class ApiCheckScreen extends ConsumerWidget {
  const ApiCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(apiCheckProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cek Koneksi API')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Base URL', style: textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            SelectableText(ApiConstants.baseUrl, style: textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
            _ResultCard(state: state),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                // Saat loading, tombol dinonaktifkan agar tidak dobel kirim.
                onPressed: state.isLoading
                    ? null
                    : () => ref.read(apiCheckProvider.notifier).check(),
                icon: const Icon(Icons.network_check_rounded),
                label: const Text('Cek Koneksi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.state});

  final AsyncValue<ApiCheckResult?> state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: state.when(
          loading: () => Row(
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(width: AppSpacing.md),
              Text('Menghubungi server...', style: textTheme.bodyLarge),
            ],
          ),
          error: (error, _) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_rounded, color: colorScheme.error),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gagal terhubung', style: textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      error is ApiException
                          ? error.message
                          : 'Terjadi kesalahan tak terduga.',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          data: (result) {
            if (result == null) {
              return Text(
                'Tekan tombol di bawah untuk menguji koneksi ke server.',
                style: textTheme.bodyLarge,
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.success),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Terhubung', style: textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Status: ${result.statusCode}'),
                      const SizedBox(height: AppSpacing.xs),
                      Text(result.summary, style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
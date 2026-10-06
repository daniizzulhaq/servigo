import 'package:flutter/material.dart';
import 'package:servigo/core/theme/app_colors.dart';
import 'package:servigo/core/theme/app_spacing.dart';

/// Halaman sementara untuk melihat hasil tema.
/// Akan dihapus setelah kita selesai belajar tema (sebelum fitur nyata).
class ThemePreviewScreen extends StatelessWidget {
  const ThemePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Preview')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const _SectionTitle('Typography'),
          Text('Display Small', style: textTheme.displaySmall),
          Text('Headline Medium', style: textTheme.headlineMedium),
          Text('Title Large', style: textTheme.titleLarge),
          Text('Title Medium', style: textTheme.titleMedium),
          Text(
            'Body Large: Teknisi akan datang sesuai jadwal yang kamu pilih.',
            style: textTheme.bodyLarge,
          ),
          Text(
            'Body Medium: Detail layanan dan estimasi biaya.',
            style: textTheme.bodyMedium,
          ),
          Text('Label Large', style: textTheme.labelLarge),
          const SizedBox(height: AppSpacing.lg),
          const _SectionTitle('Warna'),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _Swatch(label: 'primary', color: colorScheme.primary),
              _Swatch(
                label: 'primaryContainer',
                color: colorScheme.primaryContainer,
              ),
              _Swatch(label: 'secondary', color: colorScheme.secondary),
              _Swatch(label: 'surface', color: colorScheme.surface),
              _Swatch(label: 'error', color: colorScheme.error),
              const _Swatch(label: 'success', color: AppColors.success),
              const _Swatch(label: 'warning', color: AppColors.warning),
              const _Swatch(label: 'info', color: AppColors.info),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionTitle('Komponen'),
          FilledButton(onPressed: () {}, child: const Text('Filled Button')),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Outlined Button'),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(onPressed: () {}, child: const Text('Text Button')),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.rating),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Card memakai gaya dari CardThemeData.',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.tonal(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ini SnackBar bergaya floating')),
              );
            },
            child: const Text('Tampilkan SnackBar'),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Pilih warna teks yang kontras terhadap warna latar swatch.
    final isDark = ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
    final foreground = isDark ? Colors.white : Colors.black;

    return Container(
      width: 104,
      height: 64,
      padding: const EdgeInsets.all(AppSpacing.sm),
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foreground,
            ),
      ),
    );
  }
}
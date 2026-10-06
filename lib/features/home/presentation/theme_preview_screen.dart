import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servigo/core/theme/app_colors.dart';
import 'package:servigo/core/theme/app_spacing.dart';
import 'package:servigo/core/theme/theme_mode_provider.dart';

/// Halaman sementara untuk melihat hasil tema dan mencoba Riverpod.
/// Akan dihapus setelah kita selesai belajar tema (sebelum fitur nyata).
class ThemePreviewScreen extends ConsumerWidget {
  const ThemePreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // watch: widget ini rebuild setiap themeMode berubah.
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Preview')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const _SectionTitle('Mode Tema'),
          SegmentedButton<ThemeMode>(
            showSelectedIcon: false,
            segments: const <ButtonSegment<ThemeMode>>[
              ButtonSegment(
                value: ThemeMode.system,
                label: Text('Sistem'),
                icon: Icon(Icons.brightness_auto_rounded),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Terang'),
                icon: Icon(Icons.light_mode_rounded),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Gelap'),
                icon: Icon(Icons.dark_mode_rounded),
              ),
            ],
            selected: {themeMode},
            // read: di dalam callback kita hanya ingin MEMANGGIL aksi,
            // bukan mendengarkan perubahan.
            onSelectionChanged: (selection) {
              ref.read(themeModeProvider.notifier).setMode(selection.first);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
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
    final isDark =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
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
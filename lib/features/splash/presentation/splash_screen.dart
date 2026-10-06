import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:servigo/core/constants/app_constants.dart';
import 'package:servigo/core/theme/app_spacing.dart';
import 'package:servigo/features/splash/providers/splash_provider.dart';
import 'package:servigo/shared/widgets/app_logo.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // listen (bukan watch): navigasi adalah efek samping, bukan tampilan.
    // Memanggil listen juga otomatis "menyalakan" provider tujuan.
    ref.listen<AsyncValue<String>>(splashDestinationProvider, (
      previous,
      next,
    ) {
      next.whenData((destination) {
        // Pastikan widget masih ada setelah proses async.
        if (!context.mounted) return;

        // go (bukan push): splash diganti, jadi tombol Back
        // tidak bisa kembali ke splash.
        context.go(destination);
      });
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                // Satu animasi 0 → 1 selama 1 detik, dibagi dua tahap
                // memakai Interval: logo dulu, lalu teks menyusul.
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1000),
                  builder: (context, t, child) {
                    // Tahap 1 (0% - 60%): logo membesar sambil memantul kecil.
                    final logoT = const Interval(
                      0.0,
                      0.6,
                      curve: Curves.easeOutBack,
                    ).transform(t);

                    // Tahap 2 (40% - 100%): teks muncul dari bawah.
                    final textT = const Interval(
                      0.4,
                      1.0,
                      curve: Curves.easeOut,
                    ).transform(t);

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Opacity(
                          // easeOutBack bisa sedikit melewati 1,
                          // sedangkan Opacity hanya menerima 0..1.
                          opacity: logoT.clamp(0.0, 1.0).toDouble(),
                          child: Transform.scale(
                            scale: 0.6 + 0.4 * logoT,
                            child: const AppLogo(size: 128),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Opacity(
                          opacity: textT,
                          child: Transform.translate(
                            offset: Offset(0, 12 * (1 - textT)),
                            child: Column(
                              children: [
                                Text(
                                  AppConstants.appName,
                                  style: textTheme.headlineLarge,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  AppConstants.tagline,
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xl),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
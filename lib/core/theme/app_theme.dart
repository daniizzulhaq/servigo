import 'package:flutter/material.dart';
import 'package:servigo/core/theme/app_colors.dart';
import 'package:servigo/core/theme/app_spacing.dart';
import 'package:servigo/core/theme/app_typography.dart';

/// Pusat konfigurasi tema aplikasi.
///
/// Pemakaian di MaterialApp:
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    // 1. Palet warna dihasilkan dari satu warna dasar.
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
    );

    // 2. Tema dasar Material 3 memakai palet tadi.
    final base = ThemeData(useMaterial3: true, colorScheme: colorScheme);

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );

    // 3. Tambahkan tipografi dan gaya komponen.
    return base.copyWith(
      textTheme: AppTypography.textTheme(base.textTheme),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: buttonShape,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
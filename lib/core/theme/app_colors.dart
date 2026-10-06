import 'package:flutter/material.dart';

/// Warna brand dan warna semantik ServiGo.
///
/// Warna "peran" (primary, surface, error, ...) TIDAK ditulis di sini,
/// karena dihasilkan otomatis oleh ColorScheme.fromSeed di AppTheme.
/// File ini hanya berisi:
/// 1. warna dasar (seed) untuk menghasilkan palet,
/// 2. warna semantik yang tidak ada di ColorScheme.
class AppColors {
  AppColors._();

  /// Warna dasar brand. Seluruh palet light/dark dibuat dari warna ini.
  static const Color seed = Color(0xFF1E88E5);

  // Warna semantik (makna tetap, dipakai untuk status).
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color info = Color(0xFF0288D1);

  /// Warna bintang rating.
  static const Color rating = Color(0xFFFFB300);
}
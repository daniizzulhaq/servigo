import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Memegang pilihan mode tema: sistem, terang, atau gelap.
///
/// Notifier = tempat state + method untuk mengubahnya.
/// State di sini bertipe [ThemeMode].
class ThemeModeNotifier extends Notifier<ThemeMode> {
  /// Dipanggil sekali saat provider pertama kali dibaca.
  /// Nilai yang dikembalikan menjadi state awal.
  @override
  ThemeMode build() => ThemeMode.system;

  /// Mengubah mode tema. Memberi nilai baru ke `state`
  /// otomatis memberi tahu semua widget yang me-watch provider ini.
  void setMode(ThemeMode mode) {
    state = mode;
  }
}

/// Provider yang diakses dari UI:
///   ref.watch(themeModeProvider)            → membaca nilai ThemeMode
///   ref.read(themeModeProvider.notifier)    → memanggil method (setMode)
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
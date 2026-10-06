import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servigo/core/router/app_routes.dart';

/// Lama minimum splash tampil.
/// Dibuat provider agar test bisa mempercepatnya (override).
final splashDurationProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 2200),
);

/// Menentukan ke halaman mana user dikirim setelah splash.
///
/// Saat ini selalu ke Welcome. Nanti fungsi INI yang akan diubah:
///   - Tahap 8  : cek apakah onboarding sudah pernah dilihat
///   - Tahap 33 : cek apakah ada token login yang valid
/// Tampilan (SplashScreen) tidak perlu berubah sama sekali.
final splashDestinationProvider = FutureProvider<String>((ref) async {
  final duration = ref.watch(splashDurationProvider);

  // Pekerjaan awal nanti ditaruh di sini (baca storage, cek token, dll).
  // Future.delayed menjamin splash tampil minimal sepanjang [duration].
  await Future<void>.delayed(duration);

  return AppRoutes.welcomePath;
});
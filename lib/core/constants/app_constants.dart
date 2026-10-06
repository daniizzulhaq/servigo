/// Konstanta global aplikasi.
///
/// Semua teks/nilai yang dipakai di banyak tempat ditaruh di sini
/// supaya cukup diubah di satu lokasi.
class AppConstants {
  // Class ini hanya berisi konstanta, jadi constructor dibuat private
  // agar tidak bisa dibuat objeknya: AppConstants() -> error.
  AppConstants._();

  static const String appName = 'ServiGo';
  static const String tagline = 'Semua jasa rumah, satu aplikasi.';
}
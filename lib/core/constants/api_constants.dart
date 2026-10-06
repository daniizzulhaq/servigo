/// Konfigurasi API. SATU-SATUNYA tempat base URL ditulis.
class ApiConstants {
  ApiConstants._();

  /// Base URL diambil dari `--dart-define=API_BASE_URL=...` saat run/build.
  /// Jika tidak diberikan, dipakai nilai default untuk emulator Android:
  /// 10.0.2.2 = "localhost" milik komputer yang menjalankan emulator.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api/v1',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// Endpoint sederhana untuk mengecek apakah server hidup.
  static const String pingPath = '/ping';
}
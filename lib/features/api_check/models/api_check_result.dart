/// Hasil pengecekan koneksi ke API.
class ApiCheckResult {
  const ApiCheckResult({required this.statusCode, required this.summary});

  final int statusCode;
  final String summary;
}
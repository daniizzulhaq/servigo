import 'package:dio/dio.dart';
import 'package:servigo/core/network/api_exception.dart';

/// Membungkus pemanggilan API: DioException otomatis diubah menjadi
/// ApiException. Dipakai di repository, BUKAN di UI.
///
/// Contoh:
///   return safeApiCall(() async {
///     final response = await dataSource.getServices();
///     return ...;
///   });
Future<T> safeApiCall<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (e) {
    // Stack trace asli dipertahankan agar mudah di-debug.
    Error.throwWithStackTrace(ApiException.fromDioException(e), e.stackTrace);
  }
}
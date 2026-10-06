import 'package:dio/dio.dart';

/// Menambahkan header `Authorization: Bearer <token>` ke setiap request
/// jika token tersedia.
///
/// Di Tahap 33, [readToken] akan membaca token dari Flutter Secure Storage.
/// Untuk saat ini token selalu null, jadi tidak ada header yang ditambahkan.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.readToken});

  final Future<String?> Function() readToken;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servigo/core/constants/api_constants.dart';
import 'package:servigo/core/network/auth_interceptor.dart';

/// Membuat instance Dio yang sudah dikonfigurasi.
/// Dibuat sebagai fungsi agar mudah dites dengan base URL/token berbeda.
Dio buildDio({
  String baseUrl = ApiConstants.baseUrl,
  Future<String?> Function()? readToken,
  bool enableLogging = kDebugMode,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      // Wajib untuk Laravel agar error dibalas JSON, bukan redirect HTML.
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(readToken: readToken ?? () async => null),
  );

  if (enableLogging) {
    // Body dan header sengaja TIDAK dicetak: bisa berisi password dan token.
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
        logPrint: (object) => debugPrint(object.toString()),
      ),
    );
  }

  return dio;
}

/// Satu instance Dio untuk seluruh aplikasi.
/// Repository/data source memintanya lewat ref.read(dioProvider).
final dioProvider = Provider<Dio>((ref) {
  final dio = buildDio();
  ref.onDispose(dio.close);
  return dio;
});
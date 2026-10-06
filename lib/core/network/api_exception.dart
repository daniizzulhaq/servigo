import 'dart:io';

import 'package:dio/dio.dart';

/// Jenis error yang dikenali UI.
/// UI cukup memeriksa jenis ini tanpa perlu tahu apa-apa soal Dio.
enum ApiErrorType {
  noConnection,
  timeout,
  cancelled,
  unauthorized,
  forbidden,
  notFound,
  validation,
  tooManyRequests,
  server,
  unknown,
}

/// Error yang sudah "diterjemahkan" dari DioException.
class ApiException implements Exception {
  const ApiException({
    required this.type,
    required this.message,
    this.statusCode,
    this.fieldErrors = const {},
  });

  final ApiErrorType type;

  /// Pesan yang aman ditampilkan ke user.
  final String message;

  final int? statusCode;

  /// Error per field untuk status 422 (validasi Laravel).
  ///
  /// Contoh:
  /// {
  ///   'email': ['Email wajib diisi.']
  /// }
  final Map<String, List<String>> fieldErrors;

  /// Mengubah DioException menjadi ApiException
  /// yang lebih mudah digunakan oleh UI.
  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiException(
          type: ApiErrorType.timeout,
          message: 'Server terlalu lama merespons. Coba lagi.',
        );

      case DioExceptionType.connectionError:
        return const ApiException(
          type: ApiErrorType.noConnection,
          message: 'Tidak dapat terhubung ke server. '
              'Periksa koneksi internet kamu.',
        );

      case DioExceptionType.cancel:
        return const ApiException(
          type: ApiErrorType.cancelled,
          message: 'Permintaan dibatalkan.',
        );

      case DioExceptionType.badResponse:
        return _fromResponse(e.response);

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return const ApiException(
            type: ApiErrorType.noConnection,
            message: 'Tidak dapat terhubung ke server. '
                'Periksa koneksi internet kamu.',
          );
        }

        return const ApiException(
          type: ApiErrorType.unknown,
          message: 'Terjadi kesalahan. Coba lagi.',
        );
    }
  }

  /// Mengubah response HTTP dari Laravel
  /// menjadi ApiException berdasarkan status code.
  static ApiException _fromResponse(
    Response<dynamic>? response,
  ) {
    final status = response?.statusCode;
    final data = response?.data;

    // Format error Laravel:
    //
    // {
    //   "message": "...",
    //   "errors": {
    //     "email": [
    //       "Email wajib diisi."
    //     ]
    //   }
    // }
    final serverMessage = data is Map && data['message'] is String
        ? data['message'] as String
        : null;

    // Validation Error
    if (status == 422) {
      return ApiException(
        type: ApiErrorType.validation,
        statusCode: status,
        message: serverMessage ?? 'Data yang dikirim tidak valid.',
        fieldErrors: _parseFieldErrors(data),
      );
    }

    // Unauthorized
    if (status == 401) {
      return ApiException(
        type: ApiErrorType.unauthorized,
        statusCode: status,
        message:
            serverMessage ?? 'Sesi kamu berakhir. Silakan login kembali.',
      );
    }

    // Forbidden
    if (status == 403) {
      return ApiException(
        type: ApiErrorType.forbidden,
        statusCode: status,
        message:
            serverMessage ?? 'Kamu tidak memiliki akses untuk tindakan ini.',
      );
    }

    // Not Found
    if (status == 404) {
      // Pesan server sengaja diabaikan.
      // 404 Laravel sering berisi detail teknis.
      return ApiException(
        type: ApiErrorType.notFound,
        statusCode: status,
        message: 'Data yang dicari tidak ditemukan.',
      );
    }

    // Too Many Requests
    if (status == 429) {
      return ApiException(
        type: ApiErrorType.tooManyRequests,
        statusCode: status,
        message:
            'Terlalu banyak percobaan. Coba lagi beberapa saat lagi.',
      );
    }

    // Server Error
    if (status != null && status >= 500) {
      // Pesan server JANGAN ditampilkan.
      // Bisa berisi detail internal seperti SQL atau path server.
      return ApiException(
        type: ApiErrorType.server,
        statusCode: status,
        message:
            'Terjadi masalah di server. Coba lagi beberapa saat lagi.',
      );
    }

    // Error lainnya
    return ApiException(
      type: ApiErrorType.unknown,
      statusCode: status,
      message: serverMessage ?? 'Terjadi kesalahan. Coba lagi.',
    );
  }

  /// Mengambil error validasi per field dari response Laravel.
  ///
  /// Contoh response:
  ///
  /// {
  ///   "message": "The email field is required.",
  ///   "errors": {
  ///     "email": [
  ///       "Email wajib diisi."
  ///     ],
  ///     "password": [
  ///       "Password wajib diisi."
  ///     ]
  ///   }
  /// }
  static Map<String, List<String>> _parseFieldErrors(
    Object? data,
  ) {
    if (data is! Map || data['errors'] is! Map) {
      return const {};
    }

    final result = <String, List<String>>{};

    (data['errors'] as Map).forEach((key, value) {
      if (value is List) {
        result[key.toString()] = value
            .map((error) => error.toString())
            .toList();
      }
    });

    return result;
  }

  @override
  String toString() {
    return 'ApiException($type, status: $statusCode): $message';
  }
}
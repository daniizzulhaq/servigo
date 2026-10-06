import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servigo/core/network/api_call.dart';
import 'package:servigo/core/network/api_exception.dart';

DioException badResponse(int status, [Object? data]) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: options,
      statusCode: status,
      data: data,
    ),
  );
}

DioException ofType(DioExceptionType type, {Object? error}) {
  return DioException(
    requestOptions: RequestOptions(path: '/x'),
    type: type,
    error: error,
  );
}

void main() {
  group('ApiException.fromDioException', () {
    test('422 menghasilkan validation + fieldErrors dari Laravel', () {
      final e = ApiException.fromDioException(
        badResponse(422, {
          'message': 'The email field is required.',
          'errors': {
            'email': ['Email wajib diisi.'],
          },
        }),
      );

      expect(e.type, ApiErrorType.validation);
      expect(e.statusCode, 422);
      expect(e.message, 'The email field is required.');
      expect(e.fieldErrors['email'], ['Email wajib diisi.']);
    });

    test('401 tanpa pesan server memakai pesan default', () {
      final e = ApiException.fromDioException(badResponse(401));

      expect(e.type, ApiErrorType.unauthorized);
      expect(e.message, 'Sesi kamu berakhir. Silakan login kembali.');
    });

    test('404 mengabaikan pesan teknis dari server', () {
      final e = ApiException.fromDioException(
        badResponse(404, {'message': 'No query results for model [Order] 5'}),
      );

      expect(e.type, ApiErrorType.notFound);
      expect(e.message, isNot(contains('Order')));
    });

    test('429 menghasilkan tooManyRequests', () {
      final e = ApiException.fromDioException(badResponse(429));

      expect(e.type, ApiErrorType.tooManyRequests);
    });

    test('500 tidak membocorkan pesan server ke user', () {
      final e = ApiException.fromDioException(
        badResponse(500, {'message': 'SQLSTATE[HY000]: General error'}),
      );

      expect(e.type, ApiErrorType.server);
      expect(e.message, isNot(contains('SQLSTATE')));
    });

    test('connectionError menghasilkan noConnection', () {
      final e = ApiException.fromDioException(
        ofType(DioExceptionType.connectionError),
      );

      expect(e.type, ApiErrorType.noConnection);
    });

    test('SocketException (type unknown) menghasilkan noConnection', () {
      final e = ApiException.fromDioException(
        ofType(
          DioExceptionType.unknown,
          error: const SocketException('Failed host lookup'),
        ),
      );

      expect(e.type, ApiErrorType.noConnection);
    });

    test('receiveTimeout menghasilkan timeout', () {
      final e = ApiException.fromDioException(
        ofType(DioExceptionType.receiveTimeout),
      );

      expect(e.type, ApiErrorType.timeout);
    });

    test('cancel menghasilkan cancelled', () {
      final e = ApiException.fromDioException(ofType(DioExceptionType.cancel));

      expect(e.type, ApiErrorType.cancelled);
    });
  });

  group('safeApiCall', () {
    test('mengubah DioException menjadi ApiException', () {
      expect(
        safeApiCall<int>(() async {
          throw ofType(DioExceptionType.connectionError);
        }),
        throwsA(isA<ApiException>()),
      );
    });

    test('mengembalikan hasil jika tidak ada error', () async {
      final result = await safeApiCall<int>(() async => 42);

      expect(result, 42);
    });
  });
}
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Adapter Dio palsu: request TIDAK keluar ke jaringan,
/// jawabannya ditentukan oleh [handler] milik test.
class FakeHttpClientAdapter implements HttpClientAdapter {
  FakeHttpClientAdapter(this.handler);

  final Future<ResponseBody> Function(RequestOptions options) handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

/// Membuat respons JSON palsu.
ResponseBody jsonResponse(Object body, int statusCode) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

/// Membuat Dio yang memakai adapter palsu.
Dio makeFakeDio(Future<ResponseBody> Function(RequestOptions options) handler) {
  final dio = Dio(BaseOptions(baseUrl: 'http://test.local/api/v1'));
  dio.httpClientAdapter = FakeHttpClientAdapter(handler);
  return dio;
}
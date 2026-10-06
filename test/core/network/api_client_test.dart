import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servigo/core/network/api_client.dart';

import '../../helpers/fake_http_client_adapter.dart';

void main() {
  Future<RequestOptions> captureRequest(Dio dio) async {
    late RequestOptions captured;
    dio.httpClientAdapter = FakeHttpClientAdapter((options) async {
      captured = options;
      return jsonResponse({'ok': true}, 200);
    });

    await dio.get<dynamic>('/ping');
    return captured;
  }

  test('request memakai header Accept JSON dan base URL yang benar', () async {
    final dio = buildDio(baseUrl: 'http://test.local/api/v1', enableLogging: false);

    final options = await captureRequest(dio);

    expect(options.headers['Accept'], 'application/json');
    expect(options.uri.toString(), 'http://test.local/api/v1/ping');
  });

  test('token tersedia → header Authorization Bearer ditambahkan', () async {
    final dio = buildDio(
      baseUrl: 'http://test.local/api/v1',
      readToken: () async => 'abc123',
      enableLogging: false,
    );

    final options = await captureRequest(dio);

    expect(options.headers['Authorization'], 'Bearer abc123');
  });

  test('tanpa token → tidak ada header Authorization', () async {
    final dio = buildDio(
      baseUrl: 'http://test.local/api/v1',
      enableLogging: false,
    );

    final options = await captureRequest(dio);

    expect(options.headers.containsKey('Authorization'), isFalse);
  });
}
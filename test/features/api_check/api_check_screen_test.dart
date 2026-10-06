import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servigo/app.dart';
import 'package:servigo/core/network/api_client.dart';
import 'package:servigo/core/router/app_router.dart';
import 'package:servigo/core/router/app_routes.dart';

import '../../helpers/fake_http_client_adapter.dart';

Future<void> pumpApiCheck(WidgetTester tester, Dio dio) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        dioProvider.overrideWithValue(dio),
        initialLocationProvider.overrideWithValue(AppRoutes.apiCheckPath),
      ],
      child: const ServiGoApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Server membalas sukses → menampilkan status dan ringkasan',
      (tester) async {
    final dio = makeFakeDio((options) async {
      return jsonResponse({'message': 'pong'}, 200);
    });
    await pumpApiCheck(tester, dio);

    expect(
      find.text('Tekan tombol di bawah untuk menguji koneksi ke server.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Cek Koneksi'));
    await tester.pumpAndSettle();

    expect(find.text('Terhubung'), findsOneWidget);
    expect(find.text('Status: 200'), findsOneWidget);
    expect(find.text('pong'), findsOneWidget);
  });

  testWidgets('Server tidak terjangkau → menampilkan pesan error ramah',
      (tester) async {
    final dio = makeFakeDio((options) async {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      );
    });
    await pumpApiCheck(tester, dio);

    await tester.tap(find.text('Cek Koneksi'));
    await tester.pumpAndSettle();

    expect(find.text('Gagal terhubung'), findsOneWidget);
    expect(
      find.text(
        'Tidak dapat terhubung ke server. Periksa koneksi internet kamu.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Server error 500 → pesan generik tanpa detail teknis',
      (tester) async {
    final dio = makeFakeDio((options) async {
      return jsonResponse({'message': 'SQLSTATE[HY000] rahasia'}, 500);
    });
    await pumpApiCheck(tester, dio);

    await tester.tap(find.text('Cek Koneksi'));
    await tester.pumpAndSettle();

    expect(
      find.text('Terjadi masalah di server. Coba lagi beberapa saat lagi.'),
      findsOneWidget,
    );
    expect(find.textContaining('SQLSTATE'), findsNothing);
  });
}
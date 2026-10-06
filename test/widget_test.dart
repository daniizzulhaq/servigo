import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servigo/app.dart';
import 'package:servigo/core/constants/app_constants.dart';
import 'package:servigo/core/router/app_router.dart';
import 'package:servigo/core/router/app_routes.dart';
import 'package:servigo/shared/widgets/app_logo.dart';

/// Menjalankan app dengan ProviderScope baru untuk setiap test,
/// sehingga state (router, tema) tidak bocor antar test.
///
/// Default mulai dari Welcome (bukan Splash). Test Splash ada di
/// test/features/splash/splash_screen_test.dart.
Future<void> pumpApp(WidgetTester tester, {String? initialLocation}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        initialLocationProvider.overrideWithValue(
          initialLocation ?? AppRoutes.welcomePath,
        ),
      ],
      child: const ServiGoApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Welcome screen menampilkan logo, nama app, dan tombol',
      (tester) async {
    await pumpApp(tester);

    expect(find.byType(AppLogo), findsOneWidget);
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.tagline), findsOneWidget);
    expect(find.text('Mulai'), findsOneWidget);
  });

  testWidgets('Tombol Theme Preview membuka halaman preview', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Lihat Theme Preview'));
    await tester.pumpAndSettle();

    expect(find.text('Theme Preview'), findsOneWidget);
    expect(find.text('Typography'), findsOneWidget);
  });

  testWidgets('Tombol contoh membuka detail layanan dengan parameter',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Contoh Detail Layanan'));
    await tester.pumpAndSettle();

    expect(find.text('Detail Layanan'), findsOneWidget);
    expect(find.text('ID layanan: 12'), findsOneWidget);
    expect(find.text('Dari: welcome'), findsOneWidget);
  });

  testWidgets('Deep link langsung membuka halaman detail', (tester) async {
    await pumpApp(tester, initialLocation: '/services/99?from=test');

    expect(find.text('ID layanan: 99'), findsOneWidget);
    expect(find.text('Dari: test'), findsOneWidget);
  });

  testWidgets('Alamat yang tidak ada menampilkan halaman 404', (tester) async {
    await pumpApp(tester, initialLocation: '/halaman-ngawur');

    expect(find.text('Halaman tidak ditemukan'), findsOneWidget);
    expect(find.text('/halaman-ngawur'), findsOneWidget);
  });

  testWidgets('Memilih mode Gelap mengubah themeMode aplikasi', (tester) async {
    await pumpApp(tester);

    // Awalnya mengikuti sistem.
    var app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.system);

    await tester.tap(find.text('Lihat Theme Preview'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gelap'));
    await tester.pumpAndSettle();

    app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
  });
}
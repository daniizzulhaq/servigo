import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servigo/app.dart';
import 'package:servigo/core/constants/app_constants.dart';
import 'package:servigo/core/router/app_routes.dart';
import 'package:servigo/features/splash/presentation/splash_screen.dart';
import 'package:servigo/features/splash/providers/splash_provider.dart';
import 'package:servigo/shared/widgets/app_logo.dart';

void main() {
  testWidgets('Splash menampilkan brand lalu pindah ke Welcome', (tester) async {
    const splashDuration = Duration(seconds: 2);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          splashDurationProvider.overrideWithValue(splashDuration),
        ],
        // Tanpa override initialLocation → app mulai dari Splash (default).
        child: const ServiGoApp(),
      ),
    );

    // Frame pertama: splash tampil.
    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(AppLogo), findsOneWidget);
    expect(find.text('Mulai'), findsNothing);

    // Maju sampai animasi (1 detik) selesai: nama app dan tagline terlihat.
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.tagline), findsOneWidget);

    // Maju melewati sisa durasi splash → timer selesai → navigasi berjalan.
    // (pumpAndSettle tidak dipakai SAAT splash tampil, karena spinner
    // berputar tanpa henti dan test akan time out.)
    await tester.pump(splashDuration);
    await tester.pump();

    // Setelah splash hilang tidak ada animasi tak terbatas lagi.
    await tester.pumpAndSettle();

    expect(find.byType(SplashScreen), findsNothing);
    expect(find.text('Mulai'), findsOneWidget);
  });

  test('splashDestinationProvider mengarah ke Welcome', () async {
    final container = ProviderContainer(
      overrides: [
        splashDurationProvider.overrideWithValue(Duration.zero),
      ],
    );
    addTearDown(container.dispose);

    final destination = await container.read(splashDestinationProvider.future);

    expect(destination, AppRoutes.welcomePath);
  });
}
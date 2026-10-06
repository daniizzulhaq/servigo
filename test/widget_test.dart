import 'package:flutter_test/flutter_test.dart';
import 'package:servigo/app.dart';
import 'package:servigo/core/constants/app_constants.dart';
import 'package:servigo/shared/widgets/app_logo.dart';

void main() {
  testWidgets('Welcome screen menampilkan logo, nama app, dan tombol',
      (tester) async {
    await tester.pumpWidget(const ServiGoApp());

    expect(find.byType(AppLogo), findsOneWidget);
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.tagline), findsOneWidget);
    expect(find.text('Mulai'), findsOneWidget);
  });
}
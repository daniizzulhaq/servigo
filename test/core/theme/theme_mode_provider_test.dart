import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servigo/core/theme/theme_mode_provider.dart';

void main() {
  test('state awal adalah ThemeMode.system', () {
    // ProviderContainer = "ProviderScope tanpa UI", cocok untuk unit test.
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(themeModeProvider), ThemeMode.system);
  });

  test('setMode mengubah state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(themeModeProvider.notifier).setMode(ThemeMode.dark);

    expect(container.read(themeModeProvider), ThemeMode.dark);
  });
}
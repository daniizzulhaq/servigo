import 'package:flutter/material.dart';

/// Logo ServiGo berupa ikon di dalam kotak rounded.
///
/// Ditaruh di `shared/widgets` karena akan dipakai di banyak fitur
/// (splash, onboarding, login, register).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 112});

  /// Ukuran sisi kotak logo. Ikon di dalamnya mengikuti proporsi 50%.
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Icon(
        Icons.home_repair_service_rounded,
        size: size / 2,
        color: colorScheme.onPrimaryContainer,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servigo/app.dart';

void main() {
  // ProviderScope menyimpan semua state provider. Wajib di paling atas.
  runApp(const ProviderScope(child: ServiGoApp()));
}
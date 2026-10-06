import 'package:flutter/material.dart';
import 'package:servigo/core/constants/app_constants.dart';
import 'package:servigo/core/theme/app_theme.dart';
import 'package:servigo/features/home/presentation/welcome_screen.dart';

class ServiGoApp extends StatelessWidget {
  const ServiGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const WelcomeScreen(),
    );
  }
}
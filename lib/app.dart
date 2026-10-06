import 'package:flutter/material.dart';
import 'package:servigo/core/constants/app_constants.dart';
import 'package:servigo/features/home/presentation/welcome_screen.dart';

class ServiGoApp extends StatelessWidget {
  const ServiGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
      ),
      home: const WelcomeScreen(),
    );
  }
}
// lib/core/theme/app_theme.dart
/// Material 3 theme definitions for Phone Store Manager.
/// Supports light/dark modes with Arabic RTL.
library;

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ── Colors ────────────────────────────────────────────────

  static const Color primarySeed = Color(0xFF1565C0);
  static const Color secondarySeed = Color(0xFF625B70);
  static const Color tertiarySeed = Color(0xFF7E589B);
  static const Color errorSeed = Color(0xFFB00020);

  // ── Light Theme ───────────────────────────────────────────

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: primarySeed,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarySeed,
      secondary: secondarySeed,
      tertiary: tertiarySeed,
      error: errorSeed,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontFamily: 'Cairo'),
      bodyMedium: TextStyle(fontFamily: 'Cairo'),
      bodySmall: TextStyle(fontFamily: 'Cairo'),
      titleLarge: TextStyle(fontFamily: 'Cairo'),
      titleMedium: TextStyle(fontFamily: 'Cairo'),
      titleSmall: TextStyle(fontFamily: 'Cairo'),
      headlineLarge: TextStyle(fontFamily: 'Cairo'),
      headlineMedium: TextStyle(fontFamily: 'Cairo'),
      headlineSmall: TextStyle(fontFamily: 'Cairo'),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.w600),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: TextStyle(fontFamily: 'Cairo', fontSize: 12),
      unselectedLabelStyle: TextStyle(fontFamily: 'Cairo', fontSize: 12),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: primarySeed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  // ── Dark Theme ────────────────────────────────────────────

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: primarySeed,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarySeed,
      secondary: secondarySeed,
      tertiary: tertiarySeed,
      error: errorSeed,
      brightness: Brightness.dark,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontFamily: 'Cairo'),
      bodyMedium: TextStyle(fontFamily: 'Cairo'),
      bodySmall: TextStyle(fontFamily: 'Cairo'),
      titleLarge: TextStyle(fontFamily: 'Cairo'),
      titleMedium: TextStyle(fontFamily: 'Cairo'),
      titleSmall: TextStyle(fontFamily: 'Cairo'),
      headlineLarge: TextStyle(fontFamily: 'Cairo'),
      headlineMedium: TextStyle(fontFamily: 'Cairo'),
      headlineSmall: TextStyle(fontFamily: 'Cairo'),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white70,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.w600),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: TextStyle(fontFamily: 'Cairo', fontSize: 12),
      unselectedLabelStyle: TextStyle(fontFamily: 'Cairo', fontSize: 12),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: primarySeed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

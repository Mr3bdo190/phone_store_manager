// lib/core/theme/app_theme.dart
/// Material 3 theme definitions for Phone Store Manager.
/// Supports light/dark modes with Arabic RTL.
///
/// Uses ColorScheme.fromSeed to generate a complete, accessible
/// color scheme with proper contrast for text and UI elements.
library;

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ── Colors ────────────────────────────────────────────────

  /// Primary seed — deep blue appropriate for a business app.
  static const Color primarySeed = Color(0xFF1565C0);
  static const Color secondarySeed = Color(0xFF0277BD);
  static const Color tertiarySeed = Color(0xFF5C6BC0);
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
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      selectedItemColor: primarySeed,
      unselectedItemColor: Colors.grey[600],
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: primarySeed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: TextStyle(color: Colors.grey[700]),
      hintStyle: TextStyle(color: Colors.grey[500]),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primarySeed,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
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
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white70,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      selectedItemColor: secondarySeed,
      unselectedItemColor: Colors.grey[500],
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: secondarySeed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: TextStyle(color: Colors.grey[400]),
      hintStyle: TextStyle(color: Colors.grey[600]),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: secondarySeed,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}

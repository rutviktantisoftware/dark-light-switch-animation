import 'package:flutter/material.dart';

/// App theme configurations for Light and Dark modes
class AppThemes {
  AppThemes._();

  /// Custom Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
      primary: const Color(0xFF6750A4),
      secondary: const Color(0xFFFF9800),
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFF2F4F8),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFF1E1E2C),
      centerTitle: true,
    ),
  );

  /// Custom Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFD0BCFF),
      brightness: Brightness.dark,
      primary: const Color(0xFFD0BCFF),
      secondary: const Color(0xFFFFB74D),
      surface: const Color(0xFF1E1E2D),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F0F17),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E2D),
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
  );
}

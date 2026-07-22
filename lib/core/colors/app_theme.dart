import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static const Color primary = AppColors.primary;
  static const Color accent = AppColors.secondary;
  static const Color bgLight = AppColors.background;
  static const Color textDark = AppColors.textPrimary;
  static const Color subtitleDark = AppColors.textSecondary;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgLight,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: AppColors.surface,
        onSurface: textDark,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          bodyLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: textDark,
          ),
          bodyMedium: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: subtitleDark,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121214),
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        background: Color(0xFF121214),
        surface: Color(0xFF1E1E24),
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        TextTheme(
          displayLarge: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleLarge: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleMedium: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyLarge: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.white70,
          ),
          bodyMedium: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
}

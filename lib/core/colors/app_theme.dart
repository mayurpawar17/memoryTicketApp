import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF4D41DF);
  static const Color accent = Color(0xFFFFB84D);
  static const Color bgLight = Color(0xFFF8F9FD);
  static const Color textDark = Color(0xFF191C1F);
  static const Color subtitleDark = Color(0xFF6B7280);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgLight,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: bgLight,
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

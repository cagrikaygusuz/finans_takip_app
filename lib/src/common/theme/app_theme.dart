import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Uygulamamızın modern görünümünü tanımlayan sınıf
class AppTheme {
  // Renk Paleti (Referans tasarımdan ilhamla)
  static const Color _primaryColor = Color(0xFF4A90E2);
  static const Color _lightSurfaceColor = Color(0xFFF2F2F7);
  static const Color _darkSurfaceColor = Color(0xFF1C1C1E);
  static const Color _darkBackgroundColor = Color(0xFF000000);

  // Açık Tema Tanımı
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.light,
        surface: _lightSurfaceColor,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      // DÜZELTME BURADA: CardTheme -> CardThemeData
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Koyu Tema Tanımı
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.dark,
        surface: _darkSurfaceColor,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
      scaffoldBackgroundColor: _darkBackgroundColor,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: _darkBackgroundColor,
      ),
      // DÜZELTME BURADA: CardTheme -> CardThemeData
      cardTheme: CardThemeData(
        elevation: 1,
        color: _darkSurfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
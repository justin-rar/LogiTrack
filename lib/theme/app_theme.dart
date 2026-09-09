import 'package:flutter/material.dart';

/// Konfigurasi tema visual terpusat untuk seluruh aplikasi LogiTrack.
/// Semua perubahan warna dan styling cukup dilakukan di file ini.
class AppTheme {
  // Primary palette
  static const Color warnaUtama = Color(0xFF1E3A5F);
  static const Color warnaUtamaGelap = Color(0xFF0F2A44);

  // Accent
  static const Color warnaAksen = Color(0xFFFFA726);

  // Background & text
  static const Color warnaBackground = Color(0xFFF5F5F5);
  static const Color warnaTeksGelap = Color(0xFF212121);
  static const Color warnaTeksTerang = Colors.white;

  /// ThemeData global yang di-inject melalui MaterialApp.
  static ThemeData get themeData {
    return ThemeData(
      scaffoldBackgroundColor: warnaBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: warnaUtama,
        foregroundColor: warnaTeksTerang,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: warnaAksen,
          foregroundColor: warnaTeksGelap,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: warnaUtama,
        primary: warnaUtama,
        secondary: warnaAksen,
      ),
    );
  }
}
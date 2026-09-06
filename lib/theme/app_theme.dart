import 'package:flutter/material.dart';

// File ini isinya cuma "warna-warna" yang mau kita pakai di seluruh aplikasi.
// Tujuannya: kalau nanti mau ganti warna, cukup ubah di SATU tempat ini saja,
// tidak perlu cari-cari di banyak file screen.

class AppTheme {
  // Warna utama tema logistik: Slate Blue / Dark Teal
  static const Color warnaUtama = Color(0xFF1E3A5F); // Slate Blue tua
  static const Color warnaUtamaGelap = Color(0xFF0F2A44); // lebih gelap, buat AppBar

  // Warna aksen: Amber/Orange (khas industri/gudang)
  static const Color warnaAksen = Color(0xFFFFA726); // Amber/Orange

  // Warna latar belakang halaman
  static const Color warnaBackground = Color(0xFFF5F5F5); // abu sangat terang

  // Warna teks
  static const Color warnaTeksGelap = Color(0xFF212121);
  static const Color warnaTeksTerang = Colors.white;

  // Ini "paket tema" lengkap yang nanti dipakai di main.dart
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
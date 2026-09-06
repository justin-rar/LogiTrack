import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'data_kelompok_screen.dart';
import 'kalkulator_screen.dart';
import 'sortir_zonasi_screen.dart';
import 'verifikasi_digit_screen.dart';

// Halaman Dashboard: menu utama setelah login berhasil.
// Pakai Drawer (menu geser dari samping) supaya gampang nambah menu baru nanti.

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LogiTrack - Dashboard"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Bagian atas Drawer, header dengan info aplikasi
            const DrawerHeader(
              decoration: BoxDecoration(color: AppTheme.warnaUtama),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.warehouse, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(
                    "LogiTrack",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    "Menu Staf Gudang",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            // TODO: nanti tiap ListTile di bawah ini dihubungkan ke
            // masing-masing halaman modul (Data Kelompok, Kalkulator, dst)
            ListTile(
              leading: const Icon(Icons.groups),
              title: const Text("Data Kelompok"),
              onTap: () {
                Navigator.pop(context); // tutup drawer dulu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DataKelompokScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text("Kalkulator Logistik"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KalkulatorScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.warehouse),
              title: const Text("Sortir Zonasi Rak"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SortirZonasiScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text("Verifikasi Digit"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VerifikasiDigitScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
                // Kembali ke halaman Login, dan hapus semua halaman
                // sebelumnya dari "riwayat" supaya tidak bisa di-back lagi.
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          "Selamat datang di LogiTrack!\nBuka menu di kiri atas untuk mulai.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
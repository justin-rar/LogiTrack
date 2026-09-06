import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';

// Halaman Login: tempat Staf Gudang memasukkan ID Petugas & Password.
// Ini StatefulWidget karena isinya (teks yang diketik user) bisa berubah-ubah.

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller ini "pegang" nilai yang diketik user di TextField
  final idPetugasController = TextEditingController();
  final passwordController = TextEditingController();

  // Ini tempat kredensial hardcoded sesuai keputusan di plan.md (§6, tanpa backend)
  final String idPetugasBenar = "LOG001";
  final String passwordBenar = "gudang2024";

  // Pesan error yang ditampilkan kalau login gagal / field kosong
  String pesanError = "";

  // State untuk kontrol visibilitas password (true = disembunyikan)
  bool _obscurePassword = true;

  void cekLogin() {
    String idPetugas = idPetugasController.text;
    String password = passwordController.text;

    // Validasi manual sederhana pakai if (sesuai gaya kode di plan.md §5)
    if (idPetugas.isEmpty || password.isEmpty) {
      setState(() {
        pesanError = "ID Petugas dan Password harus diisi!";
      });
      return;
    }

    if (idPetugas == idPetugasBenar && password == passwordBenar) {
      // Login berhasil -> pindah ke Dashboard
      // Navigator.pushReplacement dipakai (bukan push) supaya user tidak bisa
      // pencet tombol "back" balik ke halaman Login setelah berhasil masuk.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      setState(() {
        pesanError = "ID Petugas atau Password salah!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warehouse,
                size: 80,
                color: AppTheme.warnaUtama,
              ),
              const SizedBox(height: 12),
              const Text(
                "LogiTrack",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.warnaUtama,
                ),
              ),
              const Text(
                "Login Staf Gudang",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Field ID Petugas
              TextField(
                controller: idPetugasController,
                decoration: const InputDecoration(
                  labelText: "ID Petugas",
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Field Password
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // Pesan error, cuma muncul kalau ada isinya
              if (pesanError.isNotEmpty)
                Text(
                  pesanError,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),

              // Tombol Login, lebar penuh
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cekLogin,
                  child: const Text("LOGIN"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
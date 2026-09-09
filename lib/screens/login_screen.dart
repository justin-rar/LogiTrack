import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';

/// Halaman autentikasi staf gudang.
/// Menggunakan kredensial hardcoded (tanpa integrasi backend).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final idPetugasController = TextEditingController();
  final passwordController = TextEditingController();

  // Kredensial statis — akan diganti dengan API auth di fase berikutnya
  final String idPetugasBenar = "LOG001";
  final String passwordBenar = "gudang2024";

  String pesanError = "";
  bool _obscurePassword = true;

  /// Validasi input dan cocokkan dengan kredensial.
  /// Jika berhasil, navigasi ke Dashboard dengan pushReplacement
  /// agar user tidak bisa kembali ke halaman login via tombol back.
  void cekLogin() {
    String idPetugas = idPetugasController.text;
    String password = passwordController.text;

    if (idPetugas.isEmpty || password.isEmpty) {
      setState(() {
        pesanError = "ID Petugas dan Password harus diisi!";
      });
      return;
    }

    if (idPetugas == idPetugasBenar && password == passwordBenar) {
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
              // Branding header
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

              // Input ID Petugas
              TextField(
                controller: idPetugasController,
                decoration: const InputDecoration(
                  labelText: "ID Petugas",
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Input Password dengan toggle visibility
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

              // Error message (conditional render)
              if (pesanError.isNotEmpty)
                Text(
                  pesanError,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),

              // Submit button
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
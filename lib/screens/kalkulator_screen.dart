import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Halaman Kalkulator Logistik: estimasi kuantitas stok & muatan kontainer.
// + = stok masuk, - = stok keluar, x = kapasitas box, / = distribusi armada.

class KalkulatorScreen extends StatefulWidget {
  const KalkulatorScreen({super.key});

  @override
  State<KalkulatorScreen> createState() => _KalkulatorScreenState();
}

class _KalkulatorScreenState extends State<KalkulatorScreen> {
  final angkaAController = TextEditingController();
  final angkaBController = TextEditingController();

  // Variabel simpel (String) buat nyimpen operasi mana yang lagi dipilih.
  // Sesuai gaya beginner-friendly: tidak pakai enum.
  String operasiTerpilih = "+";

  // Teks hasil yang ditampilkan ke layar
  String hasilText = "";

  void pilihOperasi(String operasi) {
    setState(() {
      operasiTerpilih = operasi;
    });
  }

  void hitung() {
    // Validasi manual: cek kosong dulu sebelum diproses
    if (angkaAController.text.isEmpty || angkaBController.text.isEmpty) {
      setState(() {
        hasilText = "Isi kedua angka dulu!";
      });
      return;
    }

    // Ubah teks yang diketik jadi angka desimal (double)
    double angkaA = double.parse(angkaAController.text);
    double angkaB = double.parse(angkaBController.text);
    double hasil = 0;

    if (operasiTerpilih == "+") {
      hasil = angkaA + angkaB;
      setState(() {
        hasilText = "Stok masuk total: $hasil unit";
      });
    } else if (operasiTerpilih == "-") {
      hasil = angkaA - angkaB;
      setState(() {
        hasilText = "Sisa stok setelah keluar: $hasil unit";
      });
    } else if (operasiTerpilih == "x") {
      hasil = angkaA * angkaB;
      setState(() {
        hasilText = "Total kapasitas: $hasil unit";
      });
    } else if (operasiTerpilih == "/") {
      // Penanganan pembagian nol (syarat wajib di plan.md)
      if (angkaB == 0) {
        setState(() {
          hasilText = "Tidak bisa dibagi nol!";
        });
        return;
      }
      hasil = angkaA / angkaB;
      setState(() {
        hasilText = "Hasil distribusi: $hasil per unit tujuan";
      });
    }
  }

  // Widget kecil buat 1 tombol operasi, dipakai berulang di bawah.
  // (Ini bukan class terpisah, cuma function biasa yang mengembalikan Widget,
  // supaya tidak melanggar aturan "hindari custom StatelessWidget kecil".)
  Widget tombolOperasi(String operasi, String label) {
    bool sedangDipilih = operasiTerpilih == operasi;
    return ElevatedButton(
      onPressed: () => pilihOperasi(operasi),
      style: ElevatedButton.styleFrom(
        backgroundColor: sedangDipilih ? AppTheme.warnaUtama : Colors.grey[300],
        foregroundColor: sedangDipilih ? Colors.white : Colors.black87,
      ),
      child: Text(label, style: const TextStyle(fontSize: 20)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalkulator Logistik"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Angka A
            TextField(
              controller: angkaAController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Angka A (misal: stok awal)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Input Angka B
            TextField(
              controller: angkaBController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Angka B (misal: jumlah tambahan)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 4 tombol operasi berjejer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                tombolOperasi("+", "+"),
                tombolOperasi("-", "−"),
                tombolOperasi("x", "×"),
                tombolOperasi("/", "÷"),
              ],
            ),
            const SizedBox(height: 20),

            // Tombol Hitung
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: hitung,
                child: const Text("HITUNG"),
              ),
            ),
            const SizedBox(height: 24),

            // Hasil
            if (hasilText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: AppTheme.warnaUtama),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  hasilText,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
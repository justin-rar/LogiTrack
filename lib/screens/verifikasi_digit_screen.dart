import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Halaman Verifikasi Digit: checksum validation digit kode resi/barcode.
// Cara kerja: jumlahkan tiap digit dalam satu kode. Contoh: "123" -> 1+2+3=6

class VerifikasiDigitScreen extends StatefulWidget {
  const VerifikasiDigitScreen({super.key});

  @override
  State<VerifikasiDigitScreen> createState() => _VerifikasiDigitScreenState();
}

class _VerifikasiDigitScreenState extends State<VerifikasiDigitScreen> {
  final kodeBarcodeController = TextEditingController();

  String hasilText = "";
  String rincianText = "";

  void hitungChecksum() {
    String kode = kodeBarcodeController.text;

    // Validasi: cek kosong
    if (kode.isEmpty) {
      setState(() {
        hasilText = "Masukkan kode barcode dulu!";
        rincianText = "";
      });
      return;
    }

    int totalDigit = 0;
    String rincian = ""; // buat nampilin "4+5+9+1" ke layar

    // Loop untuk memisah tiap karakter dalam kode, lalu dijumlahkan
    for (int i = 0; i < kode.length; i++) {
      String karakter = kode[i];

      // Validasi: kalau ada karakter yang bukan angka (misal huruf), lewati
      // dan kasih tau user, jangan sampai aplikasi crash.
      if (int.tryParse(karakter) == null) {
        setState(() {
          hasilText = "Kode harus berupa angka saja!";
          rincianText = "";
        });
        return;
      }

      int angka = int.parse(karakter);
      totalDigit = totalDigit + angka;

      // Susun teks rincian, misal "4 + 5 + 9 + 1"
      if (i == 0) {
        rincian = "$angka";
      } else {
        rincian = "$rincian + $angka";
      }
    }

    setState(() {
      rincianText = "$rincian = $totalDigit";
      hasilText = "Checksum: $totalDigit";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifikasi Digit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Masukkan kode batch/nomor kontainer untuk verifikasi checksum (jumlah semua digit).",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: kodeBarcodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Kode Barcode (contoh: 4591)",
                prefixIcon: Icon(Icons.qr_code),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: hitungChecksum,
                child: const Text("VERIFIKASI"),
              ),
            ),
            const SizedBox(height: 24),

            if (hasilText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: AppTheme.warnaUtama),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    if (rincianText.isNotEmpty)
                      Text(
                        rincianText,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      hasilText,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
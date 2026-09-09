import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Kalkulator operasi logistik: stok masuk (+), stok keluar (−),
/// kapasitas box (×), dan distribusi armada (÷).
///
/// Mendukung input format Indonesia (titik ribuan, koma desimal)
/// dan format internasional (titik desimal).
class KalkulatorScreen extends StatefulWidget {
  const KalkulatorScreen({super.key});

  @override
  State<KalkulatorScreen> createState() => _KalkulatorScreenState();
}

class _KalkulatorScreenState extends State<KalkulatorScreen> {
  final angkaAController = TextEditingController();
  final angkaBController = TextEditingController();

  String operasiTerpilih = "+";
  String hasilText = "";

  void pilihOperasi(String operasi) {
    setState(() {
      operasiTerpilih = operasi;
    });
  }

  /// Normalisasi input angka agar kompatibel dengan [double.tryParse].
  ///
  /// Mendukung format:
  /// - ID: "1.500,75" → "1500.75" | "2,5" → "2.5"
  /// - EN: "3.14" → "3.14"
  /// - Ribuan: "1.000.000" → "1000000"
  String normalisasiAngka(String input) {
    String teks = input.trim();

    if (teks.contains(',')) {
      // Format ID: koma = desimal, titik = ribuan
      teks = teks.replaceAll('.', '');
      teks = teks.replaceAll(',', '.');
    } else {
      int jumlahTitik = '.'.allMatches(teks).length;

      if (jumlahTitik > 1) {
        // Multiple dots → thousands separator
        teks = teks.replaceAll('.', '');
      } else if (jumlahTitik == 1) {
        int posisiTitik = teks.indexOf('.');
        String setelahTitik = teks.substring(posisiTitik + 1);
        if (setelahTitik.length == 3 && posisiTitik > 0) {
          // Pattern "X.000" → kemungkinan ribuan
          teks = teks.replaceAll('.', '');
        }
      }
    }

    return teks;
  }

  /// Format angka ke notasi Indonesia (titik ribuan, koma desimal).
  ///
  /// Contoh: 1500000.5 → "1.500.000,5" | 250.0 → "250"
  String formatHasil(double angka) {
    bool isBulat = (angka == angka.roundToDouble()) && !angka.isInfinite && !angka.isNaN;

    String teks;
    if (isBulat) {
      teks = angka.toInt().toString();
    } else {
      teks = angka.toStringAsFixed(4);
      teks = teks.replaceAll(RegExp(r'0+$'), '');
      teks = teks.replaceAll(RegExp(r'\.$'), '');
    }

    // Split integer dan desimal
    String bagianInteger;
    String bagianDesimal = '';
    if (teks.contains('.')) {
      List<String> bagian = teks.split('.');
      bagianInteger = bagian[0];
      bagianDesimal = bagian[1];
    } else {
      bagianInteger = teks;
    }

    // Tambahkan pemisah ribuan pada bagian integer
    String hasilInteger = '';
    bool isNegatif = bagianInteger.startsWith('-');
    if (isNegatif) {
      bagianInteger = bagianInteger.substring(1);
    }
    int panjang = bagianInteger.length;
    for (int i = 0; i < panjang; i++) {
      hasilInteger = hasilInteger + bagianInteger[i];
      int sisaDigit = panjang - i - 1;
      if (sisaDigit > 0 && sisaDigit % 3 == 0) {
        hasilInteger = '$hasilInteger.';
      }
    }

    if (isNegatif) {
      hasilInteger = '-$hasilInteger';
    }

    if (bagianDesimal.isNotEmpty) {
      return '$hasilInteger,$bagianDesimal';
    } else {
      return hasilInteger;
    }
  }

  /// Eksekusi kalkulasi berdasarkan operasi yang dipilih.
  void hitung() {
    if (angkaAController.text.isEmpty || angkaBController.text.isEmpty) {
      setState(() {
        hasilText = "Isi kedua angka dulu!";
      });
      return;
    }

    String teksA = normalisasiAngka(angkaAController.text);
    String teksB = normalisasiAngka(angkaBController.text);

    double? angkaA = double.tryParse(teksA);
    double? angkaB = double.tryParse(teksB);

    if (angkaA == null || angkaB == null) {
      setState(() {
        hasilText = "Format angka tidak valid! Gunakan angka biasa, "
            "koma untuk desimal, atau titik untuk ribuan.";
      });
      return;
    }

    double hasil = 0;

    if (operasiTerpilih == "+") {
      hasil = angkaA + angkaB;
      setState(() {
        hasilText = "Stok masuk total: ${formatHasil(hasil)} unit";
      });
    } else if (operasiTerpilih == "-") {
      hasil = angkaA - angkaB;
      setState(() {
        hasilText = "Sisa stok setelah keluar: ${formatHasil(hasil)} unit";
      });
    } else if (operasiTerpilih == "x") {
      hasil = angkaA * angkaB;
      setState(() {
        hasilText = "Total kapasitas: ${formatHasil(hasil)} unit";
      });
    } else if (operasiTerpilih == "/") {
      if (angkaB == 0) {
        setState(() {
          hasilText = "Tidak bisa dibagi nol!";
        });
        return;
      }
      hasil = angkaA / angkaB;
      setState(() {
        hasilText = "Hasil distribusi: ${formatHasil(hasil)} per unit tujuan";
      });
    }
  }

  /// Tombol operasi dengan highlight state aktif.
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
            // Input A
            TextField(
              controller: angkaAController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Angka A (misal: stok awal)",
                hintText: "Contoh: 1.500.000 atau 2,5",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Input B
            TextField(
              controller: angkaBController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Angka B (misal: jumlah tambahan)",
                hintText: "Contoh: 750.000 atau 3,14",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Operator selector
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

            // Submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: hitung,
                child: const Text("HITUNG"),
              ),
            ),
            const SizedBox(height: 24),

            // Output container
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
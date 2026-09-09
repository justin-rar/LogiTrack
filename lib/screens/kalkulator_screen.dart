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

  // Helper: normalisasi input angka user supaya bisa di-parse.
  // Mendukung format Indonesia (koma = desimal, titik = ribuan)
  // dan juga format internasional (titik = desimal).
  //
  // Contoh input yang didukung:
  //   "1.000.000"    -> "1000000"       (titik sebagai pemisah ribuan)
  //   "1.500,75"     -> "1500.75"       (titik ribuan + koma desimal)
  //   "2,5"          -> "2.5"           (koma sebagai desimal)
  //   "1000000"      -> "1000000"       (angka polos jutaan)
  //   "3.14"         -> "3.14"          (titik sebagai desimal, format internasional)
  String normalisasiAngka(String input) {
    String teks = input.trim();

    // Kalau ada koma, berarti user pakai format Indonesia:
    // koma = desimal, titik = pemisah ribuan
    if (teks.contains(',')) {
      teks = teks.replaceAll('.', ''); // hapus titik ribuan
      teks = teks.replaceAll(',', '.'); // ganti koma jadi titik desimal
    } else {
      // Tidak ada koma. Cek apakah titik dipakai sebagai pemisah ribuan
      // atau sebagai desimal. Caranya: kalau ada lebih dari 1 titik,
      // pasti itu pemisah ribuan (contoh: "1.000.000").
      // Kalau cuma 1 titik dan posisinya bukan 3 digit dari belakang,
      // itu desimal (contoh: "3.14"). Kalau posisinya pas 3 digit dari
      // belakang, kita anggap ribuan (contoh: "1.000" = seribu).
      int jumlahTitik = '.'.allMatches(teks).length;

      if (jumlahTitik > 1) {
        // Lebih dari 1 titik -> pasti pemisah ribuan, hapus semua
        teks = teks.replaceAll('.', '');
      } else if (jumlahTitik == 1) {
        // 1 titik saja. Cek posisi: kalau tepat 3 digit setelah titik
        // dan total digit > 3, kemungkinan besar itu pemisah ribuan.
        int posisiTitik = teks.indexOf('.');
        String setelahTitik = teks.substring(posisiTitik + 1);
        if (setelahTitik.length == 3 && posisiTitik > 0) {
          // Kemungkinan ribuan (misal "1.000"), hapus titik
          teks = teks.replaceAll('.', '');
        }
        // Selain itu, biarkan titik sebagai desimal (misal "3.14")
      }
    }

    return teks;
  }

  // Helper: format angka hasil supaya mudah dibaca.
  // Tampilkan dengan pemisah ribuan (titik) dan desimal (koma) gaya Indonesia.
  // Contoh: 1500000.5 -> "1.500.000,5"
  //         250.0     -> "250"  (hilangkan ,0 yang tidak perlu)
  String formatHasil(double angka) {
    // Cek apakah hasilnya bilangan bulat (tidak ada bagian desimal)
    bool isBulat = (angka == angka.roundToDouble()) && !angka.isInfinite && !angka.isNaN;

    String teks;
    if (isBulat) {
      // Tampilkan tanpa desimal: 1500000 bukan 1500000.0
      teks = angka.toInt().toString();
    } else {
      // Tampilkan dengan desimal, maksimal 4 angka di belakang koma
      // lalu hapus nol trailing yang tidak perlu
      teks = angka.toStringAsFixed(4);
      // Hapus trailing zeros: "1.5000" -> "1.5"
      teks = teks.replaceAll(RegExp(r'0+$'), '');
      // Hapus trailing dot kalau desimalnya habis: "1." -> "1"
      teks = teks.replaceAll(RegExp(r'\.$'), '');
    }

    // Pisahkan bagian integer dan desimal
    String bagianInteger;
    String bagianDesimal = '';
    if (teks.contains('.')) {
      List<String> bagian = teks.split('.');
      bagianInteger = bagian[0];
      bagianDesimal = bagian[1];
    } else {
      bagianInteger = teks;
    }

    // Tambahkan titik sebagai pemisah ribuan pada bagian integer
    // Contoh: "1500000" -> "1.500.000"
    String hasilInteger = '';
    bool isNegatif = bagianInteger.startsWith('-');
    if (isNegatif) {
      bagianInteger = bagianInteger.substring(1); // hilangkan tanda minus sementara
    }
    int panjang = bagianInteger.length;
    for (int i = 0; i < panjang; i++) {
      hasilInteger = hasilInteger + bagianInteger[i];
      int sisaDigit = panjang - i - 1;
      // Tambah titik setiap 3 digit dari belakang (kecuali di akhir)
      if (sisaDigit > 0 && sisaDigit % 3 == 0) {
        hasilInteger = '$hasilInteger.';
      }
    }

    if (isNegatif) {
      hasilInteger = '-$hasilInteger';
    }

    // Gabungkan kembali. Pakai koma untuk desimal (gaya Indonesia).
    if (bagianDesimal.isNotEmpty) {
      return '$hasilInteger,$bagianDesimal';
    } else {
      return hasilInteger;
    }
  }

  void hitung() {
    // Validasi manual: cek kosong dulu sebelum diproses
    if (angkaAController.text.isEmpty || angkaBController.text.isEmpty) {
      setState(() {
        hasilText = "Isi kedua angka dulu!";
      });
      return;
    }

    // Normalisasi input supaya bisa di-parse (dukung koma, titik ribuan, dll.)
    String teksA = normalisasiAngka(angkaAController.text);
    String teksB = normalisasiAngka(angkaBController.text);

    // Pakai tryParse supaya tidak crash kalau input aneh
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
      // Penanganan pembagian nol (syarat wajib di plan.md)
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
            // Input Angka A — keyboard desimal supaya ada tombol koma/titik
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

            // Input Angka B
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
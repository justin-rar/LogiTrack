import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Halaman Sortir Zonasi: alokasi jalur rak berdasarkan nomor lot/batch.
// Genap -> Zona A / Rak Genap (Fast-Moving)
// Ganjil -> Zona B / Rak Ganjil (Slow-Moving)

class SortirZonasiScreen extends StatefulWidget {
  const SortirZonasiScreen({super.key});

  @override
  State<SortirZonasiScreen> createState() => _SortirZonasiScreenState();
}

class _SortirZonasiScreenState extends State<SortirZonasiScreen> {
  final nomorLotController = TextEditingController();

  // Nilai-nilai ini yang dipakai buat nampilin badge hasil
  bool sudahDicek = false;
  bool hasilGenap = false;
  String nomorLotDicek = "";

  void cekZonasi() {
    if (nomorLotController.text.isEmpty) {
      setState(() {
        sudahDicek = false;
      });
      return;
    }

    // Normalisasi: hapus titik dan koma yang dipakai sebagai pemisah ribuan
    // Contoh: "1.000.000" -> "1000000", "1,000,000" -> "1000000"
    String teksNormalisasi = nomorLotController.text.trim();
    teksNormalisasi = teksNormalisasi.replaceAll('.', '');
    teksNormalisasi = teksNormalisasi.replaceAll(',', '');

    // Pakai tryParse supaya tidak crash kalau input bukan angka
    int? nomorLot = int.tryParse(teksNormalisasi);

    if (nomorLot == null) {
      setState(() {
        sudahDicek = false;
      });
      // Tampilkan pesan error via SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nomor lot harus berupa angka!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      sudahDicek = true;
      nomorLotDicek = nomorLotController.text;
      // % artinya sisa bagi. Kalau sisa bagi 2 == 0, berarti genap.
      hasilGenap = (nomorLot % 2 == 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sortir Zonasi Rak"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Masukkan nomor lot/batch barang untuk menentukan zona rak penyimpanan.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: nomorLotController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Nomor Lot/Batch",
                prefixIcon: Icon(Icons.numbers),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cekZonasi,
                child: const Text("CEK ZONASI"),
              ),
            ),
            const SizedBox(height: 32),

            // Badge hasil, cuma muncul kalau sudah pernah dicek
            if (sudahDicek)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // Genap = warna aksen (amber/orange), Ganjil = slate biru tua
                  color: hasilGenap ? AppTheme.warnaAksen : AppTheme.warnaUtama,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      hasilGenap ? Icons.bolt : Icons.inventory_2,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Lot #$nomorLotDicek",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasilGenap
                          ? "GENAP -> Zona A (Fast-Moving)"
                          : "GANJIL -> Zona B (Slow-Moving)",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
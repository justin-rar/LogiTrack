import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Sortir zonasi rak gudang berdasarkan nomor lot/batch.
///
/// Aturan alokasi:
/// - Genap → Zona A / Fast-Moving
/// - Ganjil → Zona B / Slow-Moving
class SortirZonasiScreen extends StatefulWidget {
  const SortirZonasiScreen({super.key});

  @override
  State<SortirZonasiScreen> createState() => _SortirZonasiScreenState();
}

class _SortirZonasiScreenState extends State<SortirZonasiScreen> {
  final nomorLotController = TextEditingController();

  bool sudahDicek = false;
  bool hasilGenap = false;
  String nomorLotDicek = "";

  /// Validasi dan tentukan zonasi berdasarkan parity nomor lot.
  /// Input dinormalisasi untuk mendukung separator ribuan (titik/koma).
  void cekZonasi() {
    if (nomorLotController.text.isEmpty) {
      setState(() {
        sudahDicek = false;
      });
      return;
    }

    // Strip thousands separators
    String teksNormalisasi = nomorLotController.text.trim();
    teksNormalisasi = teksNormalisasi.replaceAll('.', '');
    teksNormalisasi = teksNormalisasi.replaceAll(',', '');

    int? nomorLot = int.tryParse(teksNormalisasi);

    if (nomorLot == null) {
      setState(() {
        sudahDicek = false;
      });
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

            // Zona badge — ditampilkan setelah pengecekan
            if (sudahDicek)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
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
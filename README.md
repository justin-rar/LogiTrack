# LogiTrack - Warehouse & Logistics Utility App
Tugas 2 Pemrograman Aplikasi Mobile (PAM)

LogiTrack adalah aplikasi utilitas mobilitas bagi staf dan supervisor gudang untuk mempermudah operasional harian di lapangan (kalkulasi muatan, sortir rak ganjil/genap, dan verifikasi digit resi/barcode).

## Fitur Utama
1. **Login Staf Gudang** - Autentikasi lokal staf gudang.
2. **Profil Tim** - Informasi anggota kelompok pengembang.
3. **Kalkulator Logistik** - Operasi hitung stok & muatan (+, -, ×, ÷) dengan penanganan error pembagian nol.
4. **Sortir Zonasi Rak** - Alokasi rak berdasarkan nomor lot ganjil (Rak B - Slow Moving) dan genap (Rak A - Fast Moving).
5. **Verifikasi Digit Barcode** - Validasi checksum dengan kalkulasi total digit kode resi/barcode.

## Teknologi
- **Framework:** Flutter (Dart)
- **Platform Target:** Android / iOS / Web / Desktop

## Memulai (Getting Started)

1. Pastikan Flutter SDK telah terinstal di perangkat Anda.
2. Unduh dependensi proyek:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi:
   ```bash
   flutter run
   ```

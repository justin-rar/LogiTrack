# Project Plan: LogiTrack Mobile App

**Tema:** Warehouse & Logistics Utility App
**Platform:** Flutter (Dart)
**Target:** Tugas Kelompok & Presentasi

---

## 1. Deskripsi & Latar Belakang

LogiTrack dirancang sebagai aplikasi utilitas bagi staf dan supervisor gudang untuk mempermudah operasional harian di lapangan. Aplikasi ini mengontekstualisasikan operasi matematika dasar ke dalam skenario nyata pengelolaan barang, alokasi rak muatan, dan verifikasi nomor kode seri (*barcode checksum*).

---

## 2. Struktur Fitur & Kontekstualisasi

| Menu / Modul | Syarat Tugas | Konteks Logistik | Input & Logika |
| --- | --- | --- | --- |
| **Login** | Username & Password | Autentikasi Staf Gudang (hardcoded, lihat catatan §6) | Input ID Petugas & PIN akses |
| **Profil Tim** | Data Kelompok | Identitas Shift Pengembang / Supervisor | List nama, NIM, dan role anggota |
| **Kalkulator Logistik** | +, -, ×, ÷ | Estimasi kuantitas stok & muatan kontainer | Hitung stok masuk (+), keluar (-), total karton (×), alokasi armada (÷), dengan penanganan pembagian nol |
| **Sortir Zonasi** | Input bilangan ganjil/genap | Alokasi jalur rak berdasarkan nomor lot/batch | Genap → Rak A (Fast-Moving), Ganjil → Rak B (Slow-Moving) |
| **Verifikasi Digit** | Jumlah total angka dalam satu field | Checksum validation digit kode resi/barcode | Penjumlahan otomatis setiap digit pada string barcode (cth: `123` → 1+2+3=6) |

---

## 3. Pembagian Peran Tim (3-4 Orang)

- **Anggota 1 (Lead Developer / Navigation Specialist):**
  - Setup struktur proyek Flutter & color theme logistik (Teal/Orange/Slate)
  - Implementasi halaman Login & Dashboard Navigasi Utama
  - Konfigurasi rute antarhalaman

- **Anggota 2 (Core Logic 1):**
  - Implementasi modul Data Kelompok (UI Card / List informatif)
  - Implementasi modul Kalkulator Logistik (+, -, ×, ÷ beserta penanganan error pembagian nol)

- **Anggota 3 (Core Logic 2):**
  - Implementasi modul Sortir Zonasi Rak (Ganjil/Genap) lengkap dengan visual badge status
  - Implementasi modul Verifikasi Digit Barcode (Total Angka) beserta perincian hitungannya

- **Anggota 4 (UI/UX & Presentasi):**
  - Styling form input, ikon pergudangan, pesan peringatan (SnackBar/dialog)
  - Penyusunan materi slide presentasi, naskah demo, koordinasi upload SPADA
  - **Catatan: jika kelompok hanya 3 orang, tugas ini dibagi rata ke Anggota 1-3, bukan dihilangkan.**

---

## 4. Struktur Direktori Proyek

```text
lib/
├── main.dart
├── theme/
│   └── app_theme.dart
└── screens/
    ├── login_screen.dart
    ├── dashboard_screen.dart
    ├── data_kelompok_screen.dart
    ├── kalkulator_screen.dart
    ├── sortir_zonasi_screen.dart
    └── verifikasi_digit_screen.dart
```

Struktur folder modular sederhana — cukup untuk skala tugas ini, tidak perlu layer domain/data terpisah.

---

## 5. Standar Gaya Kode: Beginner-Friendly

Karena ini mata kuliah baru dan tim masih tahap awal belajar Flutter/Dart, seluruh kode ditulis dengan gaya yang **paling mudah dipahami dan dijelaskan ulang**, bukan gaya "paling ringkas" atau "paling rapi secara arsitektur". Aturan yang disepakati:

- **Gunakan `if-else` biasa**, hindari `enum`, `switch` kompleks, atau class helper tambahan (misal class kecil untuk menyimpan info tombol) — cukup variabel `String` atau `int` sederhana untuk menyimpan pilihan (contoh: `operasiTerpilih = "+"`)
- **Widget bawaan Flutter yang umum saja**: `TextField`, `ElevatedButton`, `Text`, `Column`, `Row`, `Container`. Hindari widget yang lebih niche seperti `ChoiceChip`, `Wrap`, atau custom `StatelessWidget` terpisah untuk item kecil (seperti kartu menu) — cukup ditulis langsung di `build()`
- **Satu file = satu tanggung jawab jelas**, tanpa membagi lagi jadi banyak class kecil di dalam satu file
- **Nama variabel dan fungsi dalam Bahasa Indonesia atau campuran yang mudah dibaca** (contoh: `hitung()`, `angkaAController`, `hasilText`) supaya gampang dijelaskan ke dosen tanpa istilah teknis berlebih
- **Validasi input pakai `if` sederhana** (cek kosong, cek pembagian nol) — tidak perlu `Form` + `GlobalKey` + `validator` kalau anggota belum familiar dengan konsep itu; cukup validasi manual sebelum proses hitung
- Setiap anggota disarankan **mengerti isi kode modul masing-masing luar-dalam**, karena sesi tanya-jawab presentasi akan menyasar ke pemahaman logika, bukan sekadar hasil jadi

Tujuannya: kalau dosen bertanya "kenapa pakai baris ini", setiap anggota bisa jawab tanpa bingung — bukan sekadar tempel kode dari referensi yang tidak dipahami.

---

## 6. Login: Hardcoded (Tanpa Backend)

Login menggunakan **kredensial hardcoded langsung di dalam kode**, contoh:
```dart
if (username == "admin" && password == "gudang123") { ... }
```

**Keputusan final: tidak menggunakan Supabase atau backend apa pun.** Alasan:
- Tidak ada fitur di tugas ini yang benar-benar butuh data tersimpan di server — semua modul (login, kalkulator, ganjil/genap, verifikasi digit) cukup berjalan dengan data sementara selama aplikasi aktif
- Supabase menambah kompleksitas (async/await, API call, package eksternal, setup environment) yang belum sesuai level tim yang baru belajar Flutter dasar — bertentangan dengan prinsip §5 (Beginner-Friendly)
- Menghindari risiko demo gagal saat presentasi karena masalah koneksi internet atau konfigurasi backend
- Tidak ada nilai tambah di rubrik tugas untuk penggunaan backend — effort lebih baik dialihkan ke pemahaman tim atas kode sendiri

---

## 7. Keputusan: Interpretasi "Jumlah Total Angka dalam Field"

Modul Verifikasi Digit menggunakan interpretasi **jumlah semua digit dalam satu angka/kode** (checksum, misal `123` → `1+2+3=6`), BUKAN jumlah dari beberapa angka terpisah yang diinput user.

Alasan pemilihan:
- Konsep ini klasik dan umum diajarkan di pengantar pemrograman (cocok untuk mata kuliah baru/pemula)
- Implementasinya lebih sederhana — cukup satu field input, uraikan per karakter, jumlahkan
- Menghindari tumpang tindih dengan menu Kalkulator Logistik yang sudah menangani penjumlahan antar-angka

---

## 8. Jadwal Kerja (Timeline Pengerjaan)

- **Hari 1:** Setup project, tema warna, struktur navigasi, halaman Login — Anggota 1. Begitu skeleton navigasi siap, Anggota 2 & 3 langsung mulai modul masing-masing (paralel, tidak menunggu hari 2).
- **Hari 2:** Lanjutan implementasi 4 modul logika (Kalkulator, Sortir Zonasi, Verifikasi Digit, Data Kelompok).
- **Hari 3:** Integrasi semua modul ke dashboard, testing bersama (input kosong, pembagian nol, validasi angka), Anggota 4 mulai styling & susun slide.
- **Hari 4:** Finalisasi, revisi minor, upload individu ke SPADA oleh masing-masing anggota, gladi presentasi.

---

## 9. Alur Presentasi Kelompok

1. **Pembuka:** Perkenalan anggota dan penjelasan latar belakang masalah staf logistik di gudang.
2. **Demo Aplikasi:**
   - Login petugas → Menampilkan profil tim pengembang.
   - Simulasi penghitungan muatan dus dan distribusi truk.
   - Simulasi sortir rak barang berdasarkan kode lot ganjil/genap.
   - Simulasi verifikasi nomor resi menggunakan modul jumlah total digit.
3. **Tanya Jawab & Penutup:** Penjelasan singkat struktur kode dan penutup.

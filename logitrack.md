# 📦 LogiTrack — Sistem Manajemen Logistik Gudang

> Aplikasi mobile berbasis Flutter untuk operasional logistik gudang, mencakup penghitungan stok, zonasi rak, dan verifikasi barcode.

---

## 📋 Informasi Umum

| Item              | Detail                                        |
| ----------------- | --------------------------------------------- |
| **Nama Aplikasi** | LogiTrack                                     |
| **Platform**      | Mobile (Android, iOS, Web, Desktop)           |
| **Framework**     | Flutter (Dart)                                |
| **SDK**           | Dart ^3.12.2                                  |
| **Versi**         | 1.0.0                                         |
| **Arsitektur**    | Single-module, Screen-based                   |
| **Mata Kuliah**   | Teori Pemrograman Aplikasi Mobile (Semester 5)|

---

## 👥 Anggota Kelompok

| No | Nama                       | NIM        | Peran        |
| -- | -------------------------- | ---------- | ------------ |
| 1  | Justin Muhammad Rasyid     | 124240074  | Lead Dev     |
| 2  | Kanza Widi Bagaskara       | 124240059  | Core Logic 1 |
| 3  | Daniel Roby Maldini        | 124240044  | Core Logic 2 |
| 4  | Ahmad Iqbal Kholid         | 124240029  | UI/UX        |

---

## 🏗️ Struktur Proyek

```
lib/
├── main.dart                          # Entry point aplikasi
├── theme/
│   └── app_theme.dart                 # Tema warna & styling global
└── screens/
    ├── login_screen.dart              # Halaman login staf gudang
    ├── dashboard_screen.dart          # Menu utama (Grid Card)
    ├── data_kelompok_screen.dart      # Info anggota kelompok
    ├── kalkulator_screen.dart         # Kalkulator logistik (+−×÷)
    ├── sortir_zonasi_screen.dart      # Sortir zona rak (ganjil/genap)
    └── verifikasi_digit_screen.dart   # Checksum digit barcode
```

---

## 🎨 Tema & Desain

Aplikasi menggunakan tema konsisten bertema **industri/gudang logistik**:

| Elemen            | Warna                            | Kode Hex    |
| ----------------- | -------------------------------- | ----------- |
| Warna Utama       | Slate Blue (biru tua)            | `#1E3A5F`   |
| Warna Utama Gelap | Slate Blue gelap (AppBar)        | `#0F2A44`   |
| Warna Aksen       | Amber/Orange (khas industri)     | `#FFA726`   |
| Background        | Abu sangat terang                | `#F5F5F5`   |
| Teks Gelap        | Hitam pekat                      | `#212121`   |
| Teks Terang       | Putih                            | `#FFFFFF`   |

> Semua warna didefinisikan **terpusat** di `app_theme.dart` sehingga mudah diganti tanpa menyentuh file screen.

---

## 🔐 Fitur 1: Halaman Login

**File:** `login_screen.dart` — **StatefulWidget**

### Deskripsi
Halaman pertama yang tampil saat aplikasi dibuka. Staf gudang harus memasukkan ID Petugas dan Password untuk mengakses dashboard.

### Detail Fitur
- Input **ID Petugas** dan **Password** dengan `TextField`
- Tombol **show/hide password** (toggle visibilitas)
- Kredensial **hardcoded** (tanpa backend):
  - ID: `LOG001`
  - Password: `gudang2024`
- Validasi:
  - Cek apakah field kosong → tampilkan pesan error
  - Cek apakah kredensial cocok → jika salah, tampilkan pesan error
- Navigasi: `pushReplacement` ke Dashboard (agar tidak bisa kembali ke login dengan tombol back)

### Konsep Pemrograman
- `TextEditingController` — menangkap input user
- `setState()` — memperbarui UI saat ada perubahan state
- `Navigator.pushReplacement` — navigasi tanpa bisa kembali
- Percabangan `if-else` — validasi input

---

## 🏠 Fitur 2: Dashboard

**File:** `dashboard_screen.dart` — **StatelessWidget**

### Deskripsi
Menu utama berupa **Grid Card** yang menampilkan 4 pilihan layanan operasional logistik.

### Detail Fitur
- **Banner selamat datang** dengan ikon warehouse dan teks sambutan
- **4 menu** dalam Grid 2×2:
  1. 📊 Data Kelompok — Tim Pengembang
  2. 🔢 Kalkulator Logistik — Hitung Stok & Muatan
  3. 📦 Sortir Zonasi Rak — Cek Lot Ganjil/Genap
  4. 📱 Verifikasi Digit — Checksum Barcode
- Tombol **Logout** di AppBar (kembali ke halaman login)
- Setiap card memiliki **ikon**, **judul**, dan **subtitle** deskriptif

### Konsep Pemrograman
- `GridView.count` — layout grid responsif
- `Navigator.push` — navigasi ke halaman fitur
- `Navigator.pushAndRemoveUntil` — logout (hapus semua riwayat navigasi)
- Widget reusable: `_buildMenuCard()` helper function

---

## 👤 Fitur 3: Data Kelompok

**File:** `data_kelompok_screen.dart` — **StatelessWidget**

### Deskripsi
Menampilkan informasi identitas seluruh anggota tim pengembang dalam bentuk daftar kartu.

### Detail Fitur
- **ListView** berisi 4 `Card` + `ListTile`
- Setiap kartu menampilkan:
  - Nomor urut (dalam `CircleAvatar`)
  - Nama lengkap
  - NIM
  - Peran dalam tim (Lead Dev, Core Logic, UI/UX)

### Konsep Pemrograman
- `ListView` — scrollable list
- `Card` + `ListTile` — Material Design card pattern
- `CircleAvatar` — ikon lingkaran beridentitas

---

## 🔢 Fitur 4: Kalkulator Logistik

**File:** `kalkulator_screen.dart` — **StatefulWidget**

### Deskripsi
Kalkulator 4 operasi dasar (+, −, ×, ÷) yang dirancang untuk konteks logistik gudang: penghitungan stok masuk, stok keluar, kapasitas box, dan distribusi armada.

### Detail Fitur
- **2 input angka** (Angka A dan Angka B)
- **4 tombol operasi** yang bisa dipilih (highlight saat aktif):
  - `+` → Stok masuk total
  - `−` → Sisa stok setelah keluar
  - `×` → Total kapasitas
  - `÷` → Hasil distribusi per unit tujuan
- **Mendukung angka desimal dan jutaan:**
  - Format Indonesia: koma sebagai desimal (`2,5`), titik sebagai ribuan (`1.500.000`)
  - Format internasional: titik sebagai desimal (`3.14`)
  - Angka besar tanpa separator: `1000000`
- **Output diformat rapi** gaya Indonesia:
  - Pemisah ribuan: titik (`1.500.000`)
  - Pemisah desimal: koma (`2,5`)
  - Trailing zero dihilangkan (`250` bukan `250,0`)
- **Penanganan error:**
  - Field kosong → "Isi kedua angka dulu!"
  - Format tidak valid → pesan error deskriptif
  - Pembagian nol → "Tidak bisa dibagi nol!"

### Konsep Pemrograman
- `double.tryParse()` — parsing angka yang aman (tidak crash)
- `TextInputType.numberWithOptions(decimal: true)` — keyboard angka dengan tombol desimal
- String manipulation: `replaceAll()`, `contains()`, `split()`, `substring()`
- `RegExp` — regular expression untuk formatting output
- Percabangan `if-else` bertingkat — logika normalisasi angka
- Perulangan `for` — pemisah ribuan pada output
- Helper functions: `normalisasiAngka()`, `formatHasil()`

---

## 📦 Fitur 5: Sortir Zonasi Rak

**File:** `sortir_zonasi_screen.dart` — **StatefulWidget**

### Deskripsi
Menentukan zona penyimpanan rak berdasarkan nomor lot/batch barang. Lot **genap** masuk Zona A (Fast-Moving), lot **ganjil** masuk Zona B (Slow-Moving).

### Detail Fitur
- **Input nomor lot** dengan TextField
- **Mendukung angka besar** dengan pemisah ribuan (titik/koma dihapus otomatis)
- **Badge hasil berwarna:**
  - 🟠 **Genap → Zona A (Fast-Moving)** — warna amber/orange + ikon bolt
  - 🔵 **Ganjil → Zona B (Slow-Moving)** — warna slate blue + ikon inventory
- **Penanganan error:**
  - Input kosong → badge tidak muncul
  - Input bukan angka → SnackBar pesan error merah

### Konsep Pemrograman
- Operator modulus (`%`) — menentukan ganjil/genap
- `int.tryParse()` — parsing integer yang aman
- `ScaffoldMessenger.showSnackBar()` — notifikasi error
- Conditional rendering (`if` di dalam widget tree)
- String manipulation: `replaceAll()` untuk normalisasi input

---

## 📱 Fitur 6: Verifikasi Digit (Checksum)

**File:** `verifikasi_digit_screen.dart` — **StatefulWidget**

### Deskripsi
Menghitung checksum (jumlah semua digit) dari kode batch/nomor kontainer untuk keperluan verifikasi barcode.

### Detail Fitur
- **Input kode barcode** (misal: `4591`)
- **Menghitung jumlah tiap digit:** `4 + 5 + 9 + 1 = 19`
- **Menampilkan rincian perhitungan** dan hasil total
- **Validasi:**
  - Kode kosong → "Masukkan kode barcode dulu!"
  - Karakter non-angka → "Kode harus berupa angka saja!"

### Konsep Pemrograman
- Perulangan `for` — iterasi per karakter string
- `int.tryParse()` — validasi per digit
- Indexing string (`kode[i]`) — akses karakter per posisi
- Akumulasi dalam loop — penjumlahan bertahap
- String concatenation — membangun teks rincian `"4 + 5 + 9 + 1"`

---

## 🧠 Ringkasan Konsep Pemrograman yang Digunakan

| Konsep                        | Digunakan Di                           |
| ----------------------------- | -------------------------------------- |
| **StatefulWidget / setState** | Login, Kalkulator, Sortir, Verifikasi  |
| **StatelessWidget**           | Dashboard, Data Kelompok               |
| **TextEditingController**     | Login, Kalkulator, Sortir, Verifikasi  |
| **Navigator (push/replace)**  | Login ↔ Dashboard ↔ Semua fitur        |
| **Percabangan (if-else)**     | Login, Kalkulator, Sortir, Verifikasi  |
| **Perulangan (for)**          | Kalkulator (formatting), Verifikasi    |
| **Operator Aritmatika**       | Kalkulator (+, −, ×, ÷)               |
| **Operator Modulus (%)**      | Sortir Zonasi (ganjil/genap)           |
| **tryParse (error handling)** | Kalkulator, Sortir, Verifikasi         |
| **String Manipulation**       | Kalkulator (normalisasi & formatting)  |
| **Regular Expression**        | Kalkulator (trailing zero removal)     |
| **GridView**                  | Dashboard (menu 2×2)                   |
| **ListView**                  | Data Kelompok                          |
| **Conditional Widget**        | Semua screen (if di widget tree)       |
| **Material Design Widgets**   | Card, ListTile, ElevatedButton, dll.   |
| **Global Theme**              | app_theme.dart → dipakai semua screen  |
| **SnackBar**                  | Sortir Zonasi (error notification)     |

---

## 🔄 Alur Navigasi Aplikasi

```
Login Screen
    │
    ▼ (kredensial benar)
Dashboard Screen
    │
    ├── Data Kelompok
    ├── Kalkulator Logistik
    ├── Sortir Zonasi Rak
    ├── Verifikasi Digit
    │
    └── Logout → kembali ke Login
```

---

## 📦 Dependency

| Package          | Versi    | Kegunaan                        |
| ---------------- | -------- | ------------------------------- |
| `flutter`        | SDK      | Framework utama                 |
| `cupertino_icons` | ^1.0.8  | Ikon gaya iOS                   |
| `flutter_lints`  | ^6.0.0   | Linting & best practices (dev)  |

> Aplikasi ini **tidak menggunakan package/library eksternal tambahan** di luar bawaan Flutter. Semua logika ditulis manual (native Dart).

---

## ✅ Keunggulan Aplikasi

1. **Tanpa library tambahan** — Semua logika ditulis dari nol menggunakan Dart murni
2. **Tema terpusat** — Konsistensi visual dijaga lewat `app_theme.dart`
3. **Error handling lengkap** — Tidak ada kemungkinan crash dari input user
4. **Mendukung format angka Indonesia** — Koma desimal, titik ribuan, angka jutaan
5. **UI intuitif** — Navigasi sederhana dengan grid menu dan hasil langsung terlihat
6. **Kode beginner-friendly** — Komentar lengkap di setiap file, cocok untuk pembelajaran

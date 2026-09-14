# Product Requirement Document (PRD)
## FitCalculate — Aplikasi Kesehatan & Kebugaran Berbasis Flutter

| Atribut | Keterangan |
|---|---|
| Nama Produk | FitCalculate (pengembangan lanjutan dari CalculateDD) |
| Platform | Mobile (Android/iOS) — Flutter Framework |
| Backend | Google Firebase (Cloud Firestore) |
| Mata Kuliah | Pemrograman Aplikasi Mobile |
| Versi Dokumen | 1.0 |
| Tanggal | 14 September 2026 |
| Status | Final Draft — Siap Implementasi |

### Anggota Kelompok

| No | Nama | NIM |
|---|---|---|
| 1 | Aditya Fadilah R.A | 124240062 |
| 2 | Akbar Maulana Setiawan | 124240079 |
| 3 | Azhicry Vernando E.P | 124240069 |
| 4 | Damar Nugroho | 124240073 |

---

## 1. Problem Statement

Dalam kehidupan mahasiswa dan masyarakat umum, pengelolaan gaya hidup sehat sering kali terhambat oleh tiga persoalan utama:

1. **Fragmentasi alat bantu kebugaran.** Pengguna umumnya harus berpindah-pindah aplikasi untuk mencatat jadwal olahraga (workout planner), menghitung kebutuhan fisik dasar seperti Body Mass Index (BMI) dan Basal Metabolic Rate (BMR), serta melacak progres latihan menggunakan stopwatch. Tidak adanya platform terpadu menyebabkan proses pencatatan menjadi tidak efisien dan rawan terlewat.
2. **Minimnya alat hitung kebutuhan fisik yang edukatif dan kontekstual.** Banyak pengguna awam belum memahami cara menghitung kebutuhan kalori harian atau indeks massa tubuh secara mandiri, sehingga sulit menyusun target latihan yang realistis dan terukur.
3. **Keterbatasan integrasi sistem penanggalan budaya lokal dalam aplikasi kesehatan.** Sebagai aplikasi yang dikembangkan dalam konteks Indonesia, terdapat kebutuhan untuk menghubungkan aspek kebugaran fisik dengan kesadaran temporal budaya, seperti kalender Hijriah untuk keperluan ibadah, Weton Jawa (lengkap dengan Neptu) untuk tradisi Jawa, dan Kalender Saka Bali untuk tradisi Bali. Ketiga sistem penanggalan ini jarang ditemukan terintegrasi dalam satu aplikasi mobile, terlebih dalam aplikasi bertema kebugaran.

Berdasarkan permasalahan tersebut, dibutuhkan sebuah aplikasi mobile yang mengintegrasikan **manajemen jadwal workout berbasis cloud (realtime)**, **kalkulator kebutuhan fisik (BMI/BMR)**, **stopwatch latihan**, serta **konversi kalender multi-sistem (Hijriah, Jawa, Bali)** dalam satu ekosistem aplikasi yang ringan, mudah digunakan, dan dapat diakses kapan saja.

---

## 2. Goals

### 2.1 Sasaran Fungsional
- Menyediakan sistem autentikasi sederhana berbasis sesi lokal (`shared_preferences`) sebagai gerbang akses (gatekeeper) ke aplikasi.
- Menyediakan modul CRUD (Create, Read, Update, Delete) jadwal workout yang tersinkronisasi secara **realtime** menggunakan Cloud Firestore melalui `StreamBuilder`.
- Menyediakan kalkulator kebugaran (BMI dan BMR/kebutuhan kalori harian) dengan input antropometrik pengguna.
- Menyediakan konversi kalender Hijriah serta kalkulator umur detail (tahun, bulan, hari, jam, menit, detik).
- Menyediakan konversi kalender budaya Nusantara: Weton Jawa (dengan Neptu) dan Kalender Saka Bali.
- Menyediakan fitur stopwatch sebagai alat bantu pencatatan waktu latihan langsung dari tab navigasi utama.

### 2.2 Sasaran Edukasi
- Memberikan pemahaman praktis kepada mahasiswa mengenai integrasi Flutter dengan layanan backend cloud (Firebase/Firestore).
- Melatih penerapan konsep *state management* dan *reactive programming* melalui `StreamBuilder`.
- Melatih kemampuan tim dalam bekerja secara kolaboratif dengan pembagian modul yang jelas (lihat Bab 9).

### 2.3 Target Keberhasilan (Success Metrics)
| Indikator | Target |
|---|---|
| Seluruh 5 menu utama berfungsi tanpa *crash* | 100% fitur dapat dijalankan end-to-end |
| Sinkronisasi data workout ke Firestore | Perubahan data tampil realtime < 2 detik tanpa refresh manual |
| Sesi login tetap tersimpan setelah aplikasi ditutup-paksa | Berhasil pada seluruh pengujian ulang buka aplikasi |
| Akurasi hasil kalkulasi (BMI, BMR, umur, Weton, Saka) | Sesuai dengan rumus referensi yang divalidasi |
| Kompatibilitas perangkat | Berjalan mulus pada Android API 21+ |

---

## 3. Target Users

### 3.1 Karakteristik Pengguna
- Mahasiswa dan masyarakat umum berusia 17–35 tahun yang memiliki ketertarikan pada pola hidup sehat.
- Pengguna yang membutuhkan pencatatan jadwal olahraga sederhana tanpa perangkat wearable tambahan.
- Pengguna yang tertarik dengan unsur budaya lokal (Jawa/Bali/Islam) sebagai pelengkap identitas aplikasi.
- Pengguna dengan literasi digital dasar hingga menengah (aplikasi harus intuitif dan tidak rumit).

### 3.2 Persona Singkat

**Persona 1 — "Dewi, Mahasiswi Aktif"**
- Usia 20 tahun, mahasiswi yang ingin menjaga berat badan ideal sambil kuliah.
- Kebutuhan: cek BMI cepat, catat jadwal workout mingguan, hitung usia otomatis untuk keperluan administrasi kampus.

**Persona 2 — "Pak Broto, Pekerja Kantoran"**
- Usia 34 tahun, ingin memulai rutinitas olahraga ringan dan tertarik mengetahui Weton dirinya untuk keperluan tradisi keluarga.
- Kebutuhan: kalkulator BMR untuk diet, stopwatch untuk sesi jogging, fitur Weton Jawa untuk kebutuhan adat.

---

## 4. User Stories

### 4.1 Modul Autentikasi & Manajemen Sesi
- Sebagai pengguna baru, saya ingin melakukan login dengan username sederhana, sehingga saya dapat mengakses fitur-fitur aplikasi secara personal.
- Sebagai pengguna, saya ingin status login saya tetap tersimpan meskipun aplikasi ditutup, sehingga saya tidak perlu login berulang kali setiap membuka aplikasi.
- Sebagai pengguna, saya ingin dapat melakukan logout melalui menu yang jelas, sehingga saya dapat mengakhiri sesi saya dengan aman.

### 4.2 Modul Bottom Navigation (Shell Utama)
- Sebagai pengguna, saya ingin berpindah antara Halaman Utama, Stopwatch, dan Bantuan/Logout melalui tab navigasi bawah, sehingga navigasi aplikasi terasa cepat dan konsisten.
- Sebagai pengguna, saya ingin melihat indikator tab aktif secara visual, sehingga saya selalu tahu posisi saya dalam aplikasi.

### 4.3 Modul CRUD Kegiatan Workout
- Sebagai pengguna, saya ingin menambahkan jadwal workout baru (nama latihan, tanggal, durasi, kategori), sehingga saya dapat merencanakan rutinitas olahraga saya.
- Sebagai pengguna, saya ingin melihat daftar jadwal workout saya secara realtime, sehingga saya selalu melihat data terbaru tanpa perlu me-refresh halaman.
- Sebagai pengguna, saya ingin mengedit jadwal workout yang sudah dibuat, sehingga saya dapat menyesuaikan rencana latihan saya.
- Sebagai pengguna, saya ingin menghapus jadwal workout yang sudah tidak relevan, sehingga daftar saya tetap rapi.

### 4.4 Modul Komputasi Kesehatan (BMI & BMR)
- Sebagai pengguna, saya ingin memasukkan berat badan dan tinggi badan saya, sehingga saya dapat mengetahui kategori BMI saya secara instan.
- Sebagai pengguna, saya ingin memasukkan data usia, jenis kelamin, dan tingkat aktivitas, sehingga saya dapat mengetahui estimasi kebutuhan kalori harian (BMR/TDEE) saya.

### 4.5 Modul Konversi Kalender & Umur
- Sebagai pengguna, saya ingin memasukkan tanggal lahir saya, sehingga saya dapat mengetahui usia saya secara detail hingga satuan detik.
- Sebagai pengguna, saya ingin mengonversi tanggal Masehi ke Hijriah, sehingga saya dapat mengetahui tanggal penting dalam kalender Islam.
- Sebagai pengguna, saya ingin memasukkan tanggal lahir saya untuk mengetahui Weton dan Neptu Jawa saya, sehingga saya dapat mengetahui makna tradisional dari hari kelahiran saya.
- Sebagai pengguna, saya ingin mengetahui padanan tanggal saya dalam Kalender Saka Bali, sehingga saya dapat memahami penanggalan budaya Bali yang relevan dengan diri saya.

---

## 5. Functional Requirements

### 5.1 Autentikasi & Sesi (Gatekeeper)
| Aspek | Spesifikasi |
|---|---|
| Input | Username (teks bebas, wajib diisi, minimal 3 karakter) |
| Proses | Simpan `isLoggedIn = true` dan `username` ke `SharedPreferences` |
| Validasi | Field tidak boleh kosong; tampilkan `SnackBar`/pesan error jika kosong |
| Output | Navigasi otomatis ke `HomeShell` (halaman Bottom Navigation) |
| Logout | Menghapus/mengubah `isLoggedIn` menjadi `false`, kembali ke `LoginPage`, konfirmasi via dialog sebelum logout dieksekusi |

### 5.2 Bottom Navigation Shell
| Tab | Ikon | Konten |
|---|---|---|
| 1. Halaman Utama | `Icons.home` | 5 tombol menu vertikal (lihat 5.3–5.6) |
| 2. Stopwatch | `Icons.timer` | Start, Pause/Resume, Reset, tampilan waktu format `HH:MM:SS.ms` |
| 3. Bantuan & Logout | `Icons.help_outline` | Info aplikasi, versi, daftar anggota kelompok singkat, tombol Logout |

### 5.3 Menu 1 — Data/Daftar Anggota Kelompok
- Menampilkan daftar statis 4 anggota kelompok (Nama, NIM) dalam bentuk `ListView`/`Card`.
- Tidak memerlukan koneksi database (data hardcoded di dalam kode/model lokal).

### 5.4 Menu 2 — Komputasi Tema Kebugaran (BMI & BMR)

**Kalkulator BMI**
- Input: berat badan (kg, numerik), tinggi badan (cm, numerik).
- Proses: `BMI = berat (kg) / (tinggi (m))²`
- Validasi: input harus lebih dari 0; tampilkan pesan error jika non-numerik atau kosong.
- Output: nilai BMI (2 desimal) beserta kategori (Kurus / Normal / Gemuk / Obesitas) sesuai standar WHO Asia-Pasifik.

**Kalkulator BMR/Kebutuhan Kalori Harian**
- Input: berat badan, tinggi badan, usia, jenis kelamin, tingkat aktivitas (dropdown: Sedentary, Ringan, Sedang, Aktif, Sangat Aktif).
- Proses: menggunakan rumus Mifflin-St Jeor:
  - Pria: `BMR = 10×berat + 6.25×tinggi − 5×usia + 5`
  - Wanita: `BMR = 10×berat + 6.25×tinggi − 5×usia − 161`
  - `TDEE = BMR × faktor aktivitas`
- Output: nilai BMR dan TDEE dalam satuan kkal/hari.

### 5.5 Menu 3 — CRUD Kegiatan Workout (Cloud Firestore)
| Operasi | Deskripsi |
|---|---|
| Create | Form input (nama latihan, kategori, tanggal, durasi menit, catatan) → disimpan ke koleksi `workouts` |
| Read | `StreamBuilder` membaca koleksi `workouts` secara realtime, diurutkan berdasarkan tanggal terbaru |
| Update | Form edit pre-filled dari data terpilih, update dokumen berdasarkan `documentId` |
| Delete | Konfirmasi dialog sebelum menghapus dokumen dari Firestore |
| Validasi | Nama latihan dan tanggal wajib diisi; durasi harus berupa angka positif |
| UI State | Menampilkan `CircularProgressIndicator` saat memuat, dan pesan "Belum ada jadwal" jika koleksi kosong |

### 5.6 Menu 4 — Konversi Kalender Hijriah & Kalkulator Umur Detail
- Input: tanggal lahir (melalui `showDatePicker`).
- Proses:
  - Konversi tanggal Masehi ke Hijriah menggunakan package konversi kalender (misal `hijri`).
  - Perhitungan umur detail: selisih waktu real-time saat ini dikurangi tanggal lahir, dipecah menjadi Tahun, Bulan, Hari, Jam, Menit, dan Detik (idealnya diperbarui otomatis menggunakan `Timer.periodic` setiap detik).
- Output: tanggal Hijriah yang sesuai, dan rincian umur lengkap yang berjalan real-time.

### 5.7 Menu 5 — Konversi Kalender Budaya (Weton Jawa & Kalender Saka Bali)
- Input: tanggal lahir (melalui `showDatePicker`).
- Proses:
  - **Weton Jawa**: menentukan hari pasaran (Legi, Pahing, Pon, Wage, Kliwon) berdasarkan perhitungan siklus 5 harian dari tanggal referensi, dikombinasikan dengan hari Masehi (Senin–Minggu) untuk mendapatkan Weton lengkap, serta menghitung Neptu (penjumlahan nilai numerologi hari dan pasaran).
  - **Kalender Saka Bali**: konversi tanggal Masehi ke padanan Tahun Saka (umumnya Tahun Masehi − 78, dengan penyesuaian bulan/hari sesuai referensi kalender Bali yang digunakan).
- Output: nama hari pasaran, nilai Neptu, dan tahun/tanggal Saka Bali yang sesuai.

---

## 6. Non-Functional Requirements

| Kategori | Ketentuan |
|---|---|
| **Performa** | Waktu render tiap halaman < 1 detik pada perangkat kelas menengah; operasi CRUD Firestore direspons < 2 detik pada koneksi stabil. |
| **Responsivitas UI** | Layout menggunakan widget adaptif (`Expanded`, `Flexible`, `MediaQuery`) agar sesuai di berbagai ukuran layar ponsel Android. |
| **Offline Handling** | Menampilkan pesan/status "Tidak ada koneksi internet" saat proses baca/tulis ke Firestore gagal; Firestore cache lokal dimanfaatkan untuk menampilkan data terakhir yang tersimpan bila tersedia. |
| **Keamanan (Security)** | Sesi login disimpan lokal via `shared_preferences` (bukan untuk data sensitif); disarankan menonaktifkan mode debug/print data sensitif pada build rilis. Firestore Security Rules dikonfigurasi minimal untuk mencegah akses tulis/baca sembarangan dari luar aplikasi. |
| **Usability** | Navigasi konsisten dengan `BottomNavigationBar`; seluruh tombol memiliki label jelas dan ukuran sentuh (*tap target*) minimal 48x48 dp. |
| **Kompatibilitas Perangkat** | Minimum Android SDK 21 (Android 5.0 Lollipop); direkomendasikan untuk diuji pada minimal 2 perangkat/emulator berbeda ukuran layar. |
| **Maintainability** | Struktur folder mengikuti pemisahan `models/`, `screens/`, `services/`, `widgets/` untuk memudahkan kolaborasi tim. |

---

## 7. Scope

### 7.1 In-Scope (Wajib Ada pada Rilis Ini)
- Login sederhana berbasis username dengan sesi tersimpan (`shared_preferences`).
- Struktur navigasi `BottomNavigationBar` 3 tab.
- Halaman Utama dengan 5 tombol menu vertikal sesuai spesifikasi.
- Fitur CRUD jadwal workout dengan sinkronisasi realtime Cloud Firestore.
- Kalkulator BMI dan BMR/kebutuhan kalori harian.
- Konversi kalender Hijriah dan kalkulator umur detail (tahun s.d. detik).
- Konversi Weton Jawa (dengan Neptu) dan Kalender Saka Bali.
- Fitur Stopwatch dasar (start, pause/resume, reset).
- Halaman Bantuan berisi informasi aplikasi dan tombol Logout.

### 7.2 Out-of-Scope (Sengaja Tidak Dibuat pada Rilis Ini)
- Integrasi dengan perangkat wearable/smartwatch atau sensor kebugaran eksternal (Google Fit, Apple Health, dsb.).
- Sistem pembayaran (*payment gateway*) atau fitur premium berbayar.
- Autentikasi berbasis Firebase Authentication (email/password, OAuth, dsb.) — cukup menggunakan sesi lokal sederhana.
- Fitur sosial (berbagi progres antar pengguna, leaderboard, komentar).
- Notifikasi push (reminder jadwal workout otomatis).
- Mode multi-bahasa (aplikasi hanya berbahasa Indonesia).
- Sinkronisasi data lintas akun/perangkat berbasis cloud user-specific (data workout bersifat global per koleksi, bukan per-user terisolasi).

---

## 8. Technical Architecture & Data Schema

### 8.1 Skema Dokumen Firestore — Koleksi `workouts`

```
Collection: workouts
Document ID: (auto-generated oleh Firestore)
{
  "namaLatihan": "Lari Pagi",           // String, wajib
  "kategori": "Kardio",                  // String, contoh: Kardio, Angkat Beban, Yoga, Lainnya
  "tanggal": Timestamp,                  // Timestamp, tanggal pelaksanaan workout
  "durasiMenit": 30,                     // Number (int), durasi latihan dalam menit
  "catatan": "Target 5 km",              // String, opsional
  "createdAt": Timestamp,                // Timestamp, waktu dokumen dibuat (server timestamp)
  "updatedAt": Timestamp                 // Timestamp, waktu dokumen terakhir diperbarui
}
```

**Query Utama:**
```dart
FirebaseFirestore.instance
  .collection('workouts')
  .orderBy('tanggal', descending: true)
  .snapshots();
```

### 8.2 Kebutuhan Dependensi `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^3.6.0
  cloud_firestore: ^5.4.4

  # Session Management
  shared_preferences: ^2.3.2

  # Format Tanggal & Lokalisasi
  intl: ^0.19.0

  # Konversi Kalender Hijriah
  hijri: ^3.0.0

  # UI Pendukung (opsional, sesuai kebutuhan tim)
  cupertino_icons: ^1.0.8
```

> Catatan: Untuk konversi Weton Jawa dan Kalender Saka Bali, tim mengimplementasikan logika perhitungan secara manual (custom Dart function) karena belum tersedia package resmi yang stabil di pub.dev untuk kedua sistem kalender tersebut.

### 8.3 Alur Logic Persistensi Sesi Login/Logout (Gatekeeper Flow)

```
[App Start]
     │
     ▼
[main.dart] → Inisialisasi Firebase (Firebase.initializeApp)
     │
     ▼
[SplashScreen/Gatekeeper Widget]
     │
     ▼
Cek SharedPreferences.getBool('isLoggedIn')
     │
     ├── TRUE  → Ambil 'username' dari SharedPreferences
     │             → Arahkan ke HomeShell (BottomNavigationBar)
     │
     └── FALSE → Arahkan ke LoginPage
                     │
                     ▼
              User mengisi username → tekan tombol Login
                     │
                     ▼
              Validasi input (tidak boleh kosong)
                     │
                     ▼
              Simpan ke SharedPreferences:
                - isLoggedIn = true
                - username = <input>
                     │
                     ▼
              Navigasi ke HomeShell

[Logout Flow]
     │
     ▼
User menekan tombol Logout di Tab "Bantuan & Logout"
     │
     ▼
Dialog konfirmasi ("Yakin ingin keluar?")
     │
     ├── Batal → Tutup dialog, tetap di halaman
     │
     └── Ya    → SharedPreferences.setBool('isLoggedIn', false)
                     │
                     ▼
              Navigasi kembali ke LoginPage (pushAndRemoveUntil)
```

### 8.4 Struktur Folder Proyek (Rekomendasi)

```
lib/
├── main.dart
├── models/
│   └── workout_model.dart
├── screens/
│   ├── auth/
│   │   └── login_page.dart
│   ├── home/
│   │   ├── home_shell.dart          // BottomNavigationBar
│   │   └── home_page.dart           // 5 menu vertikal
│   ├── team/
│   │   └── team_page.dart           // Menu 1
│   ├── health_calc/
│   │   └── health_calculator_page.dart  // Menu 2
│   ├── workout/
│   │   ├── workout_list_page.dart   // Menu 3 (Read)
│   │   └── workout_form_page.dart   // Menu 3 (Create/Update)
│   ├── calendar/
│   │   ├── hijri_age_page.dart      // Menu 4
│   │   └── culture_calendar_page.dart // Menu 5
│   ├── stopwatch/
│   │   └── stopwatch_page.dart
│   └── help/
│       └── help_logout_page.dart
├── services/
│   ├── session_service.dart         // Wrapper shared_preferences
│   └── firestore_service.dart       // Wrapper CRUD Firestore
└── widgets/
    └── custom_menu_button.dart      // Komponen tombol menu reusable
```

---

## 9. Team Responsibility Matrix (RACI)

**Keterangan:** R = Responsible (mengerjakan), A = Accountable (bertanggung jawab penuh/reviewer akhir), C = Consulted (dikonsultasikan), I = Informed (diinformasikan)

| Modul / Tugas | Aditya Fadilah R.A (062) | Akbar Maulana S. (079) | Azhicry Vernando E.P (069) | Damar Nugroho (073) |
|---|---|---|---|---|
| Setup Proyek & Integrasi Firebase | **R/A** | C | I | I |
| Autentikasi & Sesi Login (`shared_preferences`) + Gatekeeper Flow | **R/A** | I | C | I |
| Bottom Navigation Shell & Halaman Utama (5 menu) | C | **R/A** | I | I |
| Menu 1 — Data/Daftar Anggota Kelompok | I | **R/A** | C | I |
| Menu 2 — Komputasi Kesehatan (BMI & BMR) | I | C | **R/A** | I |
| Menu 3 — CRUD Workout (Cloud Firestore) | C | I | I | **R/A** |
| Menu 4 — Konversi Hijriah & Kalkulator Umur | I | C | **R/A** | I |
| Menu 5 — Weton Jawa & Kalender Saka Bali | I | I | C | **R/A** |
| Fitur Stopwatch | C | **R/A** | I | I |
| Halaman Bantuan & Logout | I | I | I | **R/A** |
| UI/UX Konsistensi & Styling Global | C | C | C | C (seluruh anggota) |
| Dokumentasi (PRD, Laporan, README) | **R/A** | C | C | C |
| Pengujian & QA Akhir | C | C | C | C (seluruh anggota) |

> Catatan: Meskipun setiap anggota memiliki modul utama (Accountable), seluruh anggota tetap berkontribusi dalam proses *code review*, integrasi antar-modul, dan pengujian akhir sebelum pengumpulan tugas besar.

---

## 10. Lampiran — Ringkasan Rilis

| Fitur | Status Target |
|---|---|
| Login & Sesi | ✅ Wajib |
| Bottom Navigation (3 Tab) | ✅ Wajib |
| Daftar Anggota Kelompok | ✅ Wajib |
| Kalkulator BMI & BMR | ✅ Wajib |
| CRUD Workout Realtime (Firestore) | ✅ Wajib |
| Konversi Hijriah & Umur Detail | ✅ Wajib |
| Weton Jawa & Kalender Saka Bali | ✅ Wajib |
| Stopwatch | ✅ Wajib |
| Halaman Bantuan & Logout | ✅ Wajib |

---

**Disusun oleh:** Kelompok FitCalculate — Pemrograman Aplikasi Mobile
**Anggota:** Aditya Fadilah R.A (124240062), Akbar Maulana Setiawan (124240079), Azhicry Vernando E.P (124240069), Damar Nugroho (124240073)

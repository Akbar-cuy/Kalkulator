# FitCalculate

Aplikasi mobile berbasis Flutter untuk kesehatan, kebugaran, dan penanggalan budaya. FitCalculate merupakan pengembangan lanjutan dari CalculateDD. Sebagian kode saat ini masih menggunakan nama runtime `CalculateDD`, sedangkan nama produk dan dokumen resmi menggunakan `FitCalculate`.

## Deskripsi Proyek

Proyek ini dibuat sebagai aplikasi mobile untuk membantu pengguna dalam:

- menghitung kebutuhan kesehatan dan kebugaran,
- mencatat jadwal latihan atau workout,
- mengelola sesi login dengan data lokal,
- melihat informasi kalender dan umur secara detail,
- serta mengakses modul bantuan dan data tim pengembang.

Aplikasi ini dibangun dengan bahasa Dart dan framework Flutter, serta memanfaatkan `shared_preferences` untuk sesi lokal, Firebase/Cloud Firestore untuk data workout realtime, `intl` untuk pemformatan tanggal, dan `hijri` untuk konversi kalender Hijriah.

## Fitur Utama

- Autentikasi sederhana dengan username dan session login lokal
- Navigasi utama menggunakan Bottom Navigation
- Halaman utama dengan lima menu fitur
- Kalkulator BMI dan BMR/TDEE
- CRUD jadwal workout dengan data Firestore
- Stopwatch latihan
- Konversi kalender Hijriah dan kalkulator umur
- Konversi Weton Jawa dan Kalender Saka Bali
- Halaman bantuan serta daftar tim pengembang

Untuk Weton Jawa dan Kalender Saka Bali, logika perhitungan dibuat sebagai fungsi Dart lokal sesuai keputusan pada PRD.

## Struktur Folder

```text
Kalkulator/
├── android/                # Project Android
├── ios/                    # Project iOS
├── lib/
│   ├── core/
│   │   ├── constants/      # Konstanta app, warna, data pengguna
│   │   ├── services/       # Service untuk sesi/local dan backend
│   │   └── widgets/        # Widget reusable
│   ├── features/
│   │   ├── age_hijri/      # Calculator umur & kalender Hijriah
│   │   ├── auth/           # Login dan autentikasi
│   │   ├── culture_calendar/# Weton Jawa & kalender Bali
│   │   ├── fitness_calculator/ # BMI & BMR
│   │   ├── help/           # Halaman bantuan
│   │   ├── home/           # Home dashboard
│   │   ├── legacy_calculators/ # Kalkulator legacy
│   │   ├── shell/          # Layout navigasi utama
│   │   ├── stopwatch/      # Stopwatch
│   │   ├── team/           # Data tim pengembang
│   │   └── workout/        # CRUD workout
│   ├── models/
│   │   └── workout_model.dart
│   ├── utils/
│   │   ├── date_utils.dart
│   │   └── validators.dart
│   ├── main.dart
│   └── ...
├── docs/
│   ├── design.md
│   ├── prd.md
│   └── architecture.md
├── test/
│   └── widget_test.dart
├── analysis_options.yaml
├── pubspec.yaml
├── README.md
├── android/ ...
├── ios/ ...
├── web/ ...
└── ...
```

## Teknologi dan Dependensi

- Flutter
- Dart
- `firebase_core`
- `cloud_firestore`
- `shared_preferences`
- `intl`
- `hijri`
- `cupertino_icons`
- Material Design 3

## Persyaratan Sistem

Sebelum menjalankan proyek, pastikan perangkat Anda sudah memiliki:

- Flutter SDK terinstall
- Dart SDK terinstall
- Android Studio / VS Code
- Emulator Android, perangkat fisik, atau browser Edge untuk pengujian web
- Koneksi internet untuk dependency dan Firebase

## Cara Menjalankan

1. Masuk ke folder project
2. Jalankan perintah:

```bash
flutter pub get
flutter run
```

Untuk menjalankan melalui Edge, gunakan:

```bash
flutter run -d edge
```

Jika menggunakan emulator atau perangkat Android, pastikan device sudah terhubung dan driver Android sudah siap.

## Catatan Penting

Proyek ini dikembangkan berdasarkan [PRD](docs/prd.md), [design system](docs/design.md), dan [aturan arsitektur](docs/architecture.md). Pastikan konfigurasi Firebase sudah siap agar fitur CRUD workout dapat menggunakan backend secara lengkap.

## Tim Pengembang

- Aditya Fadilah R.A - 124240062
- Akbar Maulana Setiawan - 124240079
- Azhicry Vernando E.P - 124240069
- Damar Nugroho - 124240073

## Lisensi

Proyek ini dibuat untuk kebutuhan pembelajaran mata kuliah Pemrograman Aplikasi Mobile.

---

Dokumentasi lebih lengkap mengenai kebutuhan produk, arsitektur, dan desain UI dapat dilihat di folder `docs/`.
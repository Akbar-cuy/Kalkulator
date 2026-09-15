# CalculateDD / FitCalculate

Aplikasi mobile berbasis Flutter yang dikembangkan untuk kebutuhan kalkulator kesehatan, kebugaran, dan penanggalan budaya. Dalam implementasi kode saat ini, aplikasi ini dipanggil dengan nama `CalculateDD`, sementara dokumen produk dan desain umum menyebutnya sebagai `FitCalculate`. Project ini menggabungkan berbagai fitur seperti login sederhana, jadwal workout, BMI/BMR, stopwatch, kalender Hijriah, serta kalender budaya Jawa dan Bali dalam satu aplikasi.

## Deskripsi Proyek

Proyek ini dibuat sebagai aplikasi mobile untuk membantu pengguna dalam:

- menghitung kebutuhan kesehatan dan kebugaran,
- mencatat jadwal latihan atau workout,
- mengelola sesi login dengan data lokal,
- melihat informasi kalender dan umur secara detail,
- serta mengakses modul bantuan dan data tim pengembang.

Aplikasi ini dibangun dengan bahasa Dart dan framework Flutter, serta memanfaatkan package seperti `shared_preferences`, `firebase_core`, dan `cloud_firestore`.

## Fitur Utama

- Autentikasi sederhana dengan username dan session login lokal
- Navigasi utama menggunakan Bottom Navigation
- Halaman dashboard berisi beberapa menu fitur
- Kalkulator BMI dan BMR/TDEE
- CRUD jadwal workout dengan data Firestore
- Stopwatch latihan
- Konversi kalender Hijriah dan kalkulator umur
- Konversi Weton Jawa dan Kalender Saka Bali
- Halaman bantuan serta daftar tim pengembang

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

## Teknologi yang Digunakan

- Flutter
- Dart
- Firebase Core
- Cloud Firestore
- Shared Preferences
- Material Design 3

## Persyaratan Sistem

Sebelum menjalankan proyek, pastikan perangkat Anda sudah memiliki:

- Flutter SDK terinstall
- Dart SDK terinstall
- Android Studio / VS Code
- Emulator Android atau perangkat fisik
- Koneksi internet untuk dependency dan Firebase

## Cara Menjalankan

1. Clone repository ini
2. Masuk ke folder project
3. Jalankan perintah:

```bash
flutter pub get
flutter run
```

Jika Anda menggunakan emulator atau perangkat Android, pastikan device sudah terhubung dan driver Android sudah siap.

## Catatan Penting

Proyek ini masih dalam tahap pengembangan dan beberapa modul didesain sesuai dokumentasi PRD dan design system yang ada di folder `docs/`. Pastikan konfigurasi Firebase dan asset tambahan sudah siap jika Anda ingin menjalankan aplikasi dengan data backend yang lengkap.

## Tim Pengembang

- Aditya Fadilah R.A - 124240062
- Akbar Maulana Setiawan - 124240079
- Azhicry Vernando E.P - 124240069
- Damar Nugroho - 124240073

## Lisensi

Proyek ini dibuat untuk kebutuhan pembelajaran mata kuliah Pemrograman Aplikasi Mobile.

---

Dokumentasi lebih lengkap mengenai kebutuhan produk, arsitektur, dan desain UI dapat dilihat di folder `docs/`.

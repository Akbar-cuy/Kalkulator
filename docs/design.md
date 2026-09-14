# System & UI/UX Design Document (DESIGN.md)
## FitCalculate — Aplikasi Kesehatan & Kebugaran Berbasis Flutter

| Atribut | Keterangan |
|---|---|
| Nama Produk | FitCalculate (Evolusi dari CalculateDD) |
| Mata Kuliah | Pemrograman Aplikasi Mobile |
| Peran Dokumen | Lead UI/UX Design & Mobile System Architecture Reference |
| Versi Dokumen | 1.0 |
| Tanggal | 14 September 2026 |
| Referensi Terkait | `PRD.md` (Product Requirement Document) |

### Tim Pengembang
| No | Nama | NIM |
|---|---|---|
| 1 | Aditya Fadilah R.A | 124240062 |
| 2 | Akbar Maulana Setiawan | 124240079 |
| 3 | Azhicry Vernando E.P | 124240069 |
| 4 | Damar Nugroho | 124240073 |

---

## 1. Architectural Overview

### 1.1 Pola Arsitektur Folder

Proyek ini menggunakan pendekatan **Feature-First Architecture** yang dimodifikasi dengan pemisahan layer teknis (`services`, `models`, `widgets` global), agar setiap anggota tim dapat bekerja pada modul fitur masing-masing (lihat Bab 9 PRD.md) tanpa banyak konflik file.

```
lib/
├── main.dart                        # Entry point + Firebase.initializeApp()
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart          # Design token warna (kPrimaryColor, dst.)
│   │   ├── app_text_styles.dart     # Design token tipografi
│   │   └── app_dimens.dart          # Radius, spacing, elevation konstan
│   ├── services/
│   │   ├── session_service.dart     # Wrapper shared_preferences
│   │   └── firestore_service.dart   # Wrapper CRUD Cloud Firestore
│   └── widgets/                     # Komponen UI reusable lintas fitur
│       ├── primary_button.dart
│       ├── app_text_field.dart
│       ├── menu_card_button.dart
│       ├── confirmation_dialog.dart
│       └── error_box.dart
│
├── models/
│   └── workout_model.dart           # Model data workout (fromMap/toMap)
│
├── features/
│   ├── auth/
│   │   └── login_screen.dart
│   ├── shell/
│   │   └── main_shell.dart          # BottomNavigationBar (root navigasi)
│   ├── home/
│   │   └── home_screen.dart         # Header + 5 menu vertikal
│   ├── team/
│   │   └── data_kelompok_screen.dart
│   ├── fitness_calculator/
│   │   └── fitness_calculator_screen.dart
│   ├── workout/
│   │   ├── workout_crud_screen.dart
│   │   └── workout_form_sheet.dart  # Bottom sheet form create/edit
│   ├── age_hijri/
│   │   └── age_hijri_screen.dart
│   ├── culture_calendar/
│   │   └── culture_calendar_screen.dart
│   ├── stopwatch/
│   │   └── stopwatch_screen.dart
│   └── help/
│       └── help_screen.dart
│
└── utils/
    ├── date_utils.dart               # Helper konversi Hijriah/Weton/Saka
    └── validators.dart               # Fungsi validasi form
```

**Prinsip desain arsitektur:**
- **Separation of Concerns**: UI (screen/widget), logika bisnis (services/utils), dan model data dipisahkan agar mudah diuji dan dipelihara.
- **Single Source of Truth untuk Design Token**: seluruh warna dan gaya teks didefinisikan satu kali di `core/constants/` dan dipakai ulang di seluruh fitur — tidak ada *hardcoded* warna di level widget.
- **Reusable Widget First**: setiap elemen UI yang muncul lebih dari satu kali (tombol, kartu menu, dialog) dibungkus menjadi widget terpisah di `core/widgets/`.

### 1.2 Alur Data (Data Flow)

FitCalculate memiliki **dua sumber data (data source)** dengan siklus hidup berbeda:

```
┌─────────────────────┐        ┌──────────────────────┐        ┌────────────────────────┐
│         UI           │        │   Local State Layer    │        │   Remote Data Layer      │
│ (Widget / Screen)    │◄──────►│   shared_preferences    │        │   Cloud Firestore         │
└─────────────────────┘        └──────────────────────┘        └────────────────────────┘
        │                                 │                                    ▲
        │  Session data:                  │  Persist:                          │
        │  isLoggedIn, username           │  - isLoggedIn (bool)               │
        │                                 │  - username (String)               │
        │                                                                       │
        │  Workout data (Create/Update/Delete)                                 │
        └───────────────────────────────────────────────────────────────────►│
                          │                                                    │
                          │   StreamBuilder<QuerySnapshot>                     │
                          │◄───────────────────────────────────────────────────┘
                          ▼
                 Realtime UI Update
                 (ListView otomatis refresh)
```

**Penjelasan alur:**
1. **UI → Local State (`shared_preferences`)**: digunakan khusus untuk data sesi ringan (status login & username). Bersifat sinkron, cepat, dan tidak memerlukan koneksi internet.
2. **UI → Remote Data (Firestore)**: digunakan untuk data yang perlu persisten, terstruktur, dan dapat diakses secara realtime lintas sesi — yaitu koleksi `workouts`.
3. **Firestore → UI (Realtime)**: menggunakan `StreamBuilder` yang berlangganan (*subscribe*) pada `snapshots()` koleksi `workouts`, sehingga setiap perubahan data (tambah/edit/hapus) langsung terpantul ke UI tanpa perlu `setState` manual atau tombol refresh.
4. **Unidirectional Update Pattern**: aksi pengguna (submit form) memicu pemanggilan method di `firestore_service.dart`, bukan langsung memanipulasi Firestore dari widget — menjaga UI tetap "bodoh" (dumb) dan logika terpusat di service layer.

---

## 2. Design System & UI Guidelines

### 2.1 Palette Warna Resmi

| Token | Hex Code | Peran Semantik | Contoh Penggunaan |
|---|---|---|---|
| `kPrimaryColor` | `#1E3A8A` | Primary — warna identitas utama brand | AppBar, header, ikon aktif Bottom Nav |
| `kPrimaryDark` | `#14265C` | Primary Variant — untuk elemen gelap/gradasi | Gradient header, status bar overlay |
| `kAccentColor` | `#F97316` | Secondary/Accent — aksi utama & CTA | Tombol utama (Simpan, Login), FAB |
| `kBackgroundColor` | `#F2F4FA` | Background — latar seluruh layar | `Scaffold.backgroundColor` |
| `Surface (Card)` | `#FFFFFF` | Surface — permukaan kartu/komponen | `Card`, `BottomSheet`, `Dialog` |
| `kSuccessColor` | `#16A34A` | Success/Status positif | Badge status workout selesai, notifikasi sukses |
| `kErrorColor` | `#DC2626` (disarankan, konsisten dengan famili warna sistem) | Error/Danger | Tombol Logout, pesan error validasi |
| `kTextMuted` | `#475569` | Teks sekunder/deskripsi | Subjudul, label field, teks bantu |
| `Text Primary` | `#0F172A` (disarankan) | Teks judul/isi utama | Judul kartu, isi hasil kalkulasi |

> Catatan Desain: `kErrorColor` dan `Text Primary` belum didefinisikan eksplisit pada basis kode sebelumnya, sehingga diusulkan sebagai ekstensi yang konsisten dengan famili palet navy-orange yang sudah ada. Tim disarankan menambahkannya ke `app_colors.dart` agar tidak ada warna *hardcoded* baru saat membangun komponen error/danger.

**Implementasi Token (`core/constants/app_colors.dart`):**
```dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1E3A8A);
  static const Color primaryDark = Color(0xFF14265C);
  static const Color accent = Color(0xFFF97316);
  static const Color background = Color(0xFFF2F4FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF16A34A);
  static const Color error = Color(0xFFDC2626);
  static const Color textMuted = Color(0xFF475569);
  static const Color textPrimary = Color(0xFF0F172A);
}
```

### 2.2 Tipografi

Menggunakan font sistem default Flutter (Roboto pada Android) dengan skala hierarki berikut:

| Level | Ukuran (sp) | Ketebalan | Penggunaan |
|---|---|---|---|
| `Display` | 28 | `FontWeight.w700` (Bold) | Angka besar stopwatch, hasil BMI/BMR utama |
| `Heading 1 (H1)` | 22 | `FontWeight.w700` (Bold) | Judul halaman (AppBar title custom) |
| `Heading 2 (H2)` | 18 | `FontWeight.w600` (Semibold) | Judul kartu/section (contoh: "Jadwal Workout Anda") |
| `Body` | 14–15 | `FontWeight.w400` (Regular) | Teks isi, deskripsi, hasil sekunder |
| `Label` | 13 | `FontWeight.w500` (Medium) | Label input field, caption |
| `Caption/Muted` | 12 | `FontWeight.w400` (Regular), warna `kTextMuted` | Timestamp, keterangan tambahan |
| `Button Text` | 15–16 | `FontWeight.w600` (Semibold) | Teks pada seluruh tombol aksi |

**Implementasi Token (`core/constants/app_text_styles.dart`):**
```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const display = TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const h1 = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const h2 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const body = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textPrimary);
  static const label = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textMuted);
  static const caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textMuted);
  static const button = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white);
}
```

### 2.3 Elevation, Radius & Spacing Standar

| Token | Nilai | Keterangan |
|---|---|---|
| `radiusSmall` | 12 | Radius komponen kecil (chip, badge) |
| `radiusMedium` | 16 | Radius standar Card, TextField, Button |
| `radiusLarge` | 24 | Radius BottomSheet (sudut atas) |
| `shadowSoft` | `BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8–10, offset: Offset(0,4))` | Bayangan lembut standar seluruh Card |
| `spacingUnit` | 8 (basis kelipatan: 8, 16, 24, 32) | Konsistensi jarak antar elemen (padding/margin) |

### 2.4 Komponen UI Reusable

#### a. `PrimaryButton` — Tombol Aksi Kustom
- **Struktur**: `Container` dengan `borderRadius: 16`, warna latar `kAccentColor`, teks putih bold, opsional ikon di kiri teks.
- **State**: Default, Pressed (opacity 0.85), Disabled (abu-abu `kTextMuted` dengan opacity 0.4), Loading (`CircularProgressIndicator` kecil menggantikan teks).
- **Varian**: `PrimaryButton` (accent, untuk aksi utama seperti Simpan/Login) dan `DangerButton` (warna `kErrorColor`, khusus tombol Logout/Hapus).

#### b. `AppTextField` — Text Field Standar
- **Struktur**: `TextFormField` dibungkus dengan label di atas (`AppTextStyles.label`), border `OutlineInputBorder(borderRadius: 12)`, warna border default abu muda, berubah `kPrimaryColor` saat fokus, dan `kErrorColor` saat validasi gagal.
- **Fitur tambahan**: `errorText` tampil di bawah field dengan `AppTextStyles.caption` warna merah; mendukung `keyboardType` dinamis (numerik untuk berat/tinggi, tanggal untuk date picker read-only).

#### c. `MenuCardButton` — Kartu Menu Vertikal (Halaman Utama)
- **Struktur**: `Card` lebar penuh (`double.infinity`) dengan `borderRadius: 16`, `shadowSoft`, padding internal 16, berisi ikon (kiri, warna `kPrimaryColor` dalam lingkaran latar `kBackgroundColor`), judul menu (`AppTextStyles.h2`), subjudul singkat (`AppTextStyles.caption`), dan ikon panah `>` di kanan.
- **Interaksi**: `InkWell` dengan efek ripple, `onTap` melakukan `Navigator.push` ke layar tujuan.

#### d. `ConfirmationDialog` — Dialog Konfirmasi CRUD
- **Struktur**: `AlertDialog` dengan `borderRadius: 16`, judul singkat (contoh: "Hapus Jadwal?"), deskripsi (`AppTextStyles.body`, warna `kTextMuted`), dua tombol sejajar: "Batal" (outline, netral) dan tombol aksi (`DangerButton` untuk hapus/logout, `PrimaryButton` untuk konfirmasi simpan).
- **Digunakan pada**: konfirmasi hapus workout, konfirmasi logout.

#### e. `ErrorBox` — Kotak Pesan Error
- **Struktur**: `Container` latar merah muda transparan (`kErrorColor.withOpacity(0.08)`), border kiri tebal 4px warna `kErrorColor`, ikon `Icons.error_outline`, teks pesan error (`AppTextStyles.body`, warna `kErrorColor`).
- **Digunakan pada**: kegagalan koneksi Firestore, error parsing tanggal, validasi form gagal secara umum (selain inline error per-field).

---

## 3. Navigation & Information Architecture (IA)

### 3.1 Diagram Hierarki Navigasi

```
                              [App Launch]
                                   │
                                   ▼
                        ┌─────────────────────┐
                        │   Gatekeeper Check    │
                        │ (SharedPreferences)   │
                        └─────────────────────┘
                             │            │
                   isLoggedIn=false   isLoggedIn=true
                             │            │
                             ▼            ▼
                    ┌────────────────┐   ┌───────────────────────────┐
                    │  LoginScreen    │   │        MainShell            │
                    │ (Form Username) │   │  (BottomNavigationBar Root)  │
                    └────────────────┘   └───────────────────────────┘
                             │                        │
                     Login sukses                     │
                             └───────────────►┌────────┴────────┬─────────────────┐
                                               │                 │                 │
                                          Tab 1: Beranda    Tab 2: Stopwatch   Tab 3: Bantuan
                                               │                 │            & Logout
                                               ▼                 ▼                 │
                                    ┌──────────────────┐  [StopwatchScreen]        ▼
                                    │   HomeScreen       │                   [HelpScreen]
                                    │ (Header + 5 Menu)   │                        │
                                    └──────────────────┘                  Tombol Logout
                                               │                                (Dialog Konfirmasi)
             ┌───────────────┬────────────────┼──────────────────┬──────────────────┐
             ▼               ▼                ▼                  ▼                  ▼
     [DataKelompok    [FitnessCalculator  [WorkoutCrud     [AgeHijriScreen    [CultureCalendar
      Screen]           Screen]            Screen]                             Screen]
                                               │
                                     ┌─────────┴─────────┐
                                     ▼                   ▼
                            [WorkoutFormSheet       [ConfirmationDialog
                             — Create/Edit]           — Delete]
```

### 3.2 Strategi Routing

| Skenario Navigasi | Metode | Alasan Teknis |
|---|---|---|
| Login berhasil → masuk ke `MainShell` | `Navigator.pushReplacement` | Mencegah pengguna kembali ke `LoginScreen` via tombol back |
| Beranda → sub-menu (Data Kelompok, Kalkulator, dll.) | `Navigator.push` | Layar sub-menu bersifat "menumpuk" dan dapat kembali (back) ke Beranda |
| Logout → kembali ke `LoginScreen` | `Navigator.pushAndRemoveUntil(..., (route) => false)` | Menghapus seluruh riwayat stack navigasi agar pengguna tidak bisa "back" ke halaman yang butuh sesi |
| Tambah/Edit jadwal workout | `showModalBottomSheet` | Interaksi cepat tanpa berpindah halaman penuh, konteks daftar tetap terlihat sebagian |
| Konfirmasi hapus/logout | `showDialog` (dengan `barrierDismissible: false`) | Mencegah aksi destruktif tidak sengaja lewat tap di luar dialog |
| Perpindahan antar Tab Bottom Nav | `IndexedStack` + `onTap` BottomNavigationBar (bukan `Navigator.push`) | Mempertahankan *state* masing-masing tab (misal: stopwatch tetap berjalan saat pindah ke tab lain) |

---

## 4. Screen Layout & Wireframe Specifications

### 4.1 `LoginScreen`

```
┌───────────────────────────────┐
│                                 │
│         [Logo/Ikon App]         │
│         FitCalculate            │
│      "Selamat Datang Kembali"   │
│                                 │
│   ┌───────────────────────┐   │
│   │ Label: Username         │   │
│   │ [ AppTextField        ] │   │
│   └───────────────────────┘   │
│                                 │
│   ┌───────────────────────┐   │
│   │     Masuk (PrimaryButton)│  │
│   └───────────────────────┘   │
│                                 │
│   [ErrorBox — muncul kondisional│
│    jika username kosong]        │
│                                 │
└───────────────────────────────┘
```
- **Tata letak**: `Center` + `SingleChildScrollView` (antisipasi keyboard muncul), padding horizontal 24.
- **Validasi**: `onPressed` tombol Masuk memeriksa `TextEditingController.text.trim().length >= 3`; jika gagal, tampilkan `errorText` inline pada `AppTextField` dan getarkan (opsional `HapticFeedback`).
- **Handling sukses**: simpan sesi via `SessionService.login(username)` → `Navigator.pushReplacement` ke `MainShell`.

### 4.2 `MainShell`

- **Struktur**: `Scaffold` dengan `body: IndexedStack(index: _selectedIndex, children: [HomeScreen(), StopwatchScreen(), HelpScreen()])`.
- **`BottomNavigationBar`**:
  | Properti | Nilai |
  |---|---|
  | `backgroundColor` | `Colors.white` |
  | `selectedItemColor` | `kPrimaryColor` |
  | `unselectedItemColor` | `kTextMuted` |
  | `type` | `BottomNavigationBarType.fixed` |
  | `elevation` | 8, dengan `shadowSoft` di atas bar |
  | Item 1 | Ikon `Icons.home_rounded` / `Icons.home_outlined` — Label "Beranda" |
  | Item 2 | Ikon `Icons.timer_rounded` / `Icons.timer_outlined` — Label "Stopwatch" |
  | Item 3 | Ikon `Icons.help_rounded` / `Icons.help_outline` — Label "Bantuan" |

### 4.3 `HomeScreen`

```
┌───────────────────────────────┐
│  Header (gradient kPrimaryColor  │
│   → kPrimaryDark, radius bawah)  │
│  "Halo, {username} 👋"           │
│  "Semangat berlatih hari ini!"   │
├───────────────────────────────┤
│                                 │
│   [MenuCardButton] Data Kelompok │
│   [MenuCardButton] Komputasi     │
│                    Kebugaran     │
│   [MenuCardButton] Jadwal        │
│                    Workout       │
│   [MenuCardButton] Kalender      │
│                    Hijriah & Umur │
│   [MenuCardButton] Kalender      │
│                    Budaya         │
│                                 │
└───────────────────────────────┘
```
- **Header**: `Container` dengan `BoxDecoration(gradient: LinearGradient(colors: [kPrimaryColor, kPrimaryDark]))`, `borderRadius` hanya di sudut bawah (`BorderRadius.only(bottomLeft/bottomRight: Radius.circular(24))`), menampilkan sapaan dinamis berdasarkan `SessionService.getUsername()`.
- **Daftar Menu**: `ListView` (atau `Column` dalam `SingleChildScrollView` jika 5 item selalu muat tanpa scroll) berisi 5 `MenuCardButton` tersusun vertikal dengan `spacingUnit` 16 antar kartu, `padding` horizontal 20, secara visual berada di tengah lebar layar.

### 4.4 `StopwatchScreen`

```
┌───────────────────────────────┐
│                                 │
│         00 : 00 : 00            │
│         (Display, 48sp bold)     │
│                                 │
│   [Reset]   [Start/Pause]  [Lap] │
│  (outline)   (accent, besar)  (outline)│
│                                 │
│  ── Daftar Lap ──                │
│  ┌───────────────────────┐    │
│  │ Lap 1        00:00:15.20│    │
│  ├───────────────────────┤    │
│  │ Lap 2        00:00:32.10│    │
│  └───────────────────────┘    │
│         (ListView.builder)      │
└───────────────────────────────┘
```
- **Digital Clock**: teks besar terpusat, format `HH:MM:SS` (dan opsional milidetik dalam ukuran lebih kecil di sebelahnya), warna `kPrimaryColor`, font `AppTextStyles.display` diperbesar (~48sp) khusus untuk layar ini.
- **Action Buttons**: 3 tombol sejajar horizontal (`Row` + `Expanded`/`Spacer`) — tombol tengah (Start/Pause) lebih besar dan menonjol memakai `kAccentColor` (bentuk lingkaran/`FloatingActionButton`-style), tombol Reset dan Lap berbentuk outline lebih kecil di kiri-kanan.
- **Lap List**: `Expanded(child: ListView.builder(reverse: true, ...))` agar lap terbaru muncul di atas; setiap item lap menampilkan nomor lap dan waktu split.

### 4.5 `WorkoutCrudScreen`

```
┌───────────────────────────────┐
│  AppBar: "Jadwal Workout"       │
├───────────────────────────────┤
│  StreamBuilder<QuerySnapshot>    │
│                                 │
│  ┌───────────────────────┐    │
│  │ 🏃 Lari Pagi             │  │
│  │ Kardio • 30 menit          │  │
│  │ 14 Sep 2026     [✏️][🗑️] │  │
│  └───────────────────────┘    │
│  ┌───────────────────────┐    │
│  │ 🏋️ Angkat Beban          │  │
│  │ ...                       │  │
│  └───────────────────────┘    │
│                                 │
│                          (＋) FAB │
└───────────────────────────────┘
```
- **Daftar**: `StreamBuilder` membungkus `ListView.builder`; tiap item berupa `Card` (`borderRadius: 16`, `shadowSoft`) menampilkan ikon kategori, nama latihan (`AppTextStyles.h2`), badge kategori + durasi (`AppTextStyles.caption`), tanggal (`AppTextStyles.caption`, `kTextMuted`), dan dua ikon aksi kecil (edit → buka `WorkoutFormSheet` mode edit; hapus → `ConfirmationDialog`).
- **FAB**: `FloatingActionButton` warna `kAccentColor`, ikon `Icons.add`, memicu `showModalBottomSheet` mode create.
- **Bottom Sheet Form (`WorkoutFormSheet`)**: `borderRadius: radiusLarge` di sudut atas, berisi `AppTextField` untuk Nama Latihan, dropdown Kategori, `InkWell` + `showDatePicker` untuk Tanggal, `AppTextField` numerik untuk Durasi, `AppTextField` multiline untuk Catatan (opsional), ditutup dengan `PrimaryButton` "Simpan".

### 4.6 `FitnessCalculatorScreen`, `AgeHijriScreen`, `CultureCalendarScreen`

Ketiga layar ini berbagi pola layout yang sama (*shared layout pattern*) demi konsistensi:

```
┌───────────────────────────────┐
│  AppBar: [Judul Layar]          │
├───────────────────────────────┤
│  Card Form Input                 │
│   [AppTextField/DatePicker...]   │
│   [AppTextField/Dropdown...]     │
│   [PrimaryButton "Hitung"]       │
│                                 │
│  ── Hasil (muncul setelah hitung) ──│
│  ┌───────────────────────┐    │
│  │  Card Hasil (highlight)   │  │
│  │  Nilai Utama (Display)     │  │
│  │  Kategori/Keterangan       │  │
│  │  Rincian tambahan          │  │
│  └───────────────────────┘    │
└───────────────────────────────┘
```
- **`FitnessCalculatorScreen`**: dua section dalam satu layar (bisa via `TabBar` internal atau scroll berurutan) — Form BMI (berat, tinggi) dan Form BMR (berat, tinggi, usia, gender via `SegmentedButton`, aktivitas via `DropdownButtonFormField`). Kartu hasil menampilkan angka besar + kategori dengan warna indikator (`kSuccessColor` untuk Normal, `kAccentColor`/oranye untuk kategori perhatian).
- **`AgeHijriScreen`**: input tanggal lahir via `showDatePicker`, kartu hasil menampilkan tanggal Hijriah serta 6 kotak kecil (grid `Tahun-Bulan-Hari-Jam-Menit-Detik`) yang diperbarui setiap detik (`Timer.periodic` + `setState` terlokalisasi menggunakan `ValueListenableBuilder` agar rebuild tidak membebani seluruh layar).
- **`CultureCalendarScreen`**: input tanggal lahir, kartu hasil menampilkan dua sub-kartu bersebelahan atau bertumpuk — "Weton Jawa" (nama hari + pasaran, nilai Neptu ditonjolkan dengan badge bulat warna `kAccentColor`) dan "Kalender Saka Bali" (tahun/tanggal Saka).

### 4.7 `HelpScreen`

```
┌───────────────────────────────┐
│  AppBar: "Bantuan"               │
├───────────────────────────────┤
│  Tentang Aplikasi (Card)          │
│   FitCalculate v1.0                │
│   Tim Pengembang...                │
│                                 │
│  Panduan Fitur (ExpansionTile x5)  │
│   ▸ Cara menggunakan Kalkulator BMI │
│   ▸ Cara menambah jadwal workout    │
│   ▸ ...                            │
│                                 │
│  ┌───────────────────────┐    │
│  │   🚪 Keluar (DangerButton) │  │
│  └───────────────────────┘    │
└───────────────────────────────┘
```
- **FAQ/Panduan**: menggunakan `ExpansionTile` per fitur agar ringkas namun informatif, ikon panah rotasi standar Flutter.
- **Tombol Logout**: `DangerButton` (warna `kErrorColor`, teks putih, ikon `Icons.logout`) diletakkan di bagian bawah layar dengan jarak aman dari elemen lain, memicu `ConfirmationDialog` sebelum eksekusi `SessionService.logout()` dan `Navigator.pushAndRemoveUntil`.

---

## 5. Database & Data Modeling

### 5.1 Skema Dokumen Firestore — Koleksi `workouts`

**Diagram Entitas (Single Collection, Non-Relational):**

```
┌─────────────────────────────────────────────┐
│                 workouts                       │
│           (Cloud Firestore Collection)          │
├─────────────────────────────────────────────┤
│ documentId : String   (auto-generated, PK)       │
│ namaLatihan : String                              │
│ kategori    : String  (enum-like: Kardio,           │
│               Angkat Beban, Yoga, Lainnya)          │
│ tanggal     : Timestamp                            │
│ durasiMenit : Number (int)                          │
│ catatan     : String (nullable)                     │
│ createdAt   : Timestamp (server-generated)           │
│ updatedAt   : Timestamp (server-generated)            │
└─────────────────────────────────────────────┘
```

| Field | Tipe Data Firestore | Wajib | Keterangan |
|---|---|---|---|
| `namaLatihan` | `string` | Ya | Nama kegiatan workout |
| `kategori` | `string` | Ya | Dipilih dari daftar tetap via dropdown UI |
| `tanggal` | `timestamp` | Ya | Tanggal rencana/pelaksanaan latihan |
| `durasiMenit` | `number` | Ya | Validasi UI: harus > 0 |
| `catatan` | `string` | Tidak | Boleh string kosong `""` |
| `createdAt` | `timestamp` | Ya (server) | Diisi otomatis via `FieldValue.serverTimestamp()` saat create |
| `updatedAt` | `timestamp` | Ya (server) | Diperbarui otomatis setiap kali dokumen diedit |

**Indeks:** Karena query utama hanya melakukan `orderBy('tanggal', descending: true)` tanpa kombinasi `where` + `orderBy` pada field berbeda, Firestore secara otomatis menyediakan *single-field index* default — **tidak diperlukan indeks komposit tambahan** pada rilis ini. Jika ke depannya ditambahkan filter kategori (`where('kategori', isEqualTo: ...)` dikombinasikan `orderBy('tanggal')`), tim perlu membuat *composite index* melalui Firebase Console.

**Relasi:** Koleksi `workouts` bersifat *flat/global* (tidak memiliki relasi ke koleksi `users` lain) karena proyek ini sengaja tidak mengimplementasikan Firebase Authentication (lihat Out-of-Scope pada `PRD.md`). Seluruh pengguna aplikasi membaca dan menulis pada koleksi yang sama.

### 5.2 Skema Key-Value Lokal — `shared_preferences`

| Key | Tipe | Contoh Nilai | Deskripsi |
|---|---|---|---|
| `isLoggedIn` | `bool` | `true` / `false` | Status sesi login aktif, dicek saat *gatekeeper* |
| `username` | `String` | `"Aditya"` | Nama pengguna yang ditampilkan di header `HomeScreen` |

> Prinsip desain: `shared_preferences` **tidak** digunakan untuk menyimpan data yang bersifat terstruktur/banyak (seperti daftar workout) — hanya untuk flag/nilai sesi sederhana, sesuai batasan arsitektur pada `PRD.md` Bab 8.3.

---

## 6. Error Handling & Edge Cases UI States

Setiap layar yang memuat data asinkron (khususnya `WorkoutCrudScreen`) wajib menangani **empat kondisi UI state** berikut secara eksplisit melalui `StreamBuilder`/`FutureBuilder`:

| State | Kondisi Pemicu | Desain Visual |
|---|---|---|
| **Loading State** | `snapshot.connectionState == ConnectionState.waiting` | `Center(child: CircularProgressIndicator(color: kPrimaryColor))`. Alternatif lanjutan: skeleton/shimmer placeholder berbentuk kartu abu-abu berdenyut untuk pengalaman lebih halus, jika waktu pengembangan memungkinkan. |
| **Empty State** | `snapshot.hasData && snapshot.data.docs.isEmpty` | Ilustrasi ikon besar (`Icons.fitness_center_outlined`, ukuran 64, warna `kTextMuted`), teks "Belum ada jadwal workout" (`AppTextStyles.h2`), subteks "Tekan tombol + untuk menambahkan" (`AppTextStyles.caption`), seluruhnya terpusat vertikal-horizontal di layar. |
| **Error State** | `snapshot.hasError` (misal: Firestore disconnect, permission denied) | Menggunakan komponen `ErrorBox` (lihat 2.4e) ditambah tombol "Coba Lagi" (`PrimaryButton` outline) yang memicu rebuild `StreamBuilder`. Pesan disederhanakan untuk pengguna awam (contoh: "Gagal memuat data. Periksa koneksi internet Anda.") — bukan menampilkan `error.toString()` mentah. |
| **Form Validation State** | Input kosong/tidak valid saat submit form (Login, Workout Form, Kalkulator) | Border `AppTextField` berubah merah (`kErrorColor`), `errorText` inline muncul di bawah field terkait (`AppTextStyles.caption` merah), tombol submit tetap dapat ditekan namun akan menampilkan error alih-alih melanjutkan proses (validasi dilakukan sebelum pemanggilan service). |

### 6.1 Tabel Skenario Edge Case Tambahan

| Skenario | Penanganan UI |
|---|---|
| Input numerik non-angka pada Berat/Tinggi/Durasi | `TextInputType.numberWithOptions(decimal: true)` + validator menolak submit, `errorText`: "Masukkan angka yang valid" |
| Tanggal lahir belum dipilih saat submit Kalkulator Umur/Weton | Tombol "Hitung" menampilkan `ErrorBox` ringkas: "Silakan pilih tanggal lahir terlebih dahulu" |
| Koneksi internet terputus saat proses simpan/hapus Firestore | `try-catch` pada pemanggilan service, tampilkan `SnackBar` merah singkat: "Gagal menyimpan, periksa koneksi Anda" tanpa menutup form (agar input tidak hilang) |
| Sesi `shared_preferences` gagal terbaca (null/corrupt) saat gatekeeper | Diperlakukan sebagai `isLoggedIn = false` (fail-safe default) → arahkan ke `LoginScreen` |
| Dokumen workout dihapus oleh proses lain saat pengguna sedang membuka form edit | Saat submit update gagal (dokumen tidak ditemukan), tampilkan dialog informasi: "Data ini sudah tidak tersedia" dan tutup form otomatis, kembali ke daftar yang sudah ter-update via `StreamBuilder` |

---

## 7. Ringkasan Prinsip Desain

1. **Konsistensi Token di Atas Segalanya** — seluruh warna, radius, dan tipografi wajib merujuk pada `core/constants/`, tidak ada nilai hardcoded baru di level widget individual.
2. **Realtime-First untuk Data Workout** — seluruh interaksi baca data workout menggunakan `StreamBuilder`, bukan `FutureBuilder`, agar sesuai filosofi Cloud Firestore yang reaktif.
3. **Fail-Safe Session Handling** — setiap potensi kegagalan pembacaan sesi lokal diperlakukan sebagai "belum login" demi keamanan alur navigasi.
4. **UI Ramah Pengguna Awam** — pesan error selalu diterjemahkan ke bahasa manusia yang jelas, bukan menampilkan detail teknis/exception mentah ke pengguna akhir.
5. **Aksi Destruktif Selalu Dikonfirmasi** — hapus data dan logout wajib melalui `ConfirmationDialog` untuk mencegah kesalahan tidak disengaja.

---

**Disusun oleh:** Kelompok FitCalculate — Pemrograman Aplikasi Mobile
**Anggota:** Aditya Fadilah R.A (124240062), Akbar Maulana Setiawan (124240079), Azhicry Vernando E.P (124240069), Damar Nugroho (124240073)
**Dokumen Terkait:** `PRD.md`

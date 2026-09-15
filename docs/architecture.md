# ARCHITECTURE.md
## FitCalculate — System Rules & Context Guardrails untuk AI Coding Assistant

> **Tujuan dokumen ini**: menjadi acuan wajib (*ground truth*) bagi AI coding assistant maupun anggota tim saat menulis/mengubah kode. Dokumen ini **membatasi**, bukan menginspirasi — jika ada instruksi yang bertentangan dengan dokumen ini, dokumen ini yang menang kecuali disebutkan eksplisit sebaliknya oleh pengguna.

---

## 1. Architectural Principles & Simplicity First

### 1.1 Prinsip Kesederhanaan (KISS)
- Proyek ini adalah tugas kuliah dengan 4 kontributor pemula–menengah. **Kesederhanaan mengalahkan kecanggihan.**
- Pola arsitektur: **Simple Layered** — `UI Screen → Service → Backend/Storage`. Tidak ada layer tambahan (repository abstraction, use-case, domain layer, dependency injection container).
- Satu fitur = satu file screen + pemanggilan langsung ke service terkait. Tidak perlu membuat interface/abstract class untuk service yang hanya punya satu implementasi.

### 1.2 Larangan Tegas
| Dilarang | Alasan |
|---|---|
| Menambahkan `flutter_bloc`, `riverpod`, `get`, `provider`, `mobx`, atau state management pihak ketiga apa pun | Cukup `StatefulWidget` + `setState` + `StreamBuilder` bawaan Flutter |
| Membuat dependency injection (`get_it`, `injectable`, dsb.) | Tidak diperlukan untuk skala proyek ini |
| Membuat layer `Repository`, `UseCase`, `Bloc/Cubit`, `Controller` terpisah | Service layer (`lib/core/services/`) sudah cukup sebagai satu-satunya perantara data |
| Mengubah pola navigasi menjadi `go_router`/`auto_route` | `Navigator.push` bawaan sudah memadai untuk 3 tab + beberapa sub-layar |
| Menambahkan package baru tanpa diminta eksplisit oleh pengguna | Setiap dependensi baru adalah keputusan sadar, bukan otomatis dari AI |

### 1.3 Definisi "Selesai"
Kode dianggap selesai jika: (1) fitur berjalan sesuai `PRD.md`, (2) tidak menambah kerumitan yang tidak diminta, (3) konsisten dengan pola file yang sudah ada di proyek.

---

## 2. Directory & File Placement Standards

### 2.1 Struktur Direktori Resmi (Tidak Boleh Diubah tanpa Instruksi Eksplisit)

```
lib/
├── main.dart                     # Entry point, Firebase.initializeApp(), root MaterialApp
├── core/
│   └── services/
│       ├── session_service.dart      # SEMUA logic shared_preferences
│       └── firestore_service.dart    # SEMUA logic CRUD Firestore koleksi workouts
├── data/
│   └── app_data.dart              # Konstanta warna (kPrimaryColor, dll.), data statis anggota kelompok
├── widgets/
│   └── shared_widgets.dart        # SEMUA komponen UI reusable (tombol, card menu, dialog, error box)
├── models/
│   └── workout_model.dart         # Model data (opsional, jika tidak pakai Map<String,dynamic> langsung)
└── screens/
    ├── login_screen.dart
    ├── main_shell_screen.dart     # BottomNavigationBar root
    ├── home_screen.dart
    ├── data_kelompok_screen.dart
    ├── fitness_calculator_screen.dart
    ├── workout_crud_screen.dart
    ├── age_hijri_screen.dart
    ├── culture_calendar_screen.dart
    ├── stopwatch_screen.dart
    └── help_screen.dart
```

### 2.2 Aturan Penempatan File Baru

| Jenis Kode | Wajib Ditaruh Di | Contoh |
|---|---|---|
| Layar/halaman baru (punya `Scaffold`) | `lib/screens/<nama>_screen.dart` | `workout_form_screen.dart` |
| Widget reusable (dipakai ≥ 2 layar) | Ditambahkan ke `lib/widgets/shared_widgets.dart` (jangan buat file baru per-widget kecuali file ini sudah terlalu besar) | Fungsi/class baru di file yang sama |
| Logic akses Firestore | Method baru di `lib/core/services/firestore_service.dart` | `getWorkouts()`, `addWorkout()`, `updateWorkout()`, `deleteWorkout()` |
| Logic sesi/login | Method baru di `lib/core/services/session_service.dart` | `login()`, `logout()`, `isLoggedIn()`, `getUsername()` |
| Warna, teks statis, data anggota kelompok | `lib/data/app_data.dart` | `kPrimaryColor`, `kAccentColor`, `List<Anggota> daftarAnggota` |
| Model data terstruktur | `lib/models/<nama>_model.dart` | `WorkoutModel` dengan `fromMap()`/`toMap()` |
| Fungsi kalkulasi murni (BMI, BMR, Weton, Saka, Hijriah) | Boleh sebagai method statis di dalam screen terkait **atau** file helper baru di `lib/core/` **hanya jika** dipakai lebih dari satu screen — tanyakan ke pengguna jika ragu, jangan berasumsi | `calculateBMI()`, `calculateNeptu()` |

**Aturan emas**: jika AI tidak yakin di mana menaruh kode baru, **ikuti pola file yang paling mirip yang sudah ada**, jangan membuat struktur folder baru sendiri.

### 2.3 Standar Import

- **Wajib** menggunakan package import, **dilarang** relative import berlapis (`../../`):
  ```dart
  // ✅ BENAR
  import 'package:fitcalculate/core/services/firestore_service.dart';
  import 'package:fitcalculate/data/app_data.dart';
  import 'package:fitcalculate/widgets/shared_widgets.dart';

  // ❌ SALAH — rawan broken path saat file dipindah
  import '../../core/services/firestore_service.dart';
  ```
- Import relative satu level (`import 'workout_form_screen.dart';` dalam folder yang sama) masih dapat ditoleransi, tetapi package import tetap prioritas utama, khususnya untuk lintas folder (`core/`, `data/`, `widgets/`, `models/` ke `screens/`).
- Cek nama package di `pubspec.yaml` (`name: fitcalculate`) sebelum menulis import — jangan menebak nama package.

---

## 3. Data Flow & State Handling Rules

### 3.1 Alur Autentikasi & Sesi

```
main.dart
   │
   ▼
Gatekeeper (di dalam main_shell_screen.dart atau widget Splash terpisah)
   │
   ▼
SessionService.isLoggedIn()  →  baca SharedPreferences key 'isLoggedIn'
   │
   ├── true  → MainShellScreen (BottomNavigationBar)
   └── false → LoginScreen
                    │
                    ▼
             SessionService.login(username)
                    │
                    ▼
             Navigator.pushReplacement → MainShellScreen

Logout:
HelpScreen → tombol Logout → dialog konfirmasi → SessionService.logout()
   → Navigator.pushAndRemoveUntil(..., (route) => false) → LoginScreen
```

**Aturan wajib:**
- Seluruh baca/tulis `SharedPreferences` **hanya** boleh terjadi di dalam `session_service.dart`. Screen tidak boleh memanggil `SharedPreferences.getInstance()` secara langsung.
- Gatekeeper check dilakukan **satu kali** di titik masuk aplikasi (bukan di setiap screen).

### 3.2 Alur Data Realtime CRUD Workout

```
Firestore (collection: workouts)
        │  .snapshots()
        ▼
FirestoreService.getWorkoutStream()  →  return Stream<QuerySnapshot>
        │
        ▼
StreamBuilder di dalam workout_crud_screen.dart
        │
        ├── ConnectionState.waiting     → tampilkan CircularProgressIndicator
        ├── snapshot.hasError           → tampilkan ErrorBox (shared_widgets.dart)
        ├── docs kosong                 → tampilkan Empty State
        └── docs ada                    → ListView.builder → Card per workout
```

**Aturan wajib — Pemisahan Tanggung Jawab:**
- **UI/Screen dilarang keras memanggil `FirebaseFirestore.instance` secara langsung.** Semua akses database (read/write/update/delete) **harus** melalui method di `firestore_service.dart`.
  ```dart
  // ✅ BENAR — dipanggil dari screen
  FirestoreService.addWorkout(data);

  // ❌ SALAH — akses langsung dari screen
  FirebaseFirestore.instance.collection('workouts').add(data);
  ```
- `firestore_service.dart` minimal menyediakan: `getWorkoutStream()`, `addWorkout(Map data)`, `updateWorkout(String id, Map data)`, `deleteWorkout(String id)`.
- Konsisten gunakan `StreamBuilder` untuk daftar (read realtime). Jangan campur dengan `FutureBuilder` untuk kasus yang sama kecuali ada kebutuhan spesifik (misal: one-time fetch untuk export).

### 3.3 State Management Lokal (dalam satu screen)

- Gunakan `StatefulWidget` + `setState()` untuk state UI sederhana: nilai input form, hasil kalkulasi, status loading tombol, waktu stopwatch.
- **Tidak perlu** mengangkat (*lift*) state ke atas atau membuat shared state antar-screen kecuali data sesi (yang sudah ditangani `SessionService`) atau data workout (yang sudah reaktif via `StreamBuilder`).
- `TextEditingController` wajib di-`dispose()` di method `dispose()` setiap `StatefulWidget` yang memakainya.

---

## 4. Design System & Coding Guardrails (Rules for AI)

### 4.1 Wajib Pakai Konstanta yang Sudah Ada

- **Dilarang** menulis warna heksadesimal baru (`Color(0xFF...)`) langsung di dalam widget/screen. **Selalu** rujuk ke konstanta di `lib/data/app_data.dart`.
  ```dart
  // ✅ BENAR
  color: kPrimaryColor,

  // ❌ SALAH
  color: Color(0xFF1E3A8A),
  ```
- Jika butuh warna/style baru yang belum ada di `app_data.dart` (misal warna error/danger), **tambahkan sebagai konstanta baru di file tersebut terlebih dahulu**, jangan hardcode di lokasi pemakaian.
- Konstanta visual yang sudah baku dan **tidak boleh diubah nilainya** tanpa instruksi eksplisit:
  `kPrimaryColor` (`#1E3A8A`), `kPrimaryDark` (`#14265C`), `kAccentColor` (`#F97316`), `kBackgroundColor` (`#F2F4FA`), `kSuccessColor` (`#16A34A`), `kTextMuted` (`#475569`).
- Radius kartu/tombol konsisten di rentang `12–16`, bayangan lembut `BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8–10)` — pakai ulang pola ini, jangan bikin varian shadow baru per-widget.

### 4.2 Aturan Perubahan Kode (Anti Over-Engineering)

| Aturan | Detail |
|---|---|
| **Jangan merombak kode yang sudah berjalan** | Jika suatu fitur sudah berfungsi, AI hanya boleh menambah/memperbaiki bagian yang diminta — dilarang me-refactor struktur file, rename class, atau mengubah pola yang sudah ada tanpa instruksi eksplisit dari pengguna |
| **Jangan menambah abstraksi "untuk jaga-jaga"** | Tidak perlu membuat interface, factory pattern, atau generic wrapper untuk kasus yang saat ini hanya punya satu kebutuhan konkret |
| **Perubahan bersifat minimal-diff** | Prioritaskan `str_replace`/edit pada bagian spesifik dibanding menulis ulang seluruh file, kecuali file memang baru dibuat |
| **Jangan menambah dependency baru secara sepihak** | Jika suatu fitur butuh package baru (mis. `hijri`, `intl`), sebutkan ke pengguna dan minta konfirmasi sebelum menambah ke `pubspec.yaml`, kecuali sudah tercantum sebagai keputusan resmi di `PRD.md` |
| **Ikuti gaya penamaan yang sudah ada** | `camelCase` untuk variabel/fungsi, `PascalCase` untuk class/widget, `snake_case` untuk nama file — konsisten dengan konvensi Dart resmi dan pola file eksisting |

### 4.3 Error Handling & Validasi — Standar Wajib

**Sebelum kalkulasi (BMI/BMR/Umur/Weton/Saka):**
- Validasi input tidak kosong dan bertipe numerik/tanggal valid **sebelum** menjalankan rumus kalkulasi.
- Tampilkan pesan error inline pada field terkait (bukan hanya `print()`/`debugPrint()` ke console) menggunakan komponen error dari `shared_widgets.dart`.

**Sebelum kirim ke Firestore (Create/Update):**
- Validasi field wajib (nama latihan, tanggal, durasi > 0) sebelum memanggil `FirestoreService`.
- Bungkus pemanggilan service dengan `try-catch`; jika gagal, tampilkan `SnackBar` atau `ErrorBox` singkat — **jangan** tampilkan `error.toString()` mentah ke pengguna.

**Loading & Koneksi Kosong:**
- Setiap `StreamBuilder`/`FutureBuilder` wajib menangani 3 kondisi minimal: `waiting` (loading indicator), `hasError` (error state), dan `data kosong` (empty state) — lihat pola di Bab 3.2.
- Tidak boleh ada layar yang menampilkan blank/putih polos saat data belum siap.

### 4.4 Checklist Cepat Sebelum AI Menyelesaikan Task

- [ ] File baru ditaruh sesuai Bab 2.2?
- [ ] Import pakai `package:fitcalculate/...`, bukan `../../`?
- [ ] Tidak ada warna hex baru di luar `app_data.dart`?
- [ ] Akses Firestore hanya lewat `FirestoreService`, akses sesi hanya lewat `SessionService`?
- [ ] Tidak menambah library state management/DI baru?
- [ ] Ada validasi input & penanganan loading/error/empty state?
- [ ] Tidak mengubah kode/fitur lain yang tidak diminta?

---

**Dokumen terkait:** `PRD.md`, `DESIGN.md`
**Status:** Dokumen ini adalah acuan mengikat (*binding reference*) selama pengembangan berlangsung, kecuali direvisi ulang secara eksplisit oleh tim.

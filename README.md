<div align="center">
  <img src="assets/icon/icon.png" width="112" alt="Logo JedaSuara">
  <h1>JedaSuara</h1>
  <p><strong>Jurnal harian privat dengan konteks lokasi dan cuaca.</strong></p>
  <p>
    <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter 3.x">
    <img src="https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart&logoColor=white" alt="Dart 3.12+">
    <img src="https://img.shields.io/badge/State-Riverpod-6B4EFF" alt="Riverpod">
    <img src="https://img.shields.io/badge/Weather-Open--Meteo-2E7D32" alt="Open-Meteo">
  </p>
</div>

JedaSuara adalah aplikasi Flutter untuk menulis dan mengelola jurnal pribadi di
perangkat. Seluruh catatan, sesi, preferensi tema, dan draft disimpan secara
lokal menggunakan `SharedPreferences`. Aplikasi tidak membutuhkan akun atau
backend. Koneksi internet hanya digunakan saat pengguna meminta cuaca di
lokasinya.

> **Status:** aplikasi demonstrasi/pembelajaran. Autentikasi dan penyimpanan
> lokal belum ditujukan sebagai perlindungan data sensitif untuk production.

## Fitur utama

- Autentikasi lokal menggunakan username dan PIN empat digit.
- Sesi tersimpan dan pengguna dapat masuk otomatis setelah aplikasi dibuka ulang.
- Penguncian selama 30 detik setelah lima kali percobaan PIN yang salah.
- Membuat, membaca, memperbarui, dan menghapus catatan.
- Menyematkan catatan penting serta mencari catatan berdasarkan teks.
- Filter catatan berdasarkan mood: bahagia, netral, atau sedih.
- Penyimpanan draft otomatis dengan debounce 500 milidetik.
- Statistik jurnal: total catatan, catatan minggu ini, jumlah kata, streak,
  distribusi mood, dan aktivitas tujuh hari terakhir.
- Tema terang, gelap, dan mengikuti pengaturan sistem.
- Lokasi dan cuaca yang bersifat opsional serta baru meminta permission setelah
  pengguna menekan **Gunakan lokasi**.
- Kondisi cuaca, suhu terasa, kelembapan, dan kecepatan angin dari Open-Meteo
  tanpa API key.
- Penggantian PIN serta penghapusan seluruh catatan dari menu pengaturan.
- “Mood Scanner” dan “AI Penjaga” berbasis aturan lokal sebagai simulasi AI;
  tidak ada model AI atau API eksternal yang dipanggil.

## Akun demo

| Field | Nilai awal |
|---|---|
| Username | `admin` |
| PIN | `1234` |

PIN dapat diganti melalui menu **Pengaturan → Ganti PIN**.

## Teknologi

| Area | Implementasi |
|---|---|
| Framework | Flutter, Dart 3.12+ |
| State management & DI | `flutter_riverpod` |
| Penyimpanan lokal | `shared_preferences` |
| Format tanggal | `intl` |
| Lokasi perangkat | `geolocator` |
| Reverse geocoding | `geocoding` dengan layanan native perangkat |
| Cuaca | Open-Meteo Forecast API melalui `http` |
| Arsitektur | Feature-first Clean Architecture |
| Testing | `flutter_test`, `mocktail` |
| Platform | Android dan iOS; scaffold Web juga tersedia |

## Arsitektur

Setiap fitur dipisahkan menjadi lapisan presentation, domain, dan data.
Dependensi dibuat melalui provider sehingga use case dan repository dapat diuji
tanpa bergantung langsung pada widget.

```text
Presentation
  Screen / Widget / Riverpod Notifier
                 │
                 ▼
Domain
  Entity / Repository Contract / Use Case / Service
                 │
                 ▼
Data
  Repository Implementation / Local Data Source
                 │
                 ▼
SharedPreferences
```

Struktur utama:

```text
lib/
├── core/
│   ├── di/                 # Composition root dan providers
│   ├── error/              # Failure model
│   ├── storage/            # SharedPreferences provider
│   ├── theme/              # Theme dan palette
│   └── utils/              # Utility bersama
├── features/
│   ├── auth/               # Login, sesi, lockout, ganti PIN
│   ├── home/               # Shell dan bottom navigation
│   ├── notes/              # CRUD, draft, mood, statistik
│   ├── settings/           # Tema dan pengaturan data
│   ├── splash/             # Splash dan bootstrap
│   └── weather/            # Lokasi, reverse geocoding, dan Open-Meteo
├── l10n/                   # Resource localization
├── app.dart
└── main.dart
```

## Menjalankan aplikasi

### Prasyarat

- Flutter SDK yang kompatibel dengan Dart `^3.12.2`.
- Xcode untuk menjalankan target iOS.
- Android Studio/Android SDK untuk target Android.

Periksa environment:

```bash
flutter doctor
flutter devices
```

Install dependency dan jalankan aplikasi:

```bash
flutter pub get
flutter run
```

Untuk memilih perangkat tertentu:

```bash
flutter run -d <device-id>
```

Saat fitur cuaca pertama kali dipakai, izinkan akses lokasi **saat aplikasi
digunakan**. Aplikasi tidak meminta lokasi background. Simulator iOS dapat
memakai lokasi simulasi dari menu **Features → Location**.

## Quality gate

Jalankan pemeriksaan berikut sebelum membuat commit atau pull request:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Test yang tersedia mencakup:

- alur login, logout, auto-login, validasi, dan lockout;
- perubahan PIN;
- penyimpanan serta pemulihan catatan dan draft;
- deteksi mood berbasis aturan;
- statistik, streak, dan aktivitas tujuh hari terakhir;
- pencarian dan filter mood pada widget;
- parsing respons cuaca dan pemetaan kode kondisi WMO.

Coverage dapat dibuat dengan:

```bash
flutter test --coverage
```

## Build

Android APK:

```bash
flutter build apk --release
```

iOS:

```bash
flutter build ios --release
```

Build iOS memerlukan konfigurasi signing yang valid pada Xcode.

## Data dan keamanan

- Catatan, PIN, sesi, dan draft tetap berada di perangkat dan tidak dikirim ke
  layanan cuaca.
- Koordinat dikirim ke Open-Meteo hanya setelah pengguna menekan **Gunakan
  lokasi** atau tombol refresh. Open-Meteo tidak memerlukan API key.
- Nama wilayah diperoleh melalui reverse geocoding native Android/iOS. Jika
  nama tidak tersedia, aplikasi menampilkan koordinat sebagai fallback.
- Fitur jurnal tetap dapat digunakan tanpa izin lokasi dan tanpa internet.
- Catatan disimpan sebagai JSON di `SharedPreferences` dan **tidak terenkripsi**.
- Username, PIN, serta token sesi merupakan autentikasi demo lokal.
- Jangan gunakan aplikasi ini untuk menyimpan data sangat sensitif tanpa
  mengganti storage dengan solusi terenkripsi seperti Keychain/Keystore dan
  encrypted database.
- Menghapus data aplikasi dari pengaturan perangkat akan menghapus seluruh
  catatan, sesi, draft, dan preferensi lokal.

## Sumber data terbuka

- Cuaca: [Open-Meteo Forecast API](https://open-meteo.com/en/docs), tanpa API
  key untuk penggunaan nonkomersial sesuai ketentuan layanan.
- Kode kondisi cuaca menggunakan interpretasi WMO yang disediakan Open-Meteo.

## Dokumentasi proyek

- [`PRD_2_Mini_POS_Cafe.md`](PRD_2_Mini_POS_Cafe.md) adalah artefak latihan
  penulisan PRD yang terpisah; dokumen tersebut bukan spesifikasi JedaSuara.
- Source of truth perilaku aplikasi saat ini adalah implementasi di `lib/` dan
  automated test di `test/`.

## Kontribusi

1. Buat branch dari `main`.
2. Kerjakan satu perubahan yang terfokus.
3. Jalankan formatter, analyzer, dan seluruh test.
4. Buat pull request dengan ringkasan perubahan serta bukti verifikasi.

Jangan commit credential, signing key, file `.env`, atau data jurnal pengguna.

# shop_fe

Monorepo Flutter untuk toko: **CMS** (web, khusus admin) dan **Kasir** (Android/iOS, offline-first).
Arsitektur dan keputusan teknis ada di [CLAUDE.md](CLAUDE.md), sistem visual di [DESIGN.md](DESIGN.md).

## Prasyarat

- Flutter 3.47.x (Dart 3.13), dicek dengan `flutter --version`
- Chrome (untuk CMS), Android Studio + emulator atau HP Android, Xcode untuk iOS
- Backend `Shop_project_be` berjalan (lihat langkah 1)

## 1. Jalankan backend

Di repo `Shop_project_be`:

```bash
cp .config.example.yaml .config.development.yaml   # isi database, redis, jwt
make docker-up                                     # API di http://localhost:3030
make docker-create-admin                           # buat akun superadmin untuk CMS
```

Supaya login CMS bisa memakai cookie refresh, tambahkan origin CMS di `.config.development.yaml`, lalu jalankan ulang backend:

```yaml
server:
  cms_origins: ["http://localhost:5173"]
```

Akun staff untuk kasir dibuat dari CMS (menu Staff → Tambah staff).

## 2. Siapkan monorepo

```bash
cd ~/Documents/shop_fe
flutter pub get
dart run melos run gen_l10n
dart run melos run build_runner
```

`gen_l10n` dan `build_runner` cukup diulang setelah mengubah file ARB, entity freezed, atau tabel drift.

## 3. Atur alamat API

Edit `apps/cms/.env.dev` dan `apps/kasir/.env.dev`:

| Dijalankan di | `API_BASE_URL` |
|---|---|
| CMS di Chrome, kasir di simulator iOS | `http://localhost:3030` |
| Kasir di emulator Android | `http://10.0.2.2:3030` |
| Kasir di HP sungguhan (Wi-Fi yang sama) | `http://<IP-laptop>:3030` |

`.env.prod` berisi alamat API produksi. File `.env` ikut ter-bundle, jadi jangan isi rahasia.

## 4. Jalankan CMS (web)

```bash
cd apps/cms
flutter run -d chrome --web-port 5173 -t lib/main_dev.dart
```

Port 5173 harus sama dengan `cms_origins` di backend. Masuk dengan akun superadmin; akun staff ditolak.

## 5. Jalankan Kasir (Android/iOS)

```bash
cd apps/kasir
flutter devices                          # lihat id device/emulator
flutter run -d <device-id> -t lib/main_dev.dart
```

- Notifikasi pembayaran (FCM) baru aktif setelah `dart pub global activate flutterfire_cli && flutterfire configure` untuk project Firebase `pos-app-51cb3`. Tanpa itu app tetap jalan dan push dilewati.
- iOS di device butuh Development Team di Xcode: `open ios/Runner.xcworkspace` → target Runner → Signing & Capabilities.
- Printer Bluetooth, scan kamera, dan sync terjadwal hanya bisa dicoba di HP sungguhan.

## Build rilis

```bash
cd apps/cms && flutter build web -t lib/main_prod.dart        # hasil di apps/cms/build/web
cd apps/kasir && flutter build apk -t lib/main_prod.dart      # Android
cd apps/kasir && flutter build ipa -t lib/main_prod.dart      # iOS, butuh signing
```

## Test dan pengecekan

```bash
dart run melos run analyze
dart run melos run test
dart run melos run coverage    # gagal kalau layer domain/data/bloc < 80%
cd apps/kasir && flutter test integration_test -d <device-id>   # alur offline → sync dan multi-tab di device
```

## Masalah umum

| Gejala | Penyebab |
|---|---|
| CMS: login berhasil tapi setelah reload kembali ke halaman login | `cms_origins` belum berisi `http://localhost:5173`, atau port `flutter run` berbeda |
| Kasir: "Tidak ada koneksi" padahal backend jalan | `API_BASE_URL` masih `localhost` di emulator Android atau HP |
| `Waiting for another flutter command to release the startup lock` | Ada perintah flutter lain yang masih jalan; tunggu atau hentikan dulu |
| Error `part '...freezed.dart'` tidak ditemukan | Jalankan `dart run melos run build_runner` |

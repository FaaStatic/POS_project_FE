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

Semua perintah di bawah dijalankan dari root `shop_fe`, tanpa masuk ke folder app.

```bash
cd ~/Documents/shop_fe
flutter pub get
dart run melos run setup        # gen_l10n + build_runner
```

Ulangi `setup` setelah mengubah file ARB, entity freezed, atau tabel drift.

Supaya bisa mengetik `melos run ...` saja (tanpa `dart run`), pasang sekali:

```bash
dart pub global activate melos 8.9.0
```

Contoh di bawah memakai `melos run`; `dart run melos run` hasilnya sama.

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
melos run cms
```

Membuka Chrome di port 5173 (harus sama dengan `cms_origins` di backend). Masuk dengan akun superadmin; akun staff ditolak.

Pakai Brave atau browser Chromium lain: arahkan `CHROME_EXECUTABLE` ke browser itu (sekali, di `~/.zshrc`). `flutter devices` lalu menampilkannya sebagai `chrome`.

```bash
export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
```

Kalau di Brave login hilang setelah reload, matikan Shields untuk `localhost`.

## 5. Jalankan Kasir (Android/iOS)

```bash
flutter devices                         # lihat id device/emulator
melos run kasir -- -d <device-id>       # contoh: melos run kasir -- -d emulator-5554
```

Argumen untuk Flutter ditulis setelah `--`; tanpa `-d`, Flutter memakai device yang terhubung atau menanyakannya.

- Firebase (FCM) sudah dikonfigurasi untuk project `pos-app-51cb3` (`lib/firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist`). Untuk mengulang setelah ganti app ID: `flutterfire configure` di `apps/kasir`.
- iOS di device butuh Development Team di Xcode: `open apps/kasir/ios/Runner.xcworkspace` → target Runner → Signing & Capabilities.
- Printer Bluetooth, scan kamera, dan sync terjadwal hanya bisa dicoba di HP sungguhan.

## Hot reload

Melos tidak meneruskan ketikan keyboard ke `flutter run`, jadi tombol `r`/`R` tidak bisa diandalkan. Dari terminal kedua:

```bash
melos run kasir-reload      # hot reload
melos run kasir-restart     # hot restart
melos run cms-reload
melos run cms-restart
```

Script ini mengirim sinyal ke proses `flutter run` lewat pid file di `.dart_tool/`. Kalau lebih suka tombol `r`/`R`, jalankan dari IDE atau langsung `flutter run` di folder app.

## Build rilis

```bash
melos run build-cms     # web, hasil di apps/cms/build/web
melos run build-apk     # Android
melos run build-ipa     # iOS, butuh signing
```

## Test dan pengecekan

```bash
melos run analyze
melos run test
melos run coverage                          # gagal kalau layer domain/data/bloc < 80%
melos run integration -- -d <device-id>     # kasir: alur offline → sync dan multi-tab di device
melos run                                   # daftar semua script
```

## Masalah umum

| Gejala | Penyebab |
|---|---|
| CMS: login berhasil tapi setelah reload kembali ke halaman login | `cms_origins` belum berisi `http://localhost:5173`, atau port `flutter run` berbeda |
| Kasir: "Tidak ada koneksi" padahal backend jalan | `API_BASE_URL` masih `localhost` di emulator Android atau HP |
| `Waiting for another flutter command to release the startup lock` | Ada perintah flutter lain yang masih jalan; tunggu atau hentikan dulu |
| Error `part '...freezed.dart'` tidak ditemukan | Jalankan `melos run setup` |
| `melos: command not found` | Pakai `dart run melos run ...` atau pasang global (langkah 2) |
| `Could not find an option named "-d"` | Argumen Flutter harus setelah `--`: `melos run kasir -- -d <id>` |

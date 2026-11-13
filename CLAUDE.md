# shop_fe

Monorepo Flutter: `apps/cms` (web, super saja), `apps/kasir` (Android/iOS, offline-first), `packages/core`, `packages/ui`.
PRD: `~/Documents/prd/flutter-cms-kasir.md`. Konteks produk: `~/Documents/prd/PRODUCT.md`. Backend kontrak: `~/Documents/be_shop` (branch `dev`, `swagger.json` + `internal/dto`).

## Perintah

```
flutter pub get                       # di root, satu resolusi untuk seluruh workspace
dart run melos run gen_l10n           # ARB -> lib/l10n/*.dart
dart run melos run build_runner       # freezed, json_serializable, drift
dart run melos run analyze
dart run melos run test
dart run melos run coverage           # gagal kalau domain/data/presentation/bloc < 80%
dart run melos run setup              # gen_l10n + build_runner
dart run melos run cms                # CMS di Chrome :5173
dart run melos run kasir -- -d <id>   # kasir di device
```

## Keputusan yang menyimpang dari PRD atau menambahkannya

- Flutter 3.50.0 terpasang (PRD 3.47.8), Dart 3.14. Diverifikasi di 3.50.0: `melos run analyze` (0 error, 0 warning), `melos run test` (core 208, ui 95, cms 177, kasir 200), build web CMS, APK debug dan iOS debug (`--no-codesign`) kasir. Constraint `build_runner ^2.16.1` dan `freezed ^4.0.1` tetap; `test_api` di lock naik ke 0.7.14.
- Android Gradle Plugin kasir 9.1.1 (`apps/kasir/android/settings.gradle.kts`), karena Flutter 3.50 menolak 9.1.0. Build Android masih memperingatkan dua hal yang belum dikerjakan: Kotlin 2.4.10 akan tidak didukung (minimal 2.4.20), dan plugin `firebase_core` serta `workmanager_android` masih memakai Kotlin Gradle Plugin (versi Flutter mendatang akan gagal build). Naikkan versi kedua plugin itu saat rilis yang mendukung Built-in Kotlin tersedia.
- Migrasi ke `material_ui`/`cupertino_ui` (`dart fix --apply --code=migrate_design_widgets`) sengaja belum dilakukan. `package:flutter/material.dart` deprecated sejak 3.50 (sekitar 144 info `deprecated_member_use`, tidak memblokir `analyze` karena `--no-fatal-infos`). Dicoba dan dikembalikan karena: `shadcn_ui` (0.57.3, terbaru 0.59.0) masih memakai tipe `ThemeMode` dari `flutter/material`, sehingga `ShadApp.themeMode` bentrok tipe; `go_router` (18.1.3) mendeteksi `MaterialApp` lama lewat `findAncestorWidgetOfExactType<MaterialApp>()`, jadi dengan `MaterialApp` dari `material_ui` jenis halaman dan `HeroController` dugaan berubah (belum dibuktikan); yang terbukti: dua test kasir gagal (`idle_frames_test`, debt tab di `app_flow_test`) karena route memakai transisi `_FadeForwardsPageTransition` yang masih berjalan setelah `pump` 1 detik (selesai di 1050 ms) dan `settle()` hanya memajukan 300 ms. Jembatan `MaterialUiCompatibilityBridge` tidak menyelesaikan kopling tipe seperti ini. Coba lagi setelah `shadcn_ui` dan `go_router` mendukung `material_ui`. `dart fix --apply` tanpa `--code` juga mengedit file generate `lib/l10n/*.dart` dan menulis constraint `any`; jangan dipakai mentah-mentah.
- Inter dibundel sebagai font asset di `packages/ui/fonts` (OFL), bukan lewat `google_fonts`, supaya kasir tetap punya font saat offline.
- Flavor kasir (native Android dan iOS): `dev`, `staging`, `prod`; dipilih dengan `--flavor <nama> -t lib/main_<nama>.dart`, dan `main_<nama>.dart` memuat `.env.<nama>` serta `firebase_options_<nama>.dart`. Tanpa `--flavor`, `flutter run/build` kasir gagal. Application ID Android `com.suhaili.cashier` (prod), `.dev`, `.staging`; iOS `com.suhaili.cashier-ios` (prod), `.dev`, `.staging`. Nama app `myKasir`, `myKasir-dev`, `myKasir-staging`: Android lewat `src/<flavor>/res/values/strings.xml` (bukan `resValue`, AGP 9 menolaknya), iOS lewat setting `APP_DISPLAY_NAME` per build configuration `Debug|Profile|Release-<flavor>`. Ikon dev dan staging memakai badge `DEV`/`STG` (`src/<flavor>/res/mipmap-*`, `AppIcon-dev`/`AppIcon-staging` di asset catalog), prod tidak berubah. Scheme Xcode bernama sama dengan flavor; tidak ada scheme `Runner`. CMS tidak memakai flavor: `main_dev.dart`/`main_prod.dart` memilih `.env.dev`/`.env.prod`.
- `.env.dev`, `.env.prod`, dan `.env.staging` tidak masuk git (`.gitignore` per app); hanya `.env.example` yang di-track. Semuanya dideklarasikan sebagai asset di `pubspec.yaml`, jadi tanpa file itu build dan test gagal: salin dari `.env.example` (CI melakukannya di `.github/workflows/ci.yml`). Isinya placeholder `API_BASE_URL` (host saja) dan `API_VERSION` (`v1`, `v2`, ...). Emulator Android butuh `http://10.0.2.2:<port>`.
- URL API: `{API_BASE_URL}/api/{API_VERSION}/{group}/{service}`, group `account|catalog|sales|insight` seperti backend. `AppConfig.apiUrl` menjadi base URL Dio, jadi `ApiPaths` hanya `/{group}/{service}/...` (relatif, tetap `const`, tanpa state global; isolate background kasir ikut benar karena membangun Dio dari config yang sama). `API_VERSION` harus sama dengan `server.api_version` backend; CI/CD menulis ulang barisnya di `.env.prod` lalu membangun ulang FE tiap versi server naik. Formatnya divalidasi (`^v[0-9]+$`), kosong berarti `v1`. Versi tidak cocok: backend menjawab 404 dengan pesan `api version not supported, use /api/vN`, yang tampil sebagai teks error. `url_pdf` dari server absolut (`/api/v1/insight/reports/x.pdf`); `ApiPaths.reportFile` menjadikannya relatif dan tidak membandingkan versinya.
- Firebase satu project `pos-app-51cb3` dengan satu app Android dan satu iOS per flavor kasir. Konfigurasi per flavor: `apps/kasir/android/app/src/<flavor>/google-services.json`, `apps/kasir/ios/config/<flavor>/GoogleService-Info.plist` (disalin ke bundle oleh build phase "Copy GoogleService-Info.plist" lewat `FLAVOR_NAME`), dan `apps/kasir/lib/firebase_options_<flavor>.dart` yang dioper `main_<flavor>.dart` ke `bootstrap`. App dev dan staging dibuat dengan `firebase apps:create` lalu `firebase apps:sdkconfig` (`flutterfire configure` macet di mesin ini). Flavor baru berarti app Firebase baru, ikon, string nama, dan build configuration iOS baru. Kalau Firebase gagal start, app tetap jalan dan push dimatikan.
- Jalankan app dari root: `melos run cms`, `melos run kasir -- -d <id>`; hot reload lewat `melos run kasir-reload` karena Melos tidak meneruskan stdin.
- `Failure` memakai sealed class Dart 3, bukan freezed, karena tidak butuh codegen.
- Test double HTTP (`FakeAdapter`) diekspor dari `package:core/testing.dart`; jangan di-import kode produksi.
- Enum backend: `type_payment` 0 tunai, 1 hutang, 2 transfer (VA), 3 qris; `unit` 0 pcs, 1 gram, 2 kg, 3 liter, 4 kardus, 5 ikat; `product_type` 0 fisik, 1 digital.
- Komponen memakai `shadcn_ui` (dependency di `packages/ui`). Kedua app membungkus `MaterialApp.router` dengan `ShadApp.custom` + `ShadAppBuilder`. `ui.dart` hanya me-re-export widget Shad yang dipakai lewat `show`, karena `shadcn_ui` juga mengekspor boxy, flutter_animate, intl, dan two_dimensional_scrollables. Material tetap dipakai untuk widget yang tidak punya padanan Shad (`ListTile`, `ChoiceChip`, `Autocomplete`, `MenuAnchor`, `NavigationRail`/`NavigationBar`) dan untuk stepper qty, karena tombol Shad tidak punya area sentuh 48dp.
- Skema warna putih + biru (`Azure`, `Neutral` di `ui/src/tokens/colors.dart`), terang dan gelap. Dua densitas: `AppTheme.compact` untuk CMS (kontrol 40, body 14) dan `AppTheme.touch` untuk kasir (kontrol 48, aksi utama 56, body 16). Ukuran dibaca lewat `AppSizes.of(context)`.
- Ikon Iconsax memakai varian `_copy` (linear/outline). Nama tanpa `_copy` adalah varian bold.
- Referensi desain: CMS dari "CMS Dashboard Design" oleh Faysol Ahmed Sozib (dribbble.com/shots/16763871), kasir dari "Mobile App Design for POS" oleh Vinz (dribbble.com/shots/27265995). Credit (`DesignCredit`) hanya ada di halaman Pengaturan CMS dan bawah halaman Lainnya kasir, tidak di footer atau login.
- Gambar produk: file WebP, rasio 1:1, maks 500 KB (`ProductImage.validate` di `core`, sisi terpanjang maks 4000 px, kunci error `image_not_webp|image_not_square|image_too_large|image_dimensions`). Backend memeriksa ulang format dan ukuran, menolak sumber di atas 16 juta piksel, lalu mengecilkan gambar ke 256 px dan menyimpannya sebagai base64 mentah (tanpa awalan `data:`); `imageProviderFor` di `ui` yang membedakan URL lama dari base64. `barcode_image` dari backend juga base64 mentah (Code128 WebP), digambar `BarcodeImage` (`ui`) lewat `imageProviderFor`, bukan data URI. CMS dan kasir memakai `ImageUploadField` (`ui`) lewat `ProductImageField` masing-masing; hanya cara memilih file yang beda (CMS `common/file_picker`, kasir `file_selector`). Bulk CMS membawa base64 di kolom CSV `image`; backend membatasi body 25 MB, jadi total gambar dijaga 20 MB.
- SKU produk baru dibuat otomatis (`SkuGenerator` di `core`): `KATEGORI-TIPE-AKRONIM NAMA-NNN`, contoh `MIE-P-IG-001` (3 huruf kategori, P fisik atau D digital, inisial nama, nomor urut). Ini port rumus Excel toko; akronim nama menggantikan sel kode toko. Backend mengisi sendiri SKU yang kosong saat impor (`KAT-8hex`, dicek bentrok) dan barcode produk tanpa barcode (`SKU-8hex id`), tetapi tidak bisa mencari SKU, dan SKU yang sama menimpa produk lama saat impor massal, jadi `SkuBook` (`cms/common`) membaca SKU terpakai per kategori lewat `GetTakenSkus` (daftar produk per `category_id`, hanya kolom `sku`), termasuk kategori lain berkode sama; gagal baca berarti SKU dibiarkan kosong, bukan ditebak. SKU hanya mengikuti form sampai pengguna mengetik sendiri; produk lama tidak pernah berubah. Tambah satu produk yang bentrok 409 dicoba ulang dengan nomor berikutnya (hanya tanpa barcode dan SKU bukan ketikan pengguna). Tidak menambah endpoint backend untuk ini (keputusan user).
- Stok dan qty: backend `numeric(12,3)`, jadi `Validators.quantity` (`core`) menolak NaN/Inf, lebih dari 999.999.999,999, lebih dari 3 desimal, dan pecahan untuk pcs (`signed` untuk penyesuaian stok). Kunci error `qty_whole|qty_decimals|qty_too_large`; teksnya hanya ada di ARB CMS karena stok hanya diubah dari CMS.
- CMS mengunduh file dari backend lewat `ApiClient.download` (bytes + header). Template impor Excel: `GET /catalog/products/template` (halaman bulk, tombol "Unduh template Excel", di samping template CSV lokal). Ekspor barcode: `GET /catalog/products/export/barcodes` per filter pencarian dan kategori di daftar produk; satu file maks 500 produk, jumlah file dari header `X-Total-Parts` (CORS backend meng-expose-nya), dan `ExportBarcodes` mengambil semua bagian lalu menyimpannya berurutan. Detail transaksi CMS menampilkan `amount_paid`, `change_amount`, dan `change[]` bila ada.
- Kategori memakai `AppAutocomplete` (`ui`): CMS boleh membuat kategori baru (`createLabel`), kasir hanya memilih yang sudah ada.
- Teks UI bahasa Indonesia memakai padanan Indonesia (Pelanggan, Staf, Perangkat, Nama pengguna, Kata sandi, Dasbor, Pindai, No. faktur). Hanya ARB `id` yang berubah; nilai yang dikirim ke BE (role, enum, field JSON) tetap. SKU, barcode, QRIS, online/offline dibiarkan. Kasir membuka link dengan `url_launcher`; CMS memakai `openInNewTab` di `common/file_saver*`.

## Arsitektur folder dan alur kode (PRD bagian 8.4)

Bagian ini menentukan letak setiap file dan arah dependensinya, supaya Claude Code atau developer bisa menambah fitur tanpa menebak. Kedua app memakai **clean architecture penuh dengan bloc** (keputusan user): setiap fitur punya layer `domain`, `data`, dan `presentation`. Pengelompokan per fitur mengikuti panduan arsitektur Flutter. Sumber: https://docs.flutter.dev/app-architecture/guide

**Arah dependensi antarpaket** (panah = boleh import):

```
apps/cms ──┐
           ├──► packages/core   (tidak import ui, tidak import app)
apps/kasir ┘
     │
     └──────► packages/ui       (tidak import core, tidak import app)
```

**Arah dependensi antarlayer** di dalam satu fitur:

```
presentation (bloc, page, widget)
      │ memanggil
      ▼
domain (entity, kontrak repository, use case)   ← Dart murni: tanpa Flutter, dio, drift
      ▲ mengimplementasikan kontrak
      │
data (model, datasource, implementasi repository)
```

Aturan:
1. `domain` tidak import `data`, `presentation`, Flutter, dio, drift, atau plugin apa pun.
2. Bloc hanya memanggil use case, tidak pernah repository atau datasource. Satu use case = satu aksi dengan satu method `call(...)`.
3. Use case mengembalikan `Result<T>`, yaitu sealed class `Ok(value)` / `Err(Failure)` dari `core/src/common`. Dart 3 sealed class sudah cukup, jadi tidak perlu paket Either.
4. Implementasi repository mengubah model menjadi entity dan mengubah `DioException`/error drift menjadi `Failure`. Hanya layer ini yang tahu soal JSON dan HTTP.
5. Satu fitur tidak boleh import fitur lain. Domain dan data yang dipakai bersama pindah ke `core/src/features/<resource>`. Shell, router, dan DI ada di `app/`.
6. Instance hanya dibuat di `app/di.dart` (get_it). Implementasi didaftarkan sebagai kontraknya: `getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(...))`. Bloc dibuat per route lewat `BlocProvider(create: (_) => XBloc(getIt(), getIt()))`.
7. `ui` hanya berisi tampilan (token, theme, komponen) tanpa entity bisnis.

#### packages/core

```
packages/core/lib/
├── core.dart                 # export yang aman untuk web, di-import kedua app
├── mobile.dart               # export khusus kasir: drift, mmkv, secure storage, local datasource
│                             # (CMS tidak pernah import file ini, jadi plugin native tidak ikut ke build web)
└── src/
    ├── common/
    │   ├── result.dart               # sealed Result<T>: Ok | Err
    │   └── failure.dart              # freezed union: network, unauthorized, forbidden,
    │                                 # notFound, conflict, validation(message), server
    ├── config/app_config.dart        # baseUrl, flavor; diisi app dari .env
    ├── network/
    │   ├── api_client.dart           # instance dio + helper get/post/patch/delete
    │   ├── auth_interceptor.dart     # pasang access token, refresh sekali saat 401, lalu logout
    │   └── web_adapter.dart          # withCredentials + header X-Client: web (conditional import)
    ├── storage/
    │   ├── key_value_store.dart      # kontrak + PrefsStore (shared_preferences, web)
    │   ├── mmkv_store.dart           # MmkvStore (mobile.dart)
    │   └── token_store.dart          # secure storage refresh token (mobile.dart)
    ├── database/                     # drift (mobile.dart)
    │   ├── app_database.dart
    │   ├── tables/                   # products, categories, customers, pending_transactions,
    │   │                             # draft_carts, draft_cart_items
    │   └── daos/
    ├── constants/                    # api_paths.dart, roles.dart, payment_method.dart
    ├── validation/validators.dart    # aturan yang sama dengan backend (barcode, sku, password)
    ├── format/                       # Rupiah dan tanggal (intl)
    └── features/<resource>/          # auth, user, customer, category, product, transaction,
        │                             # payment, debt, dashboard, device, report
        ├── domain/
        │   ├── entities/             # freezed, tanpa JSON
        │   ├── repositories/         # abstract class (kontrak)
        │   └── usecases/             # use case yang dipakai kedua app (Login, GetProducts, ...)
        └── data/
            ├── models/               # freezed + json_serializable, dengan toEntity()
            ├── datasources/          # <resource>_remote_datasource.dart (ApiClient)
            │                         # <resource>_local_datasource.dart (DAO, mobile.dart)
            └── repositories/         # <resource>_repository_impl.dart
```

#### packages/ui

```
packages/ui/lib/
├── ui.dart
└── src/
    ├── tokens/        # colors.dart (biru-putih, terang/gelap), spacing, radius, typography (Inter)
    ├── theme/         # app_theme.dart → ThemeData M3 terang/gelap dari token, tanpa Dynamic Color
    ├── components/    # satu file per komponen dari daftar bagian 7 (button, input, data_table, tab_strip, ...)
    └── l10n/          # ARB teks komponen (id, en)
```

#### apps/kasir dan apps/cms (struktur sama)

```
apps/<app>/
├── lib/
│   ├── main_dev.dart / main_prod.dart   # pilih .env lalu panggil bootstrap(); kasir juga main_staging.dart
│   ├── bootstrap.dart                   # load env, init storage/firebase, di.setup(), runApp
│   ├── app/
│   │   ├── app.dart                     # MaterialApp.router, theme dari ui, locale
│   │   ├── router.dart                  # go_router + redirect auth; satu konstanta path per route
│   │   ├── di.dart                      # registrasi get_it
│   │   └── shell/                       # kasir: navigation bar/rail; cms: sidebar/rail + top bar
│   ├── features/<fitur>/
│   │   ├── domain/usecases/             # use case khusus app ini
│   │   ├── data/                        # hanya kalau fitur punya data khusus app (draft, antrean, printer)
│   │   └── presentation/
│   │       ├── bloc/                    # <fitur>_bloc.dart|_cubit.dart, _event.dart, _state.dart (freezed)
│   │       ├── pages/                   # <fitur>_page.dart
│   │       └── widgets/                 # widget yang hanya dipakai fitur ini
│   └── l10n/                            # ARB teks fitur (id default, en)
├── test/                                # mencerminkan lib/ (test/features/<fitur>/domain|data|presentation)
└── integration_test/
```

Cubit dipakai untuk layar CRUD biasa. Bloc dipakai kalau event-nya banyak dan urutannya penting, seperti tab transaksi, keranjang, scanner, atau sync.

**Kasir: peta fitur**

```
apps/kasir/lib/features/
├── auth/          # login staff; logout: konfirmasi hapus draft, ditahan saat ada QRIS/VA menunggu, cabut token FCM
├── checkout/      # tab transaksi paralel + keranjang + scan + bayar (tunai/hutang/QRIS/VA) → struk
│   ├── domain/usecases/   # OpenDraft, AddItem, CloseDraft, PurgeStaleDrafts, CheckoutTransaction
│   └── data/              # draft_cart_repository_impl.dart (drift draft_carts)
├── history/       # riwayat + status sync → detail → batal / cetak ulang
├── customers/     # tambah (online), cari dari cache
├── debts/         # terima pembayaran hutang (online)
├── products/      # edit produk (online, field dibatasi untuk staff)
├── sync/          # antrean offline + jadwal 12:00/00:00 + tombol "Sync sekarang"
│   ├── domain/usecases/   # EnqueueTransaction, SyncPendingTransactions
│   └── data/              # pending_transaction_repository_impl.dart, sync_scheduler.dart
│                          # (workmanager + connectivity_plus)
├── printer/       # flutter_bluetooth_printer: pairing, cetak, cetak ulang
├── push/          # firebase_messaging: daftar token, tap notifikasi → detail transaksi
└── settings/      # bahasa, tema, printer, info toko
```

Use case `CheckoutTransaction`: kalau online, kirim lewat `TransactionRepository`. Kalau offline dan metodenya tunai/hutang, panggil `EnqueueTransaction` (stok lokal dikurangi). Setelah berhasil, draft tab dihapus. Bloc checkout tidak perlu tahu jalur mana yang dipakai.

**CMS: peta fitur**

```
apps/cms/lib/features/
├── auth/            # login superadmin (staff ditolak 403)
├── dashboard/       # perlu tindakan → angka utama → grafik → rincian; quick access
├── staff/           # daftar, tambah, reset password, nonaktif/pulihkan, hapus permanen
├── customers/       # daftar, tambah, edit, detail riwayat, nonaktif/pulihkan, hapus permanen
├── categories/      # tambah, ganti nama, hapus
├── products/        # daftar, tambah satuan/massal, edit, stok, hapus
├── transactions/    # daftar + filter, detail, batal, konflik stok → tandai ditinjau
├── payments/        # monitoring charge QRIS/VA, cek status
├── debts/           # daftar/detail, hutang manual, terima pembayaran
├── reports/         # unduh PDF bulanan dan struk transaksi (buka URL PDF di browser)
├── devices/         # daftar device, cabut token
└── settings/        # bahasa, tema, logout
```

**Contoh alur: cabut device di CMS**

```
DevicesPage (tap "Cabut", konfirmasi)
  → DevicesCubit.revoke(id)
  → RevokeDevice(id)                         domain/usecases (core)
  → DeviceRepository.revoke(id)              kontrak domain
  → DeviceRepositoryImpl → DeviceRemoteDatasource → ApiClient.delete(ApiPaths.device(id))
  ← Ok: cubit memuat ulang daftar → toast
  ← Err(Failure): state error, pesan ditampilkan
```

**Contoh alur: Transaksi 2 dibayar tunai saat offline, Transaksi 1 masih terbuka**

```
CheckoutPage (tab Transaksi 2) → CheckoutBloc(PaySubmitted(draftId: 2))
  → CheckoutTransaction
      offline → EnqueueTransaction → PendingTransactionRepository (drift, stok lokal dikurangi)
      → CloseDraft(2)
  ← struk OFF-<device>-<urut> tampil/dicetak; tab aktif pindah ke Transaksi 1
SyncScheduler (koneksi kembali / 12:00 / 00:00 / tombol)
  → SyncPendingTransactions → TransactionRepository.sync(batch)   POST /sales/transactions/sync
  ← per item: Ok → ganti nomor invoice; gagal → tetap di antrean dengan alasan
```

**Resep menambah fitur (TDD)**. Setiap langkah dimulai dengan test yang gagal (red), lalu kode minimum sampai lulus (green), lalu refactor.
1. **Domain**: tulis test use case dengan kontrak repository yang di-mock (`mocktail`). Lalu buat entity, kontrak repository, dan use case. Cek dulu `core/src/features`; jangan membuat resource baru kalau sudah ada.
2. **Data**: tulis test implementasi repository dengan datasource yang di-mock (drift memakai database in-memory). Lalu buat model, datasource, dan implementasi. Jalankan `melos run build_runner` (script ini dibuat di milestone 1).
3. **Bloc**: tulis `bloc_test` untuk setiap event → urutan state, termasuk jalur `Err`. Lalu buat bloc/cubit.
4. **Page**: tulis widget test untuk state loading, kosong, error, dan sukses. Lalu buat page dari komponen `ui`. Kalau komponennya belum ada, tambahkan dulu ke `ui` beserta test-nya.
5. Daftarkan dependency di `app/di.dart` dan route di `app/router.dart`. Tambah teks ke ARB (id dan en).
6. Jalankan `melos run analyze`, `melos run test`, dan `melos run coverage` sebelum commit.


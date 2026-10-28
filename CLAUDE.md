# shop_fe

Monorepo Flutter: `apps/cms` (web, super saja), `apps/kasir` (Android/iOS, offline-first), `packages/core`, `packages/ui`.
PRD: `~/Documents/prd/flutter-cms-kasir.md`. Konteks produk: `~/Documents/prd/PRODUCT.md`. Backend kontrak: `~/Documents/Shop_project_be` (branch `dev`, `swagger.json` + `internal/dto`).

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

- Flutter 3.47.2 terpasang (PRD 3.47.8). `build_runner` resolve ke 2.16.1 dan `freezed` ke 4.0.1 karena SDK 3.47.2 mem-pin `test_api 0.7.12`; constraint `^2.16.1`/`^4.0.1` otomatis naik setelah upgrade Flutter.
- Inter dibundel sebagai font asset di `packages/ui/fonts` (OFL), bukan lewat `google_fonts`, supaya kasir tetap punya font saat offline.
- Application ID: Android `com.suhaili.cashier`, iOS `com.suhaili.cashier-ios`. Tanpa flavor native; `main_dev.dart`/`main_prod.dart` memilih `.env.dev`/`.env.prod`.
- `.env.*` berisi placeholder `API_BASE_URL`. Emulator Android butuh `http://10.0.2.2:<port>`.
- Firebase dikonfigurasi lewat `flutterfire configure` (project `pos-app-51cb3`, `apps/kasir/lib/firebase_options.dart`). Kalau Firebase gagal start, app tetap jalan dan push dimatikan.
- Jalankan app dari root: `melos run cms`, `melos run kasir -- -d <id>`; hot reload lewat `melos run kasir-reload` karena Melos tidak meneruskan stdin.
- `Failure` memakai sealed class Dart 3, bukan freezed, karena tidak butuh codegen.
- Test double HTTP (`FakeAdapter`) diekspor dari `package:core/testing.dart`; jangan di-import kode produksi.
- Enum backend: `type_payment` 0 tunai, 1 hutang, 2 transfer (VA), 3 qris; `unit` 0 pcs, 1 gram, 2 kg, 3 liter, 4 kardus, 5 ikat; `product_type` 0 fisik, 1 digital.
- Komponen memakai `shadcn_ui` (dependency di `packages/ui`). Kedua app membungkus `MaterialApp.router` dengan `ShadApp.custom` + `ShadAppBuilder`. `ui.dart` hanya me-re-export widget Shad yang dipakai lewat `show`, karena `shadcn_ui` juga mengekspor boxy, flutter_animate, intl, dan two_dimensional_scrollables. Material tetap dipakai untuk widget yang tidak punya padanan Shad (`ListTile`, `ChoiceChip`, `Autocomplete`, `MenuAnchor`, `NavigationRail`/`NavigationBar`) dan untuk stepper qty, karena tombol Shad tidak punya area sentuh 48dp.
- Skema warna putih + mint (`Mint`, `Neutral` di `ui/src/tokens/colors.dart`), terang dan gelap. Dua densitas: `AppTheme.compact` untuk CMS (kontrol 40, body 14) dan `AppTheme.touch` untuk kasir (kontrol 48, aksi utama 56, body 16). Ukuran dibaca lewat `AppSizes.of(context)`.
- Ikon Iconsax memakai varian `_copy` (linear/outline). Nama tanpa `_copy` adalah varian bold.
- Referensi desain: CMS dari "CMS Dashboard Design" oleh Faysol Ahmed Sozib (dribbble.com/shots/16763871), kasir dari "Mobile App Design for POS" oleh Vinz (dribbble.com/shots/27265995). Credit (`DesignCredit`) ada di footer `CmsPage`, halaman login CMS, dan bawah halaman Lainnya kasir. Kasir membuka link dengan `url_launcher`; CMS memakai `openInNewTab` di `common/file_saver*`.

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
    ├── tokens/        # colors.dart (hijau-putih, terang/gelap), spacing, radius, typography (Inter)
    ├── theme/         # app_theme.dart → ThemeData M3 terang/gelap dari token, tanpa Dynamic Color
    ├── components/    # satu file per komponen dari daftar bagian 7 (button, input, data_table, tab_strip, ...)
    └── l10n/          # ARB teks komponen (id, en)
```

#### apps/kasir dan apps/cms (struktur sama)

```
apps/<app>/
├── lib/
│   ├── main_dev.dart / main_prod.dart   # pilih .env lalu panggil bootstrap()
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
  → SyncPendingTransactions → TransactionRepository.sync(batch)   POST /api/transactions/sync
  ← per item: Ok → ganti nomor invoice; gagal → tetap di antrean dengan alasan
```

**Resep menambah fitur (TDD)**. Setiap langkah dimulai dengan test yang gagal (red), lalu kode minimum sampai lulus (green), lalu refactor.
1. **Domain**: tulis test use case dengan kontrak repository yang di-mock (`mocktail`). Lalu buat entity, kontrak repository, dan use case. Cek dulu `core/src/features`; jangan membuat resource baru kalau sudah ada.
2. **Data**: tulis test implementasi repository dengan datasource yang di-mock (drift memakai database in-memory). Lalu buat model, datasource, dan implementasi. Jalankan `melos run build_runner` (script ini dibuat di milestone 1).
3. **Bloc**: tulis `bloc_test` untuk setiap event → urutan state, termasuk jalur `Err`. Lalu buat bloc/cubit.
4. **Page**: tulis widget test untuk state loading, kosong, error, dan sukses. Lalu buat page dari komponen `ui`. Kalau komponennya belum ada, tambahkan dulu ke `ui` beserta test-nya.
5. Daftarkan dependency di `app/di.dart` dan route di `app/router.dart`. Tambah teks ke ARB (id dan en).
6. Jalankan `melos run analyze`, `melos run test`, dan `melos run coverage` sebelum commit.


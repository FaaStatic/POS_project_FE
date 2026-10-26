# POS System FE

Flutter frontend for a small-shop point-of-sale system. One monorepo holds two apps that share their business logic:

- **CMS** (web): the shop owner (superadmin) runs the back office: products, stock, staff, customers, debts, payments, devices, and reports.
- **Kasir** (Android/iOS): staff ring up sales at the counter. Cashiers keep selling for cash or on credit while the internet is down, and the app syncs those sales once it reconnects.

See [CLAUDE.md](CLAUDE.md) for technical decisions and the full architecture rules, and [DESIGN.md](DESIGN.md) for the visual system.

## Contents

- [Who uses what](#who-uses-what)
- [Features: Kasir](#features-kasir)
- [Features: CMS](#features-cms)
- [Monorepo](#monorepo)
- [Architecture](#architecture)
- [Data flow](#data-flow)
- [Local storage](#local-storage)
- [Usage](#usage)
- [Adding a feature](#adding-a-feature)
- [Troubleshooting](#troubleshooting)

## Who uses what

| Role | App | Can do |
| --- | --- | --- |
| Superadmin | CMS (and Kasir) | Everything: manage staff, prices, stock, debts, devices, reports. In Kasir, edits every product field |
| Staff | Kasir only | Sell, void sales, add customers, take debt payments, edit a limited set of product fields. The CMS rejects staff logins |

Superadmins create staff accounts in the CMS (Staff → Add staff). Both apps show Indonesian by default and English as an option.

## Features: Kasir

The bottom bar has four tabs: **Checkout** (Transaksi), **History** (Riwayat), **Customers** (Pelanggan), and **More** (Lainnya). Products and settings sit under More because cashiers rarely open them.

### Checkout and parallel tabs

- The cashier opens several sale tabs ("Transaksi 1", "Transaksi 2", ...) and switches between them, so one customer can wait for a QRIS scan while the next one checks out.
- Each tab holds its own cart and optional customer. Tabs live in the local database, so they survive an app restart.
- Barcode scanning (camera, `mobile_scanner`) looks products up in the local cache, so it works offline. An unknown code shows a "not found" result.
- The cart warns when a line wants more than the cached stock, for example when another tab already sold it.
- Digital products (`product_type` 1) ask for a destination, such as a phone number, and need cash or debt payment.
- The app deletes tabs nobody touched for 24 hours.

### Payment methods

| Method | Backend value | Offline | Notes |
| --- | --- | --- | --- |
| Cash (tunai) | 0 | Yes | Records the sale at once |
| Debt (hutang) | 1 | Yes | Needs a customer; uses the product's debt price |
| VA transfer | 2 | No | BCA or Mandiri virtual account; the tab locks until the charge settles |
| QRIS | 3 | No | Shows a QR code; the tab locks until the charge settles |

While a QRIS/VA charge is pending, the cashier can't close that tab or log out. If the charge fails or expires, the tab unlocks and the cashier picks another method. A push message or a status check settles the charge.

### History

- Lists every sale on the device with its sync status: pending, synced, failed, or cancelled.
- Opens a sale's detail and receipt, reprints it, or voids it with a reason.
- Voiding an unsynced sale works offline and returns the stock locally. Voiding a synced sale calls the server first.

### Customers and debts

- Search runs against the local customer cache.
- Adding a customer and taking a debt payment need a connection.

### Products (More → Products)

- Staff edit basic fields. Superadmins also change purchase price, product type, category (including a new one), and stock.

### Printer and receipts

- Pairs a Bluetooth thermal printer (`flutter_bluetooth_printer`) and prints ESC/POS text receipts.
- Supports 58 mm (32 characters per line) and 80 mm (48 characters) paper.
- Store name, address, receipt footer, and auto-print live on the device (More → Store info / Printer).
- The screen receipt and the printed receipt use the same layout. Printers with a Latin-only code page get `?` for unsupported characters.

### Sync

- The app syncs queued offline sales when the connection returns, at 12:00 and 00:00 through a background task (workmanager), and when the cashier taps "Sync sekarang".
- On start, if online, the app refreshes the product, category, and customer cache and syncs the queue.
- An offline banner shows while the device has no connection, along with the pending count.

### Push notifications

- After sign-in the app registers its FCM token with the backend. Payment pushes settle waiting QRIS/VA tabs, and tapping a notification opens the transaction.
- If Firebase fails to start, the app keeps working without push.

### Logout

- Logout stays blocked while a tab waits for QRIS/VA.
- With open tabs or pending sales, the app asks for confirmation. Logout discards the tabs but keeps queued sales on the device for the next sign-in.
- Logout also unregisters the device's push token.

## Features: CMS

| Menu | What it does |
| --- | --- |
| Dashboard | Summary numbers with trend vs the previous period, date range picker, sales chart, "needs action" list, recent transactions, top products, payment mix, credit flow, devices, quick actions (add product, download this month's report) |
| Transactions | Paged list with filters, detail, void, download receipt PDF, mark stock conflicts from offline sync as reviewed |
| Payments | Monitor QRIS/VA charges and check their status |
| Debts | List and detail, add a manual debt, record a payment |
| Products | List with filters, add or edit (category accepts an existing name or a new one), adjust stock, delete |
| Bulk products | Multi-row form, or import an Excel/CSV file; a USB barcode scanner can type into each row |
| Categories | Add, rename, delete |
| Customers | List, add, edit, detail with transaction history, deactivate and restore, delete permanently |
| Staff | List, add, reset password, deactivate and restore, delete permanently |
| Devices | Registered Kasir devices; revoke a device's push token |
| Reports | Monthly PDF with sales, credit sales, manual credit, and credit payments per day |
| Settings | Language, theme (system, light, dark), logout |

The layout adapts from a sidebar on desktop to a rail and top bar on narrower screens.

## Monorepo

```text
shop_fe/
├── apps/
│   ├── cms/                      # Flutter web
│   │   ├── lib/
│   │   │   ├── main_dev.dart     # loads .env.dev, calls bootstrap()
│   │   │   ├── main_prod.dart    # loads .env.prod
│   │   │   ├── bootstrap.dart    # env, storage, DI, runApp
│   │   │   ├── app/              # app.dart, router.dart, di.dart, shell/
│   │   │   ├── features/<feature>/{domain,data,presentation}
│   │   │   └── l10n/             # app_id.arb, app_en.arb
│   │   └── test/                 # mirrors lib/
│   └── kasir/                    # Flutter Android/iOS, same layout as cms
│       ├── lib/background.dart   # workmanager entry point for scheduled sync
│       └── integration_test/     # offline → sync and multi-tab flows on a device
├── packages/
│   ├── core/                     # shared logic, no UI
│   │   └── lib/
│   │       ├── core.dart         # web-safe exports
│   │       ├── mobile.dart       # Kasir-only exports (drift, MMKV, secure storage)
│   │       ├── testing.dart      # FakeAdapter and other test doubles
│   │       └── src/
│   │           ├── common/       # Result, Failure, NetworkStatus, paging
│   │           ├── config/       # AppConfig from .env
│   │           ├── constants/    # ApiPaths, roles, payment methods
│   │           ├── network/      # ApiClient (dio), AuthInterceptor, web adapter
│   │           ├── storage/      # key-value store, MMKV, secure token store
│   │           ├── database/     # drift tables and AppDatabase
│   │           ├── validation/   # same rules as the backend (barcode, sku, password)
│   │           ├── format/       # Rupiah and date formatting
│   │           └── features/     # auth, catalog, category, customer, dashboard, debt,
│   │                             # device, draft, payment, preferences, product,
│   │                             # receipt, report, sales, staff, transaction
│   └── ui/                       # tokens, theme, components, no business logic
│       ├── fonts/                # Inter (OFL), bundled for offline use
│       └── lib/src/
│           ├── tokens/           # colors, spacing, typography
│           ├── theme/            # Material 3 light/dark ThemeData
│           ├── components/       # button, text field, search, data table, tab strip, ...
│           └── l10n/             # component strings (id, en)
├── tool/check_coverage.dart      # coverage gate for melos run coverage
└── pubspec.yaml                  # pub workspace + melos scripts
```

The root `pubspec.yaml` declares a [pub workspace](https://dart.dev/tools/pub/workspaces), so one `flutter pub get` at the root resolves every package into a single lockfile. [Melos](https://melos.invertase.dev) 8.9.0 runs scripts across all packages.

### Package rules

```text
apps/cms ──┐
           ├──► packages/core   (never imports ui or an app)
apps/kasir ┘
     └────────► packages/ui     (never imports core or an app)
```

- `core` holds every entity, repository, and use case that both apps need. A feature in one app never imports a feature from the other.
- `ui` holds look and feel only: tokens, theme, and reusable widgets such as `AppButton`, `AppTextField`, `SearchField`, `ResponsiveTable`, `TransactionTabStrip`, `QtyStepper`, `StatusBadge`, `OfflineBanner`, `ConfirmDialog`, and the loading/empty/error state views.
- The CMS imports `core.dart` only. Kasir imports `core.dart` and `mobile.dart`. This keeps native plugins (drift, MMKV, secure storage) out of the web build.

### Shared vs app-specific code

| Lives in | Example |
| --- | --- |
| `packages/core/lib/src/features/<resource>` | `Product` entity, `ProductRepository`, `GetProducts`, `ProductRemoteDatasource` |
| `apps/kasir/lib/features/<feature>` | `CheckoutTransaction`, `SyncPendingTransactions`, printer, push |
| `apps/cms/lib/features/<feature>` | Dashboard layout, bulk product form, report download |

## Architecture

Each feature follows clean architecture with bloc, split into three layers:

```text
presentation   page, widget, bloc/cubit
     │ calls a use case
     ▼
domain         entity, repository contract, use case   (pure Dart)
     ▲ implements the contract
     │
data           JSON model, datasource (dio / drift), repository impl
```

### Layer rules

1. `domain` stays pure Dart. It never imports Flutter, dio, drift, or another layer.
2. A bloc or cubit calls use cases only, never a repository or datasource.
3. Each use case does one action through one `call(...)` method and returns `Result<T>`: `Ok(value)` or `Err(Failure)`. `Result` and `Failure` are Dart 3 sealed classes, so callers handle them with `switch`.
4. The repository impl maps models to entities and turns `DioException` or drift errors into a `Failure`. JSON and HTTP stay inside this layer.
5. `Failure` subtypes: `NetworkFailure`, `TimeoutFailure`, `UnauthorizedFailure`, `ForbiddenFailure`, `NotFoundFailure`, `ConflictFailure`, `ValidationFailure`, `ServerFailure`, `StorageFailure`.

### Wiring

- `app/di.dart` creates every instance with get_it and registers implementations under their contract:
  `getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(...))`.
- `app/router.dart` defines routes with go_router, one path constant per route, plus an auth redirect. Each tab uses a `StatefulShellRoute` branch so it keeps its own navigation stack.
- Each route creates its bloc through `BlocProvider(create: (_) => XCubit(getIt(), getIt()))`.
- Plain CRUD screens use a Cubit. Flows where event order matters (checkout tabs, cart, scanner, sync) use a Bloc.

### Main stack

| Concern | Library |
| --- | --- |
| State | flutter_bloc |
| Routing | go_router |
| DI | get_it |
| HTTP | dio (+ dio_web_adapter for cookies on web) |
| Local database | drift (Kasir) |
| Key-value | MMKV (Kasir), shared_preferences (CMS) |
| Secrets | flutter_secure_storage (Kasir refresh token) |
| Codegen | freezed, json_serializable, build_runner |
| Scanning | mobile_scanner |
| Printing | flutter_bluetooth_printer |
| Push | firebase_messaging |
| Background work | workmanager, connectivity_plus |
| Charts | fl_chart (CMS) |
| i18n | flutter gen-l10n, intl |

## Data flow

### Online request (example: revoke a device in the CMS)

```text
DevicesPage  ──tap "Cabut", confirm──►  DevicesCubit.revoke(id)
  → RevokeDevice                        use case in core
  → DeviceRepository                    domain contract
  → DeviceRepositoryImpl → DeviceRemoteDatasource → ApiClient.delete
  → DELETE /api/fcm/devices/:id
  ← Ok   → cubit reloads the list, shows a toast
  ← Err  → error state, message shown
```

Every other CRUD screen in the CMS follows the same path.

### Authentication

```text
Login → POST /auth/login → access token (memory) + refresh token
  CMS:   backend sets an HttpOnly refresh cookie (requests send X-Client: web, withCredentials)
  Kasir: refresh token saved in secure storage
Any request → AuthInterceptor adds "Authorization: Bearer <access>"
  ← 401 → POST /auth/refresh once → retry the request
          refresh fails → clear session → router redirects to /login
```

The cookie only reaches the CMS when the backend's `cms_origins` lists the CMS origin (`http://localhost:5173` in dev).

### Kasir checkout: cash or debt

```text
CheckoutPage (tab "Transaksi 2") → CheckoutBloc → CheckoutTransaction
  validate: signed in, tab not locked, debt has a customer, digital lines have a destination
  online   → POST /api/transactions → store the sale as synced with the server invoice
  offline, or the request couldn't connect
           → store it in Sales as pending, receipt number OFF-<device>-<seq>
  then     → lower stock in the local cache → delete the tab's draft → show/print receipt
  ← the active tab moves to the next open one (e.g. Transaksi 1)
```

A timeout does not go into the queue. The server may have recorded the sale already, and `POST /api/transactions` has no idempotency key.

### Kasir checkout: QRIS or VA

```text
StartCharge → POST /api/payments/qris  or  /api/payments/va (BCA, Mandiri)
  → tab marked "awaiting payment", charge (QR / VA number, amount) saved on the tab
Push message or status check → ResolveCharge → GET /api/payments/:orderId/status
  success → store the sale as synced, lower local stock, tab shows the receipt
  failed / expired → tab unlocks, cashier picks another method
  still pending → nothing changes
```

### Offline queue sync

```text
Trigger: connection back | 12:00 / 00:00 background task | "Sync sekarang" | app start (online)
  → SyncPendingTransactions
  → send pending sales in batches of 100 to POST /api/transactions/sync
    (each sale carries its client_ref, created_at, method, customer, lines)
  ← accepted → status synced, OFF number replaced by the server invoice
               stock short on the server → sale accepted but flagged as a conflict;
               the superadmin reviews it in CMS → Transactions
  ← rejected → stays in the queue with its reason (retryable or not)
  → if anything synced, refresh the product, category, and customer cache
```

The 12:00/00:00 task runs in its own isolate (`lib/background.dart`). It loads the same `.env` file the app used, restores the session from secure storage, syncs, and schedules the next slot. Android may shift the time; iOS runs it when the OS allows.

## Local storage

Kasir keeps its offline data in drift (`packages/core/lib/src/database/tables.dart`):

| Table | Holds |
| --- | --- |
| `CachedProducts` | Products with SKU, barcode, unit, type, prices (cash and debt), stock, category, sold count |
| `CachedCategories` | Categories with product count |
| `CachedCustomers` | Customers for offline search and debt sales |
| `Sales` | Every sale made on the device: receipt number, method, total, lines (JSON), status (pending, synced, failed, cancelled), sync error, server transaction id, stock conflict flag |
| `DraftCarts` | Open tabs: number, customer, status (open, awaiting payment, paid), pending charge |
| `DraftCartItems` | Cart lines per tab: product, price, debt price, qty, unit, digital destination |

Other stores:

| Store | App | Holds |
| --- | --- | --- |
| MMKV | Kasir | Preferences, receipt settings, offline receipt counter, push device id, env file name for the background task |
| shared_preferences | CMS | Preferences (language, theme) |
| flutter_secure_storage | Kasir | Refresh token |
| HttpOnly cookie | CMS | Refresh token, set by the backend |

Backend enums the apps map: `type_payment` 0 cash, 1 debt, 2 transfer (VA), 3 QRIS; `unit` 0 pcs, 1 gram, 2 kg, 3 liter, 4 box (kardus), 5 bundle (ikat); `product_type` 0 physical, 1 digital.

## Usage

### Requirements

- Flutter 3.47.x (Dart 3.13); check with `flutter --version`
- Chrome for the CMS; Android Studio with an emulator or an Android phone; Xcode for iOS
- Backend running, with `cms_origins: ["http://localhost:5173"]` in its config so CMS login can use the refresh cookie

### 1. Set up the monorepo

Run every command below from the repo root. You never need to `cd` into an app folder.

```bash
flutter pub get
dart run melos run setup        # gen_l10n + build_runner
```

Run `setup` again after you change an ARB file, a freezed entity or model, or a drift table.

To type `melos run ...` without `dart run`, install melos globally once:

```bash
dart pub global activate melos 8.9.0
```

The examples below use `melos run`. `dart run melos run` does the same thing.

### 2. Set the API address

Each app reads `API_BASE_URL` and `FLAVOR` from its `.env` file. `main_dev.dart` loads `.env.dev`; `main_prod.dart` loads `.env.prod`. Edit `apps/cms/.env.dev` and `apps/kasir/.env.dev`:

| Running on | `API_BASE_URL` |
| --- | --- |
| CMS in Chrome, Kasir in the iOS simulator | `http://localhost:3030` |
| Kasir in the Android emulator | `http://10.0.2.2:3030` |
| Kasir on a real phone (same Wi-Fi) | `http://<laptop-IP>:3030` |

`.env.prod` holds the production API address. The `.env` files ship inside the app bundle, so keep secrets out of them.

### 3. Run the CMS (web)

```bash
melos run cms
```

This opens Chrome on port 5173, which must match `cms_origins` on the backend. Sign in with a superadmin account.

To use Brave or another Chromium browser, point `CHROME_EXECUTABLE` at it once in `~/.zshrc`. `flutter devices` then lists it as `chrome`.

```bash
export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
```

If Brave drops your login after a reload, turn off Shields for `localhost`.

### 4. Run Kasir (Android/iOS)

```bash
flutter devices                         # list device/emulator ids
melos run kasir -- -d <device-id>       # e.g. melos run kasir -- -d emulator-5554
```

Flutter arguments go after `--`. Without `-d`, Flutter picks the connected device or asks you.

- Application ID: Android `com.suhaili.cashier`, iOS `com.suhaili.cashier-ios`. The project has no native flavors; the `main_*.dart` entry point picks the env.
- Firebase (FCM) points at project `pos-app-51cb3` (`lib/firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist`). After changing the app ID, run `flutterfire configure` in `apps/kasir`.
- iOS on a device needs a Development Team in Xcode: `open apps/kasir/ios/Runner.xcworkspace` → Runner target → Signing & Capabilities.
- You can only test the Bluetooth printer, camera scanning, and scheduled sync on a real phone.

### Hot reload

Melos doesn't forward keystrokes to `flutter run`, so `r`/`R` may not work. Use a second terminal:

```bash
melos run kasir-reload      # hot reload
melos run kasir-restart     # hot restart
melos run cms-reload
melos run cms-restart
```

These scripts send `SIGUSR1`/`SIGUSR2` to the `flutter run` process through a pid file in `.dart_tool/`. If you prefer `r`/`R`, run from your IDE or call `flutter run` inside the app folder.

### Release builds

```bash
melos run build-cms     # web, prod env, output in apps/cms/build/web
melos run build-apk     # Android, prod env
melos run build-ipa     # iOS, prod env, needs Apple signing
```

### Tests and checks

```bash
melos run analyze                           # flutter analyze in every package
melos run test                              # unit and widget tests in every package
melos run coverage                          # fails if domain/data/bloc coverage < 80%
melos run integration -- -d <device-id>     # Kasir: offline → sync and multi-tab on a device
```

`test/` in each package mirrors `lib/` (`test/features/<feature>/domain|data|presentation`). Tests mock contracts with `mocktail`, test blocs with `bloc_test`, run drift against an in-memory database, and fake HTTP with `FakeAdapter` from `package:core/testing.dart`. The coverage gate (`tool/check_coverage.dart`) counts lines in `domain/`, `data/`, and `presentation/bloc/` and skips generated `.g.dart` and `.freezed.dart` files.

### All melos scripts

| Script | Does |
| --- | --- |
| `setup` | `gen_l10n` + `build_runner` |
| `gen_l10n` | Generate localizations from ARB files |
| `build_runner` | Generate freezed, json_serializable, and drift code |
| `cms` / `kasir` | Run the app in dev |
| `cms-reload` / `cms-restart` | Hot reload / restart the running CMS |
| `kasir-reload` / `kasir-restart` | Hot reload / restart the running Kasir |
| `build-cms` / `build-apk` / `build-ipa` | Release builds |
| `analyze` / `test` / `coverage` | Checks |
| `integration` | Kasir integration tests on a device |

`melos run` with no name lists them.

## Adding a feature

Write each step test-first (red, green, refactor):

1. **Domain**: test the use case with a mocked repository contract. Then add the entity, contract, and use case. Check `packages/core/lib/src/features` first and reuse an existing resource.
2. **Data**: test the repository impl with a mocked datasource. Then add the model, datasource, and impl, and run `melos run build_runner`.
3. **Bloc**: write a `bloc_test` for each event → state sequence, including the `Err` path.
4. **Page**: write widget tests for loading, empty, error, and success. Build the page from `ui` components; add a missing component to `ui` with its own test first.
5. Register dependencies in `app/di.dart`, add the route in `app/router.dart`, and add strings to both ARB files (id and en).
6. Run `melos run analyze`, `melos run test`, and `melos run coverage` before you commit.

## Troubleshooting

| Symptom | Cause |
| --- | --- |
| CMS: login works, but a reload sends you back to the login page | `cms_origins` lacks `http://localhost:5173`, or `flutter run` used a different port |
| Kasir: "Tidak ada koneksi" while the backend is up | `API_BASE_URL` still says `localhost` on the Android emulator or a phone |
| Kasir: offline sales stay pending | Check the sale's error in History; non-retryable failures need a fix on the data, retryable ones go out on the next sync |
| `Waiting for another flutter command to release the startup lock` | Another flutter command is still running; wait or stop it |
| `part '...freezed.dart'` not found | Run `melos run setup` |
| `melos: command not found` | Use `dart run melos run ...` or install it globally (step 1) |
| `Could not find an option named "-d"` | Flutter arguments go after `--`: `melos run kasir -- -d <id>` |
| `kasir-reload` says the app isn't running | Start it with `melos run kasir` first; the pid file only exists while it runs |

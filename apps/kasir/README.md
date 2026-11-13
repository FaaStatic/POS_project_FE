# kasir

Offline-first POS app (Android/iOS). Three flavors, each installable side by side:

| Flavor | App name | Android ID | iOS bundle ID | Entry point |
|---|---|---|---|---|
| dev | myKasir-dev | `com.suhaili.cashier.dev` | `com.suhaili.cashier-ios.dev` | `lib/main_dev.dart` |
| staging | myKasir-staging | `com.suhaili.cashier.staging` | `com.suhaili.cashier-ios.staging` | `lib/main_staging.dart` |
| prod | myKasir | `com.suhaili.cashier` | `com.suhaili.cashier-ios` | `lib/main_prod.dart` |

`--flavor` is required. Copy `.env.example` to `.env.dev`, `.env.staging` and `.env.prod` first.

```
flutter run --flavor dev -t lib/main_dev.dart
flutter build apk --flavor staging -t lib/main_staging.dart
```

From the repo root: `dart run melos run kasir`, `kasir-staging`, `build-apk`, `build-apk-staging`.

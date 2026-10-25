// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Shop CMS';

  @override
  String get loginTitle => 'Masuk ke CMS';

  @override
  String get loginSubtitle =>
      'Khusus admin toko. Kasir memakai aplikasi Kasir di HP.';

  @override
  String get username => 'Username';

  @override
  String get password => 'Kata sandi';

  @override
  String get signIn => 'Masuk';

  @override
  String get cmsAdminOnly =>
      'CMS khusus admin toko. Akun staff hanya bisa masuk lewat aplikasi Kasir.';

  @override
  String get errorNetwork =>
      'Tidak ada koneksi. Periksa internet lalu coba lagi.';

  @override
  String get errorTimeout => 'Server terlalu lama merespons. Coba lagi.';

  @override
  String get sessionExpired => 'Sesi berakhir. Silakan masuk lagi.';

  @override
  String get errorUnknown => 'Terjadi kesalahan. Coba lagi.';

  @override
  String get vRequired => 'Wajib diisi';

  @override
  String get vUsernameLength => 'Username 3–100 karakter';

  @override
  String get vPasswordLength => 'Kata sandi minimal 6 karakter';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get language => 'Bahasa';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get logout => 'Keluar';

  @override
  String signedInAs(String name) {
    return 'Masuk sebagai $name';
  }

  @override
  String get openMenu => 'Buka menu';

  @override
  String get navSettings => 'Pengaturan';
}

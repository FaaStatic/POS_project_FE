// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'ui_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class UiLocalizationsId extends UiLocalizations {
  UiLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get retry => 'Coba lagi';

  @override
  String get loading => 'Memuat';

  @override
  String get showPassword => 'Tampilkan kata sandi';

  @override
  String get hidePassword => 'Sembunyikan kata sandi';

  @override
  String get close => 'Tutup';

  @override
  String get cancel => 'Batal';

  @override
  String get search => 'Cari';

  @override
  String get clearSearch => 'Hapus pencarian';

  @override
  String get previousPage => 'Sebelumnya';

  @override
  String get nextPage => 'Berikutnya';

  @override
  String get offlineBanner => 'Tidak ada koneksi internet';

  @override
  String pendingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transaksi belum terkirim',
      zero: 'Semua transaksi terkirim',
    );
    return '$_temp0';
  }

  @override
  String get decrease => 'Kurangi';

  @override
  String get increase => 'Tambah';

  @override
  String get quantity => 'Jumlah';

  @override
  String get newBuyer => 'Pembeli baru';

  @override
  String allTabs(int count) {
    return 'Semua ($count)';
  }

  @override
  String tabLabel(int number) {
    return 'Transaksi $number';
  }

  @override
  String qtyFor(String name) {
    return 'Jumlah $name';
  }

  @override
  String get loadMore => 'Muat lebih banyak';

  @override
  String get actions => 'Aksi';

  @override
  String get moreActions => 'Aksi lainnya';

  @override
  String get pickDates => 'Pilih tanggal';

  @override
  String get clearDates => 'Hapus tanggal';
}

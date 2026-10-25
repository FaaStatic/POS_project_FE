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

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navTransactions => 'Transaksi';

  @override
  String get navProducts => 'Produk';

  @override
  String get navCategories => 'Kategori';

  @override
  String get navCustomers => 'Customer';

  @override
  String get navDebts => 'Hutang';

  @override
  String get navStaff => 'Staff';

  @override
  String get navPayments => 'Pembayaran';

  @override
  String get navDevices => 'Device';

  @override
  String get navReports => 'Laporan';

  @override
  String get active => 'Aktif';

  @override
  String get inactive => 'Nonaktif';

  @override
  String get search => 'Cari';

  @override
  String get actions => 'Aksi';

  @override
  String get save => 'Simpan';

  @override
  String get saved => 'Tersimpan.';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Hapus';

  @override
  String get edit => 'Edit';

  @override
  String get restore => 'Pulihkan';

  @override
  String get deactivate => 'Nonaktifkan';

  @override
  String get purge => 'Hapus permanen';

  @override
  String get retry => 'Coba lagi';

  @override
  String get createdAt => 'Dibuat';

  @override
  String get role => 'Peran';

  @override
  String get roleSuper => 'Admin';

  @override
  String get roleStaff => 'Staff';

  @override
  String get staffTitle => 'Staff';

  @override
  String get addStaff => 'Tambah staff';

  @override
  String get staffEmpty => 'Belum ada staff. Tambah staff pertama.';

  @override
  String get staffInactiveEmpty => 'Tidak ada staff nonaktif.';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get newPassword => 'Password baru';

  @override
  String get resetPasswordHint => 'Semua sesi staff ini akan keluar.';

  @override
  String get passwordReset => 'Password diganti. Sesi staff ini dicabut.';

  @override
  String get staffAdded => 'Staff ditambahkan.';

  @override
  String get staffDeactivated =>
      'Staff dinonaktifkan. Sesi dan token notifikasinya dicabut.';

  @override
  String get staffRestored => 'Staff dipulihkan.';

  @override
  String purgeTitle(String name) {
    return 'Hapus permanen $name?';
  }

  @override
  String get purgeStaffHint =>
      'Staff tanpa riwayat transaksi dihapus. Staff dengan riwayat dianonimkan supaya laporan lama tetap utuh.';

  @override
  String purgeTypeName(String name) {
    return 'Ketik $name untuk konfirmasi';
  }

  @override
  String get purgeMismatch => 'Nama tidak cocok.';

  @override
  String get purgedDeleted => 'Dihapus permanen.';

  @override
  String get purgedAnonymized => 'Punya riwayat transaksi, jadi dianonimkan.';

  @override
  String get customersTitle => 'Customer';

  @override
  String get addCustomer => 'Tambah customer';

  @override
  String get editCustomer => 'Edit customer';

  @override
  String get customersEmpty => 'Belum ada customer. Tambah customer pertama.';

  @override
  String get customersInactiveEmpty => 'Tidak ada customer nonaktif.';

  @override
  String get customerName => 'Nama';

  @override
  String get customerPhone => 'Nomor HP';

  @override
  String get customerAddress => 'Alamat';

  @override
  String get customerHasDebt =>
      'Customer masih punya hutang aktif, tidak bisa dihapus permanen.';

  @override
  String get purgeCustomerHint =>
      'Customer dengan riwayat transaksi dianonimkan, tanpa riwayat dihapus.';

  @override
  String get customerDeactivated => 'Customer dinonaktifkan.';

  @override
  String get customerRestored => 'Customer dipulihkan.';

  @override
  String get customerDetail => 'Detail customer';

  @override
  String get transactionsTitle => 'Transaksi';

  @override
  String get noTransactions => 'Belum ada transaksi.';

  @override
  String get debtsTitle => 'Hutang';

  @override
  String get noDebts => 'Tidak ada hutang.';

  @override
  String get categoriesTitle => 'Kategori';

  @override
  String get addCategory => 'Tambah kategori';

  @override
  String get rename => 'Ganti nama';

  @override
  String get categoryName => 'Nama kategori';

  @override
  String get categoriesEmpty => 'Belum ada kategori. Tambah kategori pertama.';

  @override
  String productCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produk',
      one: '1 produk',
      zero: 'Belum dipakai',
    );
    return '$_temp0';
  }

  @override
  String categoryInUse(int count) {
    return 'Dipakai $count produk. Pindahkan produknya dulu.';
  }

  @override
  String get categoryDuplicate => 'Nama kategori sudah ada.';

  @override
  String get categoryDeleted => 'Kategori dihapus.';

  @override
  String deleteCategoryTitle(String name) {
    return 'Hapus kategori $name?';
  }

  @override
  String get productsTitle => 'Produk';

  @override
  String get addProduct => 'Tambah produk';

  @override
  String get bulkAdd => 'Tambah massal';

  @override
  String get editProduct => 'Edit produk';

  @override
  String get productsEmpty => 'Belum ada produk. Tambah produk pertama.';

  @override
  String get productsNoMatch => 'Tidak ada produk yang cocok.';

  @override
  String get productName => 'Nama produk';

  @override
  String get sku => 'SKU';

  @override
  String get barcode => 'Barcode';

  @override
  String get barcodeHint => 'Opsional. Scanner USB bisa langsung mengisi.';

  @override
  String get unit => 'Satuan';

  @override
  String get productType => 'Tipe';

  @override
  String get physical => 'Fisik';

  @override
  String get digital => 'Digital';

  @override
  String get purchasePrice => 'Harga beli';

  @override
  String get sellingPrice => 'Harga jual';

  @override
  String get debtPrice => 'Harga hutang';

  @override
  String get stock => 'Stok';

  @override
  String get category => 'Kategori';

  @override
  String get categoryNewHint => 'Pilih kategori atau ketik nama baru';

  @override
  String get imageUrl => 'URL gambar (opsional)';

  @override
  String get allCategories => 'Semua kategori';

  @override
  String get adjustStock => 'Ubah stok';

  @override
  String get stockDelta => 'Tambah atau kurangi (contoh 10 atau -2)';

  @override
  String get stockUpdated => 'Stok diperbarui.';

  @override
  String get productDeleted => 'Produk dihapus.';

  @override
  String deleteProductTitle(String name) {
    return 'Hapus produk $name?';
  }

  @override
  String get productSaved => 'Produk disimpan.';

  @override
  String get bulkTitle => 'Tambah produk massal';

  @override
  String get bulkHint =>
      'Isi satu produk per baris. SKU yang sudah ada akan diperbarui.';

  @override
  String get addRow => 'Tambah baris';

  @override
  String get removeRow => 'Hapus baris';

  @override
  String get uploadBulk => 'Simpan semua';

  @override
  String bulkResult(int inserted, int updated) {
    return '$inserted ditambahkan, $updated diperbarui.';
  }

  @override
  String bulkRowError(int line, String message) {
    return 'Baris $line: $message';
  }

  @override
  String bulkDuplicate(String skus) {
    return 'SKU ganda di form: $skus';
  }

  @override
  String row(int n) {
    return 'Baris $n';
  }

  @override
  String get devicesTitle => 'Device';

  @override
  String get devicesEmpty => 'Belum ada device yang login.';

  @override
  String get allPlatforms => 'Semua platform';

  @override
  String get user => 'User';

  @override
  String get platform => 'Platform';

  @override
  String get lastActive => 'Terakhir aktif';

  @override
  String get revoke => 'Cabut';

  @override
  String revokeTitle(String name) {
    return 'Cabut device $name?';
  }

  @override
  String get revokeHint =>
      'Device ini berhenti menerima notifikasi pembayaran.';

  @override
  String get deviceRevoked => 'Device dicabut.';

  @override
  String get unknownUser => '(tanpa user)';

  @override
  String get vPositive => 'Harus lebih dari 0';

  @override
  String get vNumber => 'Masukkan angka';

  @override
  String get vBarcode => 'Hanya huruf, angka, - . _ (maks 64)';

  @override
  String get vSku => 'Maks 50 karakter';

  @override
  String get vCategoryLength => 'Maks 100 karakter';

  @override
  String get vZero => 'Isi selain 0';

  @override
  String loadFailed(String reason) {
    return 'Gagal memuat data. $reason';
  }

  @override
  String get debtPaid => 'Lunas';

  @override
  String get debtUnpaid => 'Belum lunas';
}

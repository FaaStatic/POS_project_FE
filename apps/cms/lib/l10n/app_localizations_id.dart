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

  @override
  String get transactionsEmpty => 'Belum ada transaksi pada filter ini.';

  @override
  String get allMethods => 'Semua metode';

  @override
  String get invoice => 'No. invoice';

  @override
  String get searchInvoice => 'Cari no. invoice';

  @override
  String get date => 'Tanggal';

  @override
  String get method => 'Metode';

  @override
  String get total => 'Total';

  @override
  String get profit => 'Laba kotor';

  @override
  String get conflictOnly => 'Konflik stok';

  @override
  String get conflict => 'Konflik stok';

  @override
  String get reviewed => 'Sudah ditinjau';

  @override
  String get markReviewed => 'Tandai sudah ditinjau';

  @override
  String get markedReviewed => 'Ditandai sudah ditinjau.';

  @override
  String get conflictHint =>
      'Stok di server berhenti di 0 saat transaksi offline ini masuk. Koreksi stok produknya, lalu tandai sudah ditinjau.';

  @override
  String get transactionDetail => 'Detail transaksi';

  @override
  String get items => 'Barang';

  @override
  String get qty => 'Jumlah';

  @override
  String get price => 'Harga';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get cancelTransaction => 'Batalkan transaksi';

  @override
  String cancelTitle(String invoice) {
    return 'Batalkan $invoice?';
  }

  @override
  String get cancelReason => 'Alasan pembatalan';

  @override
  String get cancelReasonShort => 'Alasan minimal 3 karakter';

  @override
  String get cancelledOk => 'Transaksi dibatalkan.';

  @override
  String get downloadReceipt => 'Unduh struk PDF';

  @override
  String get downloaded => 'File diunduh.';

  @override
  String get cash => 'Tunai';

  @override
  String get debt => 'Hutang';

  @override
  String get qris => 'QRIS';

  @override
  String get va => 'VA';

  @override
  String get noCashierFilter => 'Filter kasir belum didukung backend.';

  @override
  String get paymentsTitle => 'Pembayaran QRIS/VA';

  @override
  String get paymentsEmpty => 'Belum ada pembayaran pada filter ini.';

  @override
  String get allStatuses => 'Semua status';

  @override
  String get status => 'Status';

  @override
  String get orderId => 'Order ID';

  @override
  String get amount => 'Jumlah';

  @override
  String get fee => 'Biaya';

  @override
  String get paidAt => 'Dibayar';

  @override
  String get checkStatus => 'Cek status';

  @override
  String statusChecked(String status) {
    return 'Status terbaru: $status';
  }

  @override
  String get psPending => 'Menunggu';

  @override
  String get psSettling => 'Diproses';

  @override
  String get psSuccess => 'Berhasil';

  @override
  String get psFailed => 'Gagal';

  @override
  String get psExpired => 'Kedaluwarsa';

  @override
  String get debtsEmpty => 'Tidak ada hutang pada filter ini.';

  @override
  String get unpaidOnly => 'Belum lunas saja';

  @override
  String get searchCustomer => 'Cari nama customer';

  @override
  String get remaining => 'Sisa';

  @override
  String get addManualDebt => 'Tambah hutang manual';

  @override
  String get receivePayment => 'Terima pembayaran';

  @override
  String get paymentAmount => 'Jumlah dibayar';

  @override
  String payFull(String amount) {
    return 'Lunasi $amount';
  }

  @override
  String paymentRecorded(String amount) {
    return 'Pembayaran dicatat. Sisa $amount.';
  }

  @override
  String get debtAdded => 'Hutang ditambahkan.';

  @override
  String get dueDate => 'Jatuh tempo (opsional)';

  @override
  String get pickCustomer => 'Pilih customer';

  @override
  String get exceedsRemaining => 'Melebihi sisa hutang.';

  @override
  String get reportsTitle => 'Laporan';

  @override
  String get monthlyReport => 'Laporan bulanan';

  @override
  String get monthlyReportHint =>
      'Penjualan, transaksi hutang, hutang manual, dan pembayaran hutang per hari.';

  @override
  String get month => 'Bulan';

  @override
  String get year => 'Tahun';

  @override
  String get download => 'Unduh PDF';

  @override
  String get downloadThisMonth => 'Unduh laporan bulan ini';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get needsAction => 'Perlu tindakan';

  @override
  String get nothingToDo => 'Tidak ada yang perlu ditindaklanjuti hari ini.';

  @override
  String openConflicts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count konflik stok belum ditinjau',
      one: '1 konflik stok belum ditinjau',
    );
    return '$_temp0';
  }

  @override
  String get oldestDebts => 'Hutang belum lunas paling lama';

  @override
  String failedPayments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pembayaran QRIS/VA gagal atau kedaluwarsa hari ini',
      one: '1 pembayaran QRIS/VA gagal atau kedaluwarsa hari ini',
    );
    return '$_temp0';
  }

  @override
  String get revenue => 'Omzet';

  @override
  String get grossProfit => 'Laba kotor';

  @override
  String get transactionCount => 'Transaksi';

  @override
  String get activeReceivables => 'Piutang aktif';

  @override
  String get rangeToday => 'Hari ini';

  @override
  String get range7 => '7 hari';

  @override
  String get range30 => '30 hari';

  @override
  String get rangeMonth => 'Bulan ini';

  @override
  String get rangeCustom => 'Custom';

  @override
  String dailyChartTitle(String range) {
    return 'Omzet dan laba kotor harian, $range';
  }

  @override
  String get topProducts => '5 produk terlaris';

  @override
  String get paymentMix => 'Pembagian metode bayar';

  @override
  String get debtFlow => 'Hutang baru dan dibayar';

  @override
  String get newDebt => 'Hutang baru';

  @override
  String get paidDebt => 'Dibayar';

  @override
  String get devicesOnline => 'Device yang sedang login';

  @override
  String get noData => 'Belum ada data pada rentang ini.';

  @override
  String get quickAddProduct => 'Tambah produk';

  @override
  String get quickAddStaff => 'Tambah staff';

  @override
  String get quickAddCustomer => 'Tambah customer';

  @override
  String get quickMonthReport => 'Unduh laporan bulan ini';

  @override
  String sold(String qty) {
    return '$qty terjual';
  }

  @override
  String get chartTable => 'Lihat sebagai tabel';

  @override
  String get importTitle => 'Impor dari file Excel atau CSV';

  @override
  String get importHint =>
      'Kolom wajib: sku, product_name, purchase_price, selling_price, selling_price_debt. Opsional: barcode, unit (pcs, gram, kg, liter, kardus, ikat), stock, category, image, product_type (physical atau digital). Maks 10.000 baris, 25 MB. SKU yang sudah ada akan diperbarui.';

  @override
  String get pickFile => 'Pilih file .xlsx atau .csv';

  @override
  String get downloadTemplate => 'Unduh template CSV';

  @override
  String importing(String name) {
    return 'Mengimpor $name…';
  }

  @override
  String get manualTitle => 'Atau isi manual';

  @override
  String get importFormat => 'Hanya file .xlsx atau .csv.';

  @override
  String get importEmpty => 'File kosong.';

  @override
  String get importTooLarge => 'File lebih dari 25 MB.';
}

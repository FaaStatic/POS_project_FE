// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'myKasir';

  @override
  String get loginTitle => 'Masuk Kasir';

  @override
  String get loginSubtitle => 'Pakai akun staf atau admin toko.';

  @override
  String get username => 'Nama pengguna';

  @override
  String get password => 'Kata sandi';

  @override
  String get signIn => 'Masuk';

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
  String get vUsernameLength => 'Nama pengguna 3–100 karakter';

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
  String get navSettings => 'Pengaturan';

  @override
  String get navCheckout => 'Transaksi';

  @override
  String get navHistory => 'Riwayat';

  @override
  String get navCustomers => 'Pelanggan';

  @override
  String get navProducts => 'Produk';

  @override
  String get searchProducts => 'Cari nama, SKU, atau pindai barcode';

  @override
  String get scan => 'Pindai';

  @override
  String get allCategories => 'Semua';

  @override
  String get add => 'Tambah';

  @override
  String stock(String qty) {
    return 'Stok $qty';
  }

  @override
  String get outOfStock => 'Stok habis';

  @override
  String get noProducts =>
      'Belum ada produk di perangkat ini. Sambungkan internet lalu tarik untuk memuat.';

  @override
  String noProductsMatch(String query) {
    return 'Tidak ada produk yang cocok dengan \"$query\".';
  }

  @override
  String get reload => 'Muat ulang';

  @override
  String cartSummary(String count, String total) {
    return '$count barang · $total';
  }

  @override
  String get viewCart => 'Lihat keranjang';

  @override
  String get cartEmpty => 'Keranjang kosong. Tambah produk dari daftar.';

  @override
  String get customer => 'Pelanggan';

  @override
  String get chooseCustomer => 'Pilih pelanggan (opsional)';

  @override
  String get noCustomer => 'Tanpa pelanggan';

  @override
  String get changeCustomer => 'Ganti';

  @override
  String get remove => 'Hapus';

  @override
  String get destination => 'Nomor tujuan';

  @override
  String get destinationRequired => 'Isi nomor tujuan';

  @override
  String stockShort(String qty) {
    return 'Stok tersisa $qty. Mungkin sudah terjual di tab lain.';
  }

  @override
  String get total => 'Total';

  @override
  String get method => 'Metode bayar';

  @override
  String get cash => 'Tunai';

  @override
  String get debt => 'Hutang';

  @override
  String get qris => 'QRIS';

  @override
  String get va => 'VA';

  @override
  String get needsInternet => 'Butuh internet';

  @override
  String get digitalCashOnly => 'Produk digital: tunai atau hutang';

  @override
  String get debtNeedsCustomer => 'Pilih pelanggan untuk hutang';

  @override
  String get pay => 'Bayar';

  @override
  String payAmount(String total) {
    return 'Bayar $total';
  }

  @override
  String get closeTab => 'Tutup tab';

  @override
  String closeTabTitle(int number, String count) {
    return 'Hapus keranjang Transaksi $number ($count barang)?';
  }

  @override
  String get closeTabWaiting =>
      'Transaksi ini menunggu pembayaran dan tidak bisa ditutup.';

  @override
  String get waitingQris => 'Menunggu QRIS';

  @override
  String get waitingVa => 'Menunggu VA';

  @override
  String get paid => 'Lunas';

  @override
  String get chooseBank => 'Pilih bank VA';

  @override
  String get scanQrHint => 'Minta pembeli pindai kode QR ini.';

  @override
  String get vaHint => 'Minta pembeli transfer ke nomor VA ini.';

  @override
  String vaNumber(String bank) {
    return 'Nomor VA $bank';
  }

  @override
  String expiresAt(String time) {
    return 'Berlaku sampai $time';
  }

  @override
  String get waitingNote =>
      'Status dipantau otomatis. Kasir boleh pindah ke tab lain.';

  @override
  String get checkNow => 'Cek sekarang';

  @override
  String get qrUnavailable =>
      'Gambar QR tidak bisa dimuat. Cek koneksi lalu tekan Cek sekarang.';

  @override
  String chargeFailed(int number) {
    return 'Pembayaran Transaksi $number gagal atau kedaluwarsa. Pilih metode lain.';
  }

  @override
  String chargePaid(int number) {
    return 'Transaksi $number lunas.';
  }

  @override
  String scanAdded(String name, int number) {
    return '$name → Transaksi $number';
  }

  @override
  String unknownBarcode(String code) {
    return 'Produk belum terdaftar ($code)';
  }

  @override
  String get assignBarcode => 'Daftarkan barcode ke produk';

  @override
  String assignBarcodeTitle(String code) {
    return 'Daftarkan barcode $code';
  }

  @override
  String barcodeAssigned(String name) {
    return 'Barcode didaftarkan ke $name.';
  }

  @override
  String get tabLocked => 'Tab ini terkunci karena menunggu pembayaran.';

  @override
  String staleDraftsRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transaksi lama dihapus',
      one: '1 transaksi lama dihapus',
    );
    return '$_temp0';
  }

  @override
  String get openTabs => 'Transaksi terbuka';

  @override
  String get savedOffline => 'Tersimpan di perangkat. Dikirim saat online.';

  @override
  String get saved => 'Transaksi tersimpan.';

  @override
  String get timeoutUnknown =>
      'Server tidak menjawab. Transaksi mungkin sudah tercatat. Cek Riwayat sebelum mengulang.';

  @override
  String get vEmptyCart => 'Keranjang masih kosong.';

  @override
  String get vInvalidQty => 'Jumlah barang harus lebih dari 0.';

  @override
  String get receipt => 'Struk';

  @override
  String get print => 'Cetak struk';

  @override
  String get reprint => 'Cetak ulang';

  @override
  String get setupPrinter => 'Atur printer';

  @override
  String get done => 'Selesai';

  @override
  String get printed => 'Struk dicetak.';

  @override
  String get printFailed =>
      'Gagal mencetak. Pastikan printer menyala dan terhubung.';

  @override
  String get receiptNumber => 'No.';

  @override
  String get receiptMarkPaid => 'LUNAS';

  @override
  String get receiptMarkDebt => 'HUTANG';

  @override
  String get receiptMarkCancelled => 'DIBATALKAN';

  @override
  String get receiptDate => 'Tanggal';

  @override
  String get receiptCashier => 'Kasir';

  @override
  String get receiptCustomer => 'Pelanggan';

  @override
  String get receiptTotal => 'TOTAL';

  @override
  String get receiptMethod => 'Bayar';

  @override
  String get receiptOfflineNote => 'Nomor sementara, diganti setelah sinkron';

  @override
  String get storeNameMissing => 'Nama toko belum diatur';

  @override
  String get historyTitle => 'Riwayat transaksi';

  @override
  String get historyEmpty => 'Belum ada transaksi di perangkat ini.';

  @override
  String get statusPending => 'Belum terkirim';

  @override
  String get statusSynced => 'Terkirim';

  @override
  String get statusFailed => 'Ditolak server';

  @override
  String get statusCancelled => 'Dibatalkan';

  @override
  String get stockConflict => 'Konflik stok';

  @override
  String get cancelSale => 'Batalkan transaksi';

  @override
  String cancelSaleTitle(String number) {
    return 'Batalkan $number?';
  }

  @override
  String get cancelReason => 'Alasan pembatalan';

  @override
  String get cancelReasonShort => 'Alasan minimal 3 karakter';

  @override
  String get cancelled => 'Transaksi dibatalkan.';

  @override
  String get cancelNeedsInternet =>
      'Transaksi yang sudah terkirim hanya bisa dibatalkan saat online.';

  @override
  String syncError(String error) {
    return 'Alasan: $error';
  }

  @override
  String get syncNow => 'Sinkronkan sekarang';

  @override
  String syncPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transaksi belum terkirim',
      zero: 'Semua transaksi sudah terkirim',
    );
    return '$_temp0';
  }

  @override
  String syncDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transaksi terkirim',
      one: '1 transaksi terkirim',
      zero: 'Tidak ada yang perlu dikirim',
    );
    return '$_temp0';
  }

  @override
  String get customersTitle => 'Pelanggan';

  @override
  String get searchCustomers => 'Cari nama atau nomor HP';

  @override
  String get customersEmpty => 'Belum ada pelanggan.';

  @override
  String get addCustomer => 'Tambah pelanggan';

  @override
  String get customerName => 'Nama';

  @override
  String get customerPhone => 'Nomor HP';

  @override
  String get customerAddress => 'Alamat';

  @override
  String get save => 'Simpan';

  @override
  String get customerSaved => 'Pelanggan disimpan.';

  @override
  String get onlineOnly => 'Fitur ini butuh internet.';

  @override
  String outstanding(String amount) {
    return 'Hutang aktif $amount';
  }

  @override
  String get debtsTitle => 'Hutang';

  @override
  String get noDebts => 'Tidak ada hutang.';

  @override
  String remaining(String amount, String total) {
    return 'Sisa $amount dari $total';
  }

  @override
  String get paymentAmount => 'Jumlah dibayar';

  @override
  String payFull(String amount) {
    return 'Lunasi $amount';
  }

  @override
  String get exceedsRemaining => 'Melebihi sisa hutang.';

  @override
  String get productsTitle => 'Produk';

  @override
  String get editProduct => 'Ubah produk';

  @override
  String get productName => 'Nama produk';

  @override
  String get sku => 'SKU';

  @override
  String get barcode => 'Barcode';

  @override
  String get unit => 'Satuan';

  @override
  String get sellingPrice => 'Harga jual';

  @override
  String get debtPrice => 'Harga hutang';

  @override
  String get purchasePrice => 'Harga beli';

  @override
  String get productType => 'Tipe produk';

  @override
  String get physical => 'Fisik';

  @override
  String get digital => 'Digital';

  @override
  String get category => 'Kategori';

  @override
  String get newCategory => 'Kategori baru';

  @override
  String get stockAdjust => 'Ubah stok (+/-)';

  @override
  String get productSaved => 'Produk disimpan.';

  @override
  String get superOnly => 'Hanya admin';

  @override
  String get vPositive => 'Harus lebih dari 0';

  @override
  String get vBarcode => 'Hanya huruf, angka, - . _ (maks 64)';

  @override
  String get vSku => 'Maks 50 karakter';

  @override
  String get vNumber => 'Masukkan angka';

  @override
  String get pickCustomerHint => 'Pilih pelanggan untuk melihat detailnya.';

  @override
  String get pickSaleHint => 'Pilih transaksi untuk melihat struknya.';

  @override
  String get pickSettingHint => 'Pilih menu di kiri untuk membukanya.';

  @override
  String appVersionLabel(String version) {
    return 'Versi $version';
  }

  @override
  String environmentLabel(String name) {
    return 'Lingkungan: $name';
  }

  @override
  String get storeInfo => 'Info toko di struk';

  @override
  String get storeName => 'Nama toko';

  @override
  String get storeAddress => 'Alamat toko';

  @override
  String get storeFooter => 'Catatan kaki struk';

  @override
  String get printerTitle => 'Printer';

  @override
  String get choosePrinter => 'Pilih printer Bluetooth';

  @override
  String get noPrinter => 'Belum ada printer';

  @override
  String get paperWidth => 'Lebar kertas';

  @override
  String get autoPrint => 'Cetak otomatis setelah bayar';

  @override
  String get testPrint => 'Cetak tes';

  @override
  String get saved2 => 'Tersimpan.';

  @override
  String logoutBlocked(int number) {
    return 'Transaksi $number masih menunggu pembayaran. Selesaikan atau tunggu sampai kedaluwarsa dulu.';
  }

  @override
  String logoutConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transaksi terbuka',
      one: '1 transaksi terbuka',
    );
    return 'Hapus $_temp0 dan keluar?';
  }

  @override
  String logoutPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count transaksi belum terkirim akan dikirim saat ada yang masuk lagi di HP ini.',
      one: '1 transaksi belum terkirim akan dikirim saat ada yang masuk lagi di HP ini.',
    );
    return '$_temp0';
  }

  @override
  String get logoutAnyway => 'Keluar';

  @override
  String get paymentPushSuccess => 'Pembayaran berhasil';

  @override
  String get paymentPushFailed => 'Pembayaran gagal';

  @override
  String get open => 'Buka';

  @override
  String inCart(String qty) {
    return '$qty di keranjang';
  }

  @override
  String get cartEmptyShort => 'Keranjang kosong';

  @override
  String get toPayment => 'Lanjut ke pembayaran';

  @override
  String get payment => 'Pembayaran';

  @override
  String get totalAmount => 'Total bayar';

  @override
  String itemsCount(String count) {
    return '$count barang';
  }

  @override
  String get cashHint => 'Bayar di kasir';

  @override
  String get debtHint => 'Dicatat sebagai hutang pelanggan';

  @override
  String get qrisHint => 'Pembeli pindai kode QR';

  @override
  String get vaHint2 => 'Transfer ke nomor virtual account';

  @override
  String get cashReceived => 'Uang diterima';

  @override
  String get exactAmount => 'Uang pas';

  @override
  String get change => 'Kembalian';

  @override
  String shortBy(String amount) {
    return 'Kurang $amount';
  }

  @override
  String outOfStockAdd(String name) {
    return '$name stoknya habis, tidak bisa ditambahkan ke keranjang.';
  }

  @override
  String get changeCash => 'Tunai';

  @override
  String get changeCandy => 'Permen';

  @override
  String get changeProduct => 'Produk lain';

  @override
  String get addChange => 'Tambah kembalian';

  @override
  String changeToGive(String amount) {
    return 'Kembalian $amount';
  }

  @override
  String changeRemaining(String amount) {
    return 'Belum dibagi $amount';
  }

  @override
  String get changeComplete => 'Kembalian sudah pas';

  @override
  String changeOverBy(String amount) {
    return 'Lebih $amount dari kembalian';
  }

  @override
  String get changeAddRestCash => 'Sisa sebagai tunai';

  @override
  String get changeAmount => 'Nominal tunai';

  @override
  String get changePickProduct => 'Pilih produk';

  @override
  String get changeNoProducts => 'Tidak ada produk fisik dengan stok.';

  @override
  String get changeQty => 'Jumlah';

  @override
  String changeValue(String amount) {
    return 'Senilai $amount';
  }

  @override
  String get changeSheetTitle => 'Tambah kembalian';

  @override
  String get vAmountPaidShort => 'Uang diterima kurang dari total.';

  @override
  String get vAmountPaidRequired =>
      'Isi uang diterima untuk mencatat kembalian.';

  @override
  String get vChangeMismatch =>
      'Rincian kembalian belum sama dengan kembalian yang harus diberikan.';

  @override
  String get vChangeInvalid => 'Ada baris kembalian yang tidak valid.';

  @override
  String get vChangeTooMany => 'Kembalian maksimal 20 baris.';

  @override
  String get vChangeCashOnly => 'Kembalian hanya untuk pembayaran tunai.';

  @override
  String get back => 'Kembali';

  @override
  String get subtotal => 'Subtotal';

  @override
  String cashierLine(String name) {
    return 'Kasir: $name';
  }

  @override
  String get checkoutTitle => 'Transaksi';

  @override
  String addItem(String name) {
    return 'Tambah $name';
  }

  @override
  String get navMore => 'Lainnya';

  @override
  String get productImage => 'Gambar produk (opsional)';

  @override
  String get imageHint => 'WebP, rasio 1:1, maks 500 KB';

  @override
  String get vImageWebp => 'Gambar harus berformat WebP.';

  @override
  String get vImageSquare => 'Gambar harus persegi (rasio 1:1).';

  @override
  String get vImageSize => 'Ukuran gambar maksimal 500 KB.';

  @override
  String get vImageDimensions => 'Sisi gambar maksimal 4000 piksel.';

  @override
  String get categoryPickHint => 'Cari atau pilih kategori';

  @override
  String get vCategoryExisting => 'Pilih kategori yang sudah ada.';

  @override
  String get receiptMarkUnpaid => 'BELUM LUNAS';

  @override
  String get receiptDebtPayment => 'PEMBAYARAN HUTANG';

  @override
  String get receiptDebtPaidNow => 'Dibayar sekarang';

  @override
  String get receiptDebtPrevious => 'Saldo sebelumnya';

  @override
  String get receiptDebtEstimate => '(saldo perkiraan)';

  @override
  String get receiptDebtOwed => 'Saldo terhutang';

  @override
  String get payDebtTab => 'Bayar hutang';

  @override
  String debtTabLabel(int number) {
    return 'Hutang $number';
  }

  @override
  String get debtTabPickCustomer => 'Pilih pelanggan';

  @override
  String get searchDebtCustomers => 'Cari pelanggan berhutang';

  @override
  String get debtsEmpty => 'Tidak ada pelanggan yang berhutang.';

  @override
  String get debtTotalOwed => 'Total hutang';

  @override
  String get debtLeft => 'Sisa hutang';

  @override
  String get debtSettledLabel => 'Hutang lunas';

  @override
  String get debtPickFromList => 'Pilih pelanggan dari daftar hutang.';

  @override
  String get debtNoDebt => 'Pelanggan ini tidak punya hutang.';

  @override
  String get debtNotSynced =>
      'Hutang ini baru dicatat di perangkat ini. Sinkronkan dulu sebelum menerima pembayaran.';

  @override
  String get historySalesTab => 'Penjualan';

  @override
  String get historyDebtTab => 'Pembayaran hutang';

  @override
  String get historyDebtEmpty =>
      'Belum ada pembayaran hutang di perangkat ini.';

  @override
  String debtLeftAmount(String amount) {
    return 'Sisa $amount';
  }

  @override
  String addDebtAmount(String total) {
    return 'Tambah hutang $total';
  }
}

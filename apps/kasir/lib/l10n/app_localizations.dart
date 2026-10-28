import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In id, this message translates to:
  /// **'myKasir'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In id, this message translates to:
  /// **'Masuk Kasir'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pakai akun staff atau admin toko.'**
  String get loginSubtitle;

  /// No description provided for @username.
  ///
  /// In id, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get signIn;

  /// No description provided for @errorNetwork.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada koneksi. Periksa internet lalu coba lagi.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In id, this message translates to:
  /// **'Server terlalu lama merespons. Coba lagi.'**
  String get errorTimeout;

  /// No description provided for @sessionExpired.
  ///
  /// In id, this message translates to:
  /// **'Sesi berakhir. Silakan masuk lagi.'**
  String get sessionExpired;

  /// No description provided for @errorUnknown.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan. Coba lagi.'**
  String get errorUnknown;

  /// No description provided for @vRequired.
  ///
  /// In id, this message translates to:
  /// **'Wajib diisi'**
  String get vRequired;

  /// No description provided for @vUsernameLength.
  ///
  /// In id, this message translates to:
  /// **'Username 3–100 karakter'**
  String get vUsernameLength;

  /// No description provided for @vPasswordLength.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi minimal 6 karakter'**
  String get vPasswordLength;

  /// No description provided for @settingsTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In id, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In id, this message translates to:
  /// **'Sistem'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In id, this message translates to:
  /// **'Terang'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In id, this message translates to:
  /// **'Gelap'**
  String get themeDark;

  /// No description provided for @logout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get logout;

  /// No description provided for @signedInAs.
  ///
  /// In id, this message translates to:
  /// **'Masuk sebagai {name}'**
  String signedInAs(String name);

  /// No description provided for @navSettings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get navSettings;

  /// No description provided for @navCheckout.
  ///
  /// In id, this message translates to:
  /// **'Transaksi'**
  String get navCheckout;

  /// No description provided for @navHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat'**
  String get navHistory;

  /// No description provided for @navCustomers.
  ///
  /// In id, this message translates to:
  /// **'Customer'**
  String get navCustomers;

  /// No description provided for @navProducts.
  ///
  /// In id, this message translates to:
  /// **'Produk'**
  String get navProducts;

  /// No description provided for @searchProducts.
  ///
  /// In id, this message translates to:
  /// **'Cari nama, SKU, atau scan barcode'**
  String get searchProducts;

  /// No description provided for @scan.
  ///
  /// In id, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @allCategories.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get allCategories;

  /// No description provided for @add.
  ///
  /// In id, this message translates to:
  /// **'Tambah'**
  String get add;

  /// No description provided for @stock.
  ///
  /// In id, this message translates to:
  /// **'Stok {qty}'**
  String stock(String qty);

  /// No description provided for @outOfStock.
  ///
  /// In id, this message translates to:
  /// **'Stok habis'**
  String get outOfStock;

  /// No description provided for @noProducts.
  ///
  /// In id, this message translates to:
  /// **'Belum ada produk di perangkat ini. Sambungkan internet lalu tarik untuk memuat.'**
  String get noProducts;

  /// No description provided for @noProductsMatch.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada produk yang cocok dengan \"{query}\".'**
  String noProductsMatch(String query);

  /// No description provided for @reload.
  ///
  /// In id, this message translates to:
  /// **'Muat ulang'**
  String get reload;

  /// No description provided for @cartSummary.
  ///
  /// In id, this message translates to:
  /// **'{count} barang · {total}'**
  String cartSummary(String count, String total);

  /// No description provided for @viewCart.
  ///
  /// In id, this message translates to:
  /// **'Lihat keranjang'**
  String get viewCart;

  /// No description provided for @cartEmpty.
  ///
  /// In id, this message translates to:
  /// **'Keranjang kosong. Tambah produk dari daftar.'**
  String get cartEmpty;

  /// No description provided for @customer.
  ///
  /// In id, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @chooseCustomer.
  ///
  /// In id, this message translates to:
  /// **'Pilih customer (opsional)'**
  String get chooseCustomer;

  /// No description provided for @noCustomer.
  ///
  /// In id, this message translates to:
  /// **'Tanpa customer'**
  String get noCustomer;

  /// No description provided for @changeCustomer.
  ///
  /// In id, this message translates to:
  /// **'Ganti'**
  String get changeCustomer;

  /// No description provided for @remove.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get remove;

  /// No description provided for @destination.
  ///
  /// In id, this message translates to:
  /// **'Nomor tujuan'**
  String get destination;

  /// No description provided for @destinationRequired.
  ///
  /// In id, this message translates to:
  /// **'Isi nomor tujuan'**
  String get destinationRequired;

  /// No description provided for @stockShort.
  ///
  /// In id, this message translates to:
  /// **'Stok tersisa {qty}. Mungkin sudah terjual di tab lain.'**
  String stockShort(String qty);

  /// No description provided for @total.
  ///
  /// In id, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @method.
  ///
  /// In id, this message translates to:
  /// **'Metode bayar'**
  String get method;

  /// No description provided for @cash.
  ///
  /// In id, this message translates to:
  /// **'Tunai'**
  String get cash;

  /// No description provided for @debt.
  ///
  /// In id, this message translates to:
  /// **'Hutang'**
  String get debt;

  /// No description provided for @qris.
  ///
  /// In id, this message translates to:
  /// **'QRIS'**
  String get qris;

  /// No description provided for @va.
  ///
  /// In id, this message translates to:
  /// **'VA'**
  String get va;

  /// No description provided for @needsInternet.
  ///
  /// In id, this message translates to:
  /// **'Butuh internet'**
  String get needsInternet;

  /// No description provided for @digitalCashOnly.
  ///
  /// In id, this message translates to:
  /// **'Produk digital: tunai atau hutang'**
  String get digitalCashOnly;

  /// No description provided for @debtNeedsCustomer.
  ///
  /// In id, this message translates to:
  /// **'Pilih customer untuk hutang'**
  String get debtNeedsCustomer;

  /// No description provided for @pay.
  ///
  /// In id, this message translates to:
  /// **'Bayar'**
  String get pay;

  /// No description provided for @payAmount.
  ///
  /// In id, this message translates to:
  /// **'Bayar {total}'**
  String payAmount(String total);

  /// No description provided for @closeTab.
  ///
  /// In id, this message translates to:
  /// **'Tutup tab'**
  String get closeTab;

  /// No description provided for @closeTabTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus keranjang Transaksi {number} ({count} barang)?'**
  String closeTabTitle(int number, String count);

  /// No description provided for @closeTabWaiting.
  ///
  /// In id, this message translates to:
  /// **'Transaksi ini menunggu pembayaran dan tidak bisa ditutup.'**
  String get closeTabWaiting;

  /// No description provided for @waitingQris.
  ///
  /// In id, this message translates to:
  /// **'Menunggu QRIS'**
  String get waitingQris;

  /// No description provided for @waitingVa.
  ///
  /// In id, this message translates to:
  /// **'Menunggu VA'**
  String get waitingVa;

  /// No description provided for @paid.
  ///
  /// In id, this message translates to:
  /// **'Lunas'**
  String get paid;

  /// No description provided for @chooseBank.
  ///
  /// In id, this message translates to:
  /// **'Pilih bank VA'**
  String get chooseBank;

  /// No description provided for @scanQrHint.
  ///
  /// In id, this message translates to:
  /// **'Minta pembeli scan kode QR ini.'**
  String get scanQrHint;

  /// No description provided for @vaHint.
  ///
  /// In id, this message translates to:
  /// **'Minta pembeli transfer ke nomor VA ini.'**
  String get vaHint;

  /// No description provided for @vaNumber.
  ///
  /// In id, this message translates to:
  /// **'Nomor VA {bank}'**
  String vaNumber(String bank);

  /// No description provided for @expiresAt.
  ///
  /// In id, this message translates to:
  /// **'Berlaku sampai {time}'**
  String expiresAt(String time);

  /// No description provided for @waitingNote.
  ///
  /// In id, this message translates to:
  /// **'Status dipantau otomatis. Kasir boleh pindah ke tab lain.'**
  String get waitingNote;

  /// No description provided for @checkNow.
  ///
  /// In id, this message translates to:
  /// **'Cek sekarang'**
  String get checkNow;

  /// No description provided for @qrUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Gambar QR tidak bisa dimuat. Cek koneksi lalu tekan Cek sekarang.'**
  String get qrUnavailable;

  /// No description provided for @chargeFailed.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran Transaksi {number} gagal atau kedaluwarsa. Pilih metode lain.'**
  String chargeFailed(int number);

  /// No description provided for @chargePaid.
  ///
  /// In id, this message translates to:
  /// **'Transaksi {number} lunas.'**
  String chargePaid(int number);

  /// No description provided for @scanAdded.
  ///
  /// In id, this message translates to:
  /// **'{name} → Transaksi {number}'**
  String scanAdded(String name, int number);

  /// No description provided for @unknownBarcode.
  ///
  /// In id, this message translates to:
  /// **'Produk belum terdaftar ({code})'**
  String unknownBarcode(String code);

  /// No description provided for @assignBarcode.
  ///
  /// In id, this message translates to:
  /// **'Daftarkan barcode ke produk'**
  String get assignBarcode;

  /// No description provided for @assignBarcodeTitle.
  ///
  /// In id, this message translates to:
  /// **'Daftarkan barcode {code}'**
  String assignBarcodeTitle(String code);

  /// No description provided for @barcodeAssigned.
  ///
  /// In id, this message translates to:
  /// **'Barcode didaftarkan ke {name}.'**
  String barcodeAssigned(String name);

  /// No description provided for @tabLocked.
  ///
  /// In id, this message translates to:
  /// **'Tab ini terkunci karena menunggu pembayaran.'**
  String get tabLocked;

  /// No description provided for @staleDraftsRemoved.
  ///
  /// In id, this message translates to:
  /// **'{count, plural, =1{1 transaksi lama dihapus} other{{count} transaksi lama dihapus}}'**
  String staleDraftsRemoved(int count);

  /// No description provided for @openTabs.
  ///
  /// In id, this message translates to:
  /// **'Transaksi terbuka'**
  String get openTabs;

  /// No description provided for @savedOffline.
  ///
  /// In id, this message translates to:
  /// **'Tersimpan di perangkat. Dikirim saat online.'**
  String get savedOffline;

  /// No description provided for @saved.
  ///
  /// In id, this message translates to:
  /// **'Transaksi tersimpan.'**
  String get saved;

  /// No description provided for @timeoutUnknown.
  ///
  /// In id, this message translates to:
  /// **'Server tidak menjawab. Transaksi mungkin sudah tercatat. Cek Riwayat sebelum mengulang.'**
  String get timeoutUnknown;

  /// No description provided for @vEmptyCart.
  ///
  /// In id, this message translates to:
  /// **'Keranjang masih kosong.'**
  String get vEmptyCart;

  /// No description provided for @vInvalidQty.
  ///
  /// In id, this message translates to:
  /// **'Jumlah barang harus lebih dari 0.'**
  String get vInvalidQty;

  /// No description provided for @receipt.
  ///
  /// In id, this message translates to:
  /// **'Struk'**
  String get receipt;

  /// No description provided for @print.
  ///
  /// In id, this message translates to:
  /// **'Cetak struk'**
  String get print;

  /// No description provided for @reprint.
  ///
  /// In id, this message translates to:
  /// **'Cetak ulang'**
  String get reprint;

  /// No description provided for @setupPrinter.
  ///
  /// In id, this message translates to:
  /// **'Atur printer'**
  String get setupPrinter;

  /// No description provided for @done.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get done;

  /// No description provided for @printed.
  ///
  /// In id, this message translates to:
  /// **'Struk dicetak.'**
  String get printed;

  /// No description provided for @printFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal mencetak. Pastikan printer menyala dan terhubung.'**
  String get printFailed;

  /// No description provided for @receiptNumber.
  ///
  /// In id, this message translates to:
  /// **'No.'**
  String get receiptNumber;

  /// No description provided for @receiptDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal'**
  String get receiptDate;

  /// No description provided for @receiptCashier.
  ///
  /// In id, this message translates to:
  /// **'Kasir'**
  String get receiptCashier;

  /// No description provided for @receiptCustomer.
  ///
  /// In id, this message translates to:
  /// **'Customer'**
  String get receiptCustomer;

  /// No description provided for @receiptTotal.
  ///
  /// In id, this message translates to:
  /// **'TOTAL'**
  String get receiptTotal;

  /// No description provided for @receiptMethod.
  ///
  /// In id, this message translates to:
  /// **'Bayar'**
  String get receiptMethod;

  /// No description provided for @receiptOfflineNote.
  ///
  /// In id, this message translates to:
  /// **'Nomor sementara, diganti setelah sync'**
  String get receiptOfflineNote;

  /// No description provided for @storeNameMissing.
  ///
  /// In id, this message translates to:
  /// **'Nama toko belum diatur'**
  String get storeNameMissing;

  /// No description provided for @historyTitle.
  ///
  /// In id, this message translates to:
  /// **'Riwayat transaksi'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada transaksi di perangkat ini.'**
  String get historyEmpty;

  /// No description provided for @statusPending.
  ///
  /// In id, this message translates to:
  /// **'Belum terkirim'**
  String get statusPending;

  /// No description provided for @statusSynced.
  ///
  /// In id, this message translates to:
  /// **'Terkirim'**
  String get statusSynced;

  /// No description provided for @statusFailed.
  ///
  /// In id, this message translates to:
  /// **'Ditolak server'**
  String get statusFailed;

  /// No description provided for @statusCancelled.
  ///
  /// In id, this message translates to:
  /// **'Dibatalkan'**
  String get statusCancelled;

  /// No description provided for @stockConflict.
  ///
  /// In id, this message translates to:
  /// **'Konflik stok'**
  String get stockConflict;

  /// No description provided for @cancelSale.
  ///
  /// In id, this message translates to:
  /// **'Batalkan transaksi'**
  String get cancelSale;

  /// No description provided for @cancelSaleTitle.
  ///
  /// In id, this message translates to:
  /// **'Batalkan {number}?'**
  String cancelSaleTitle(String number);

  /// No description provided for @cancelReason.
  ///
  /// In id, this message translates to:
  /// **'Alasan pembatalan'**
  String get cancelReason;

  /// No description provided for @cancelReasonShort.
  ///
  /// In id, this message translates to:
  /// **'Alasan minimal 3 karakter'**
  String get cancelReasonShort;

  /// No description provided for @cancelled.
  ///
  /// In id, this message translates to:
  /// **'Transaksi dibatalkan.'**
  String get cancelled;

  /// No description provided for @cancelNeedsInternet.
  ///
  /// In id, this message translates to:
  /// **'Transaksi yang sudah terkirim hanya bisa dibatalkan saat online.'**
  String get cancelNeedsInternet;

  /// No description provided for @syncError.
  ///
  /// In id, this message translates to:
  /// **'Alasan: {error}'**
  String syncError(String error);

  /// No description provided for @syncNow.
  ///
  /// In id, this message translates to:
  /// **'Sync sekarang'**
  String get syncNow;

  /// No description provided for @syncDone.
  ///
  /// In id, this message translates to:
  /// **'{count, plural, =0{Tidak ada yang perlu dikirim} =1{1 transaksi terkirim} other{{count} transaksi terkirim}}'**
  String syncDone(int count);

  /// No description provided for @customersTitle.
  ///
  /// In id, this message translates to:
  /// **'Customer'**
  String get customersTitle;

  /// No description provided for @searchCustomers.
  ///
  /// In id, this message translates to:
  /// **'Cari nama atau nomor HP'**
  String get searchCustomers;

  /// No description provided for @customersEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada customer.'**
  String get customersEmpty;

  /// No description provided for @addCustomer.
  ///
  /// In id, this message translates to:
  /// **'Tambah customer'**
  String get addCustomer;

  /// No description provided for @customerName.
  ///
  /// In id, this message translates to:
  /// **'Nama'**
  String get customerName;

  /// No description provided for @customerPhone.
  ///
  /// In id, this message translates to:
  /// **'Nomor HP'**
  String get customerPhone;

  /// No description provided for @customerAddress.
  ///
  /// In id, this message translates to:
  /// **'Alamat'**
  String get customerAddress;

  /// No description provided for @save.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get save;

  /// No description provided for @customerSaved.
  ///
  /// In id, this message translates to:
  /// **'Customer disimpan.'**
  String get customerSaved;

  /// No description provided for @onlineOnly.
  ///
  /// In id, this message translates to:
  /// **'Fitur ini butuh internet.'**
  String get onlineOnly;

  /// No description provided for @outstanding.
  ///
  /// In id, this message translates to:
  /// **'Hutang aktif {amount}'**
  String outstanding(String amount);

  /// No description provided for @debtsTitle.
  ///
  /// In id, this message translates to:
  /// **'Hutang'**
  String get debtsTitle;

  /// No description provided for @noDebts.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada hutang.'**
  String get noDebts;

  /// No description provided for @remaining.
  ///
  /// In id, this message translates to:
  /// **'Sisa {amount} dari {total}'**
  String remaining(String amount, String total);

  /// No description provided for @receivePayment.
  ///
  /// In id, this message translates to:
  /// **'Terima pembayaran tunai'**
  String get receivePayment;

  /// No description provided for @paymentAmount.
  ///
  /// In id, this message translates to:
  /// **'Jumlah dibayar'**
  String get paymentAmount;

  /// No description provided for @payFull.
  ///
  /// In id, this message translates to:
  /// **'Lunasi {amount}'**
  String payFull(String amount);

  /// No description provided for @paymentRecorded.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran dicatat. Sisa {amount}.'**
  String paymentRecorded(String amount);

  /// No description provided for @exceedsRemaining.
  ///
  /// In id, this message translates to:
  /// **'Melebihi sisa hutang.'**
  String get exceedsRemaining;

  /// No description provided for @productsTitle.
  ///
  /// In id, this message translates to:
  /// **'Produk'**
  String get productsTitle;

  /// No description provided for @editProduct.
  ///
  /// In id, this message translates to:
  /// **'Edit produk'**
  String get editProduct;

  /// No description provided for @productName.
  ///
  /// In id, this message translates to:
  /// **'Nama produk'**
  String get productName;

  /// No description provided for @sku.
  ///
  /// In id, this message translates to:
  /// **'SKU'**
  String get sku;

  /// No description provided for @barcode.
  ///
  /// In id, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @unit.
  ///
  /// In id, this message translates to:
  /// **'Satuan'**
  String get unit;

  /// No description provided for @sellingPrice.
  ///
  /// In id, this message translates to:
  /// **'Harga jual'**
  String get sellingPrice;

  /// No description provided for @debtPrice.
  ///
  /// In id, this message translates to:
  /// **'Harga hutang'**
  String get debtPrice;

  /// No description provided for @purchasePrice.
  ///
  /// In id, this message translates to:
  /// **'Harga beli'**
  String get purchasePrice;

  /// No description provided for @productType.
  ///
  /// In id, this message translates to:
  /// **'Tipe produk'**
  String get productType;

  /// No description provided for @physical.
  ///
  /// In id, this message translates to:
  /// **'Fisik'**
  String get physical;

  /// No description provided for @digital.
  ///
  /// In id, this message translates to:
  /// **'Digital'**
  String get digital;

  /// No description provided for @category.
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get category;

  /// No description provided for @newCategory.
  ///
  /// In id, this message translates to:
  /// **'Kategori baru'**
  String get newCategory;

  /// No description provided for @stockAdjust.
  ///
  /// In id, this message translates to:
  /// **'Ubah stok (+/-)'**
  String get stockAdjust;

  /// No description provided for @productSaved.
  ///
  /// In id, this message translates to:
  /// **'Produk disimpan.'**
  String get productSaved;

  /// No description provided for @superOnly.
  ///
  /// In id, this message translates to:
  /// **'Hanya admin'**
  String get superOnly;

  /// No description provided for @vPositive.
  ///
  /// In id, this message translates to:
  /// **'Harus lebih dari 0'**
  String get vPositive;

  /// No description provided for @vBarcode.
  ///
  /// In id, this message translates to:
  /// **'Hanya huruf, angka, - . _ (maks 64)'**
  String get vBarcode;

  /// No description provided for @vSku.
  ///
  /// In id, this message translates to:
  /// **'Maks 50 karakter'**
  String get vSku;

  /// No description provided for @vNumber.
  ///
  /// In id, this message translates to:
  /// **'Masukkan angka'**
  String get vNumber;

  /// No description provided for @storeInfo.
  ///
  /// In id, this message translates to:
  /// **'Info toko di struk'**
  String get storeInfo;

  /// No description provided for @storeName.
  ///
  /// In id, this message translates to:
  /// **'Nama toko'**
  String get storeName;

  /// No description provided for @storeAddress.
  ///
  /// In id, this message translates to:
  /// **'Alamat toko'**
  String get storeAddress;

  /// No description provided for @storeFooter.
  ///
  /// In id, this message translates to:
  /// **'Catatan kaki struk'**
  String get storeFooter;

  /// No description provided for @printerTitle.
  ///
  /// In id, this message translates to:
  /// **'Printer'**
  String get printerTitle;

  /// No description provided for @choosePrinter.
  ///
  /// In id, this message translates to:
  /// **'Pilih printer Bluetooth'**
  String get choosePrinter;

  /// No description provided for @noPrinter.
  ///
  /// In id, this message translates to:
  /// **'Belum ada printer'**
  String get noPrinter;

  /// No description provided for @paperWidth.
  ///
  /// In id, this message translates to:
  /// **'Lebar kertas'**
  String get paperWidth;

  /// No description provided for @autoPrint.
  ///
  /// In id, this message translates to:
  /// **'Cetak otomatis setelah bayar'**
  String get autoPrint;

  /// No description provided for @testPrint.
  ///
  /// In id, this message translates to:
  /// **'Cetak tes'**
  String get testPrint;

  /// No description provided for @saved2.
  ///
  /// In id, this message translates to:
  /// **'Tersimpan.'**
  String get saved2;

  /// No description provided for @logoutBlocked.
  ///
  /// In id, this message translates to:
  /// **'Transaksi {number} masih menunggu pembayaran. Selesaikan atau tunggu sampai kedaluwarsa dulu.'**
  String logoutBlocked(int number);

  /// No description provided for @logoutConfirm.
  ///
  /// In id, this message translates to:
  /// **'Hapus {count, plural, =1{1 transaksi terbuka} other{{count} transaksi terbuka}} dan keluar?'**
  String logoutConfirm(int count);

  /// No description provided for @logoutPending.
  ///
  /// In id, this message translates to:
  /// **'{count, plural, =1{1 transaksi belum terkirim akan dikirim saat ada yang masuk lagi di HP ini.} other{{count} transaksi belum terkirim akan dikirim saat ada yang masuk lagi di HP ini.}}'**
  String logoutPending(int count);

  /// No description provided for @logoutAnyway.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get logoutAnyway;

  /// No description provided for @paymentPushSuccess.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran berhasil'**
  String get paymentPushSuccess;

  /// No description provided for @paymentPushFailed.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran gagal'**
  String get paymentPushFailed;

  /// No description provided for @open.
  ///
  /// In id, this message translates to:
  /// **'Buka'**
  String get open;

  /// No description provided for @inCart.
  ///
  /// In id, this message translates to:
  /// **'{qty} di keranjang'**
  String inCart(String qty);

  /// No description provided for @cartEmptyShort.
  ///
  /// In id, this message translates to:
  /// **'Keranjang kosong'**
  String get cartEmptyShort;

  /// No description provided for @toPayment.
  ///
  /// In id, this message translates to:
  /// **'Lanjut ke pembayaran'**
  String get toPayment;

  /// No description provided for @payment.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran'**
  String get payment;

  /// No description provided for @totalAmount.
  ///
  /// In id, this message translates to:
  /// **'Total bayar'**
  String get totalAmount;

  /// No description provided for @itemsCount.
  ///
  /// In id, this message translates to:
  /// **'{count} barang'**
  String itemsCount(String count);

  /// No description provided for @cashHint.
  ///
  /// In id, this message translates to:
  /// **'Bayar di kasir'**
  String get cashHint;

  /// No description provided for @debtHint.
  ///
  /// In id, this message translates to:
  /// **'Dicatat sebagai hutang customer'**
  String get debtHint;

  /// No description provided for @qrisHint.
  ///
  /// In id, this message translates to:
  /// **'Pembeli scan kode QR'**
  String get qrisHint;

  /// No description provided for @vaHint2.
  ///
  /// In id, this message translates to:
  /// **'Transfer ke nomor virtual account'**
  String get vaHint2;

  /// No description provided for @cashReceived.
  ///
  /// In id, this message translates to:
  /// **'Uang diterima'**
  String get cashReceived;

  /// No description provided for @exactAmount.
  ///
  /// In id, this message translates to:
  /// **'Uang pas'**
  String get exactAmount;

  /// No description provided for @change.
  ///
  /// In id, this message translates to:
  /// **'Kembalian'**
  String get change;

  /// No description provided for @shortBy.
  ///
  /// In id, this message translates to:
  /// **'Kurang {amount}'**
  String shortBy(String amount);

  /// No description provided for @back.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get back;

  /// No description provided for @subtotal.
  ///
  /// In id, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @cashierLine.
  ///
  /// In id, this message translates to:
  /// **'Kasir: {name}'**
  String cashierLine(String name);

  /// No description provided for @checkoutTitle.
  ///
  /// In id, this message translates to:
  /// **'Transaksi'**
  String get checkoutTitle;

  /// No description provided for @addItem.
  ///
  /// In id, this message translates to:
  /// **'Tambah {name}'**
  String addItem(String name);

  /// No description provided for @navMore.
  ///
  /// In id, this message translates to:
  /// **'Lainnya'**
  String get navMore;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

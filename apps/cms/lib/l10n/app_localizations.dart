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
  /// **'Shop CMS'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In id, this message translates to:
  /// **'Masuk ke CMS'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Khusus admin toko. Kasir memakai aplikasi Kasir di HP.'**
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

  /// No description provided for @cmsAdminOnly.
  ///
  /// In id, this message translates to:
  /// **'CMS khusus admin toko. Akun staff hanya bisa masuk lewat aplikasi Kasir.'**
  String get cmsAdminOnly;

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

  /// No description provided for @openMenu.
  ///
  /// In id, this message translates to:
  /// **'Buka menu'**
  String get openMenu;

  /// No description provided for @navSettings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get navSettings;

  /// No description provided for @navDashboard.
  ///
  /// In id, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navTransactions.
  ///
  /// In id, this message translates to:
  /// **'Transaksi'**
  String get navTransactions;

  /// No description provided for @navProducts.
  ///
  /// In id, this message translates to:
  /// **'Produk'**
  String get navProducts;

  /// No description provided for @navCategories.
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get navCategories;

  /// No description provided for @navCustomers.
  ///
  /// In id, this message translates to:
  /// **'Customer'**
  String get navCustomers;

  /// No description provided for @navDebts.
  ///
  /// In id, this message translates to:
  /// **'Hutang'**
  String get navDebts;

  /// No description provided for @navStaff.
  ///
  /// In id, this message translates to:
  /// **'Staff'**
  String get navStaff;

  /// No description provided for @navPayments.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran'**
  String get navPayments;

  /// No description provided for @navDevices.
  ///
  /// In id, this message translates to:
  /// **'Device'**
  String get navDevices;

  /// No description provided for @navReports.
  ///
  /// In id, this message translates to:
  /// **'Laporan'**
  String get navReports;

  /// No description provided for @navGroupSales.
  ///
  /// In id, this message translates to:
  /// **'Penjualan'**
  String get navGroupSales;

  /// No description provided for @navGroupCatalog.
  ///
  /// In id, this message translates to:
  /// **'Katalog'**
  String get navGroupCatalog;

  /// No description provided for @navGroupPeople.
  ///
  /// In id, this message translates to:
  /// **'Pengguna'**
  String get navGroupPeople;

  /// No description provided for @navGroupOther.
  ///
  /// In id, this message translates to:
  /// **'Lainnya'**
  String get navGroupOther;

  /// No description provided for @active.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In id, this message translates to:
  /// **'Nonaktif'**
  String get inactive;

  /// No description provided for @search.
  ///
  /// In id, this message translates to:
  /// **'Cari'**
  String get search;

  /// No description provided for @actions.
  ///
  /// In id, this message translates to:
  /// **'Aksi'**
  String get actions;

  /// No description provided for @save.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get save;

  /// No description provided for @saved.
  ///
  /// In id, this message translates to:
  /// **'Tersimpan.'**
  String get saved;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In id, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @restore.
  ///
  /// In id, this message translates to:
  /// **'Pulihkan'**
  String get restore;

  /// No description provided for @deactivate.
  ///
  /// In id, this message translates to:
  /// **'Nonaktifkan'**
  String get deactivate;

  /// No description provided for @purge.
  ///
  /// In id, this message translates to:
  /// **'Hapus permanen'**
  String get purge;

  /// No description provided for @retry.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get retry;

  /// No description provided for @createdAt.
  ///
  /// In id, this message translates to:
  /// **'Dibuat'**
  String get createdAt;

  /// No description provided for @role.
  ///
  /// In id, this message translates to:
  /// **'Peran'**
  String get role;

  /// No description provided for @roleSuper.
  ///
  /// In id, this message translates to:
  /// **'Admin'**
  String get roleSuper;

  /// No description provided for @roleStaff.
  ///
  /// In id, this message translates to:
  /// **'Staff'**
  String get roleStaff;

  /// No description provided for @staffTitle.
  ///
  /// In id, this message translates to:
  /// **'Staff'**
  String get staffTitle;

  /// No description provided for @addStaff.
  ///
  /// In id, this message translates to:
  /// **'Tambah staff'**
  String get addStaff;

  /// No description provided for @staffEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada staff. Tambah staff pertama.'**
  String get staffEmpty;

  /// No description provided for @staffInactiveEmpty.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada staff nonaktif.'**
  String get staffInactiveEmpty;

  /// No description provided for @resetPassword.
  ///
  /// In id, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @newPassword.
  ///
  /// In id, this message translates to:
  /// **'Password baru'**
  String get newPassword;

  /// No description provided for @resetPasswordHint.
  ///
  /// In id, this message translates to:
  /// **'Semua sesi staff ini akan keluar.'**
  String get resetPasswordHint;

  /// No description provided for @passwordReset.
  ///
  /// In id, this message translates to:
  /// **'Password diganti. Sesi staff ini dicabut.'**
  String get passwordReset;

  /// No description provided for @staffAdded.
  ///
  /// In id, this message translates to:
  /// **'Staff ditambahkan.'**
  String get staffAdded;

  /// No description provided for @staffDeactivated.
  ///
  /// In id, this message translates to:
  /// **'Staff dinonaktifkan. Sesi dan token notifikasinya dicabut.'**
  String get staffDeactivated;

  /// No description provided for @staffRestored.
  ///
  /// In id, this message translates to:
  /// **'Staff dipulihkan.'**
  String get staffRestored;

  /// No description provided for @purgeTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus permanen {name}?'**
  String purgeTitle(String name);

  /// No description provided for @purgeStaffHint.
  ///
  /// In id, this message translates to:
  /// **'Staff tanpa riwayat transaksi dihapus. Staff dengan riwayat dianonimkan supaya laporan lama tetap utuh.'**
  String get purgeStaffHint;

  /// No description provided for @purgeTypeName.
  ///
  /// In id, this message translates to:
  /// **'Ketik {name} untuk konfirmasi'**
  String purgeTypeName(String name);

  /// No description provided for @purgeMismatch.
  ///
  /// In id, this message translates to:
  /// **'Nama tidak cocok.'**
  String get purgeMismatch;

  /// No description provided for @purgedDeleted.
  ///
  /// In id, this message translates to:
  /// **'Dihapus permanen.'**
  String get purgedDeleted;

  /// No description provided for @purgedAnonymized.
  ///
  /// In id, this message translates to:
  /// **'Punya riwayat transaksi, jadi dianonimkan.'**
  String get purgedAnonymized;

  /// No description provided for @customersTitle.
  ///
  /// In id, this message translates to:
  /// **'Customer'**
  String get customersTitle;

  /// No description provided for @addCustomer.
  ///
  /// In id, this message translates to:
  /// **'Tambah customer'**
  String get addCustomer;

  /// No description provided for @editCustomer.
  ///
  /// In id, this message translates to:
  /// **'Edit customer'**
  String get editCustomer;

  /// No description provided for @customersEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada customer. Tambah customer pertama.'**
  String get customersEmpty;

  /// No description provided for @customersInactiveEmpty.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada customer nonaktif.'**
  String get customersInactiveEmpty;

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

  /// No description provided for @customerHasDebt.
  ///
  /// In id, this message translates to:
  /// **'Customer masih punya hutang aktif, tidak bisa dihapus permanen.'**
  String get customerHasDebt;

  /// No description provided for @purgeCustomerHint.
  ///
  /// In id, this message translates to:
  /// **'Customer dengan riwayat transaksi dianonimkan, tanpa riwayat dihapus.'**
  String get purgeCustomerHint;

  /// No description provided for @customerDeactivated.
  ///
  /// In id, this message translates to:
  /// **'Customer dinonaktifkan.'**
  String get customerDeactivated;

  /// No description provided for @customerRestored.
  ///
  /// In id, this message translates to:
  /// **'Customer dipulihkan.'**
  String get customerRestored;

  /// No description provided for @customerDetail.
  ///
  /// In id, this message translates to:
  /// **'Detail customer'**
  String get customerDetail;

  /// No description provided for @transactionsTitle.
  ///
  /// In id, this message translates to:
  /// **'Transaksi'**
  String get transactionsTitle;

  /// No description provided for @noTransactions.
  ///
  /// In id, this message translates to:
  /// **'Belum ada transaksi.'**
  String get noTransactions;

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

  /// No description provided for @categoriesTitle.
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get categoriesTitle;

  /// No description provided for @addCategory.
  ///
  /// In id, this message translates to:
  /// **'Tambah kategori'**
  String get addCategory;

  /// No description provided for @rename.
  ///
  /// In id, this message translates to:
  /// **'Ganti nama'**
  String get rename;

  /// No description provided for @categoryName.
  ///
  /// In id, this message translates to:
  /// **'Nama kategori'**
  String get categoryName;

  /// No description provided for @categoriesEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada kategori. Tambah kategori pertama.'**
  String get categoriesEmpty;

  /// No description provided for @productCount.
  ///
  /// In id, this message translates to:
  /// **'{count, plural, =0{Belum dipakai} =1{1 produk} other{{count} produk}}'**
  String productCount(int count);

  /// No description provided for @categoryInUse.
  ///
  /// In id, this message translates to:
  /// **'Dipakai {count} produk. Pindahkan produknya dulu.'**
  String categoryInUse(int count);

  /// No description provided for @categoryDuplicate.
  ///
  /// In id, this message translates to:
  /// **'Nama kategori sudah ada.'**
  String get categoryDuplicate;

  /// No description provided for @categoryDeleted.
  ///
  /// In id, this message translates to:
  /// **'Kategori dihapus.'**
  String get categoryDeleted;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus kategori {name}?'**
  String deleteCategoryTitle(String name);

  /// No description provided for @productsTitle.
  ///
  /// In id, this message translates to:
  /// **'Produk'**
  String get productsTitle;

  /// No description provided for @addProduct.
  ///
  /// In id, this message translates to:
  /// **'Tambah produk'**
  String get addProduct;

  /// No description provided for @bulkAdd.
  ///
  /// In id, this message translates to:
  /// **'Tambah massal'**
  String get bulkAdd;

  /// No description provided for @editProduct.
  ///
  /// In id, this message translates to:
  /// **'Edit produk'**
  String get editProduct;

  /// No description provided for @productsEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada produk. Tambah produk pertama.'**
  String get productsEmpty;

  /// No description provided for @productsNoMatch.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada produk yang cocok.'**
  String get productsNoMatch;

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

  /// No description provided for @barcodeHint.
  ///
  /// In id, this message translates to:
  /// **'Opsional. Scanner USB bisa langsung mengisi.'**
  String get barcodeHint;

  /// No description provided for @unit.
  ///
  /// In id, this message translates to:
  /// **'Satuan'**
  String get unit;

  /// No description provided for @productType.
  ///
  /// In id, this message translates to:
  /// **'Tipe'**
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

  /// No description provided for @purchasePrice.
  ///
  /// In id, this message translates to:
  /// **'Harga beli'**
  String get purchasePrice;

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

  /// No description provided for @stock.
  ///
  /// In id, this message translates to:
  /// **'Stok'**
  String get stock;

  /// No description provided for @category.
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get category;

  /// No description provided for @categoryNewHint.
  ///
  /// In id, this message translates to:
  /// **'Pilih kategori atau ketik nama baru'**
  String get categoryNewHint;

  /// No description provided for @imageUrl.
  ///
  /// In id, this message translates to:
  /// **'URL gambar (opsional)'**
  String get imageUrl;

  /// No description provided for @allCategories.
  ///
  /// In id, this message translates to:
  /// **'Semua kategori'**
  String get allCategories;

  /// No description provided for @adjustStock.
  ///
  /// In id, this message translates to:
  /// **'Ubah stok'**
  String get adjustStock;

  /// No description provided for @stockDelta.
  ///
  /// In id, this message translates to:
  /// **'Tambah atau kurangi (contoh 10 atau -2)'**
  String get stockDelta;

  /// No description provided for @stockUpdated.
  ///
  /// In id, this message translates to:
  /// **'Stok diperbarui.'**
  String get stockUpdated;

  /// No description provided for @productDeleted.
  ///
  /// In id, this message translates to:
  /// **'Produk dihapus.'**
  String get productDeleted;

  /// No description provided for @deleteProductTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus produk {name}?'**
  String deleteProductTitle(String name);

  /// No description provided for @productSaved.
  ///
  /// In id, this message translates to:
  /// **'Produk disimpan.'**
  String get productSaved;

  /// No description provided for @bulkTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah produk massal'**
  String get bulkTitle;

  /// No description provided for @bulkHint.
  ///
  /// In id, this message translates to:
  /// **'Isi satu produk per baris. SKU yang sudah ada akan diperbarui.'**
  String get bulkHint;

  /// No description provided for @addRow.
  ///
  /// In id, this message translates to:
  /// **'Tambah baris'**
  String get addRow;

  /// No description provided for @removeRow.
  ///
  /// In id, this message translates to:
  /// **'Hapus baris'**
  String get removeRow;

  /// No description provided for @uploadBulk.
  ///
  /// In id, this message translates to:
  /// **'Simpan semua'**
  String get uploadBulk;

  /// No description provided for @bulkResult.
  ///
  /// In id, this message translates to:
  /// **'{inserted} ditambahkan, {updated} diperbarui.'**
  String bulkResult(int inserted, int updated);

  /// No description provided for @bulkRowError.
  ///
  /// In id, this message translates to:
  /// **'Baris {line}: {message}'**
  String bulkRowError(int line, String message);

  /// No description provided for @bulkDuplicate.
  ///
  /// In id, this message translates to:
  /// **'SKU ganda di form: {skus}'**
  String bulkDuplicate(String skus);

  /// No description provided for @row.
  ///
  /// In id, this message translates to:
  /// **'Baris {n}'**
  String row(int n);

  /// No description provided for @devicesTitle.
  ///
  /// In id, this message translates to:
  /// **'Device'**
  String get devicesTitle;

  /// No description provided for @devicesEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada device yang login.'**
  String get devicesEmpty;

  /// No description provided for @allPlatforms.
  ///
  /// In id, this message translates to:
  /// **'Semua platform'**
  String get allPlatforms;

  /// No description provided for @user.
  ///
  /// In id, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @platform.
  ///
  /// In id, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @lastActive.
  ///
  /// In id, this message translates to:
  /// **'Terakhir aktif'**
  String get lastActive;

  /// No description provided for @revoke.
  ///
  /// In id, this message translates to:
  /// **'Cabut'**
  String get revoke;

  /// No description provided for @revokeTitle.
  ///
  /// In id, this message translates to:
  /// **'Cabut device {name}?'**
  String revokeTitle(String name);

  /// No description provided for @revokeHint.
  ///
  /// In id, this message translates to:
  /// **'Device ini berhenti menerima notifikasi pembayaran.'**
  String get revokeHint;

  /// No description provided for @deviceRevoked.
  ///
  /// In id, this message translates to:
  /// **'Device dicabut.'**
  String get deviceRevoked;

  /// No description provided for @unknownUser.
  ///
  /// In id, this message translates to:
  /// **'(tanpa user)'**
  String get unknownUser;

  /// No description provided for @vPositive.
  ///
  /// In id, this message translates to:
  /// **'Harus lebih dari 0'**
  String get vPositive;

  /// No description provided for @vNumber.
  ///
  /// In id, this message translates to:
  /// **'Masukkan angka'**
  String get vNumber;

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

  /// No description provided for @vCategoryLength.
  ///
  /// In id, this message translates to:
  /// **'Maks 100 karakter'**
  String get vCategoryLength;

  /// No description provided for @vZero.
  ///
  /// In id, this message translates to:
  /// **'Isi selain 0'**
  String get vZero;

  /// No description provided for @loadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data. {reason}'**
  String loadFailed(String reason);

  /// No description provided for @debtPaid.
  ///
  /// In id, this message translates to:
  /// **'Lunas'**
  String get debtPaid;

  /// No description provided for @debtUnpaid.
  ///
  /// In id, this message translates to:
  /// **'Belum lunas'**
  String get debtUnpaid;

  /// No description provided for @transactionsEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada transaksi pada filter ini.'**
  String get transactionsEmpty;

  /// No description provided for @allMethods.
  ///
  /// In id, this message translates to:
  /// **'Semua metode'**
  String get allMethods;

  /// No description provided for @invoice.
  ///
  /// In id, this message translates to:
  /// **'No. invoice'**
  String get invoice;

  /// No description provided for @searchInvoice.
  ///
  /// In id, this message translates to:
  /// **'Cari no. invoice'**
  String get searchInvoice;

  /// No description provided for @date.
  ///
  /// In id, this message translates to:
  /// **'Tanggal'**
  String get date;

  /// No description provided for @method.
  ///
  /// In id, this message translates to:
  /// **'Metode'**
  String get method;

  /// No description provided for @total.
  ///
  /// In id, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @profit.
  ///
  /// In id, this message translates to:
  /// **'Laba kotor'**
  String get profit;

  /// No description provided for @conflictOnly.
  ///
  /// In id, this message translates to:
  /// **'Konflik stok'**
  String get conflictOnly;

  /// No description provided for @conflict.
  ///
  /// In id, this message translates to:
  /// **'Konflik stok'**
  String get conflict;

  /// No description provided for @reviewed.
  ///
  /// In id, this message translates to:
  /// **'Sudah ditinjau'**
  String get reviewed;

  /// No description provided for @markReviewed.
  ///
  /// In id, this message translates to:
  /// **'Tandai sudah ditinjau'**
  String get markReviewed;

  /// No description provided for @markedReviewed.
  ///
  /// In id, this message translates to:
  /// **'Ditandai sudah ditinjau.'**
  String get markedReviewed;

  /// No description provided for @conflictHint.
  ///
  /// In id, this message translates to:
  /// **'Stok di server berhenti di 0 saat transaksi offline ini masuk. Koreksi stok produknya, lalu tandai sudah ditinjau.'**
  String get conflictHint;

  /// No description provided for @transactionDetail.
  ///
  /// In id, this message translates to:
  /// **'Detail transaksi'**
  String get transactionDetail;

  /// No description provided for @items.
  ///
  /// In id, this message translates to:
  /// **'Barang'**
  String get items;

  /// No description provided for @qty.
  ///
  /// In id, this message translates to:
  /// **'Jumlah'**
  String get qty;

  /// No description provided for @price.
  ///
  /// In id, this message translates to:
  /// **'Harga'**
  String get price;

  /// No description provided for @subtotal.
  ///
  /// In id, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @cancelTransaction.
  ///
  /// In id, this message translates to:
  /// **'Batalkan transaksi'**
  String get cancelTransaction;

  /// No description provided for @cancelTitle.
  ///
  /// In id, this message translates to:
  /// **'Batalkan {invoice}?'**
  String cancelTitle(String invoice);

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

  /// No description provided for @cancelledOk.
  ///
  /// In id, this message translates to:
  /// **'Transaksi dibatalkan.'**
  String get cancelledOk;

  /// No description provided for @downloadReceipt.
  ///
  /// In id, this message translates to:
  /// **'Unduh struk PDF'**
  String get downloadReceipt;

  /// No description provided for @downloaded.
  ///
  /// In id, this message translates to:
  /// **'File diunduh.'**
  String get downloaded;

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

  /// No description provided for @noCashierFilter.
  ///
  /// In id, this message translates to:
  /// **'Filter kasir belum didukung backend.'**
  String get noCashierFilter;

  /// No description provided for @paymentsTitle.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran QRIS/VA'**
  String get paymentsTitle;

  /// No description provided for @paymentsEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada pembayaran pada filter ini.'**
  String get paymentsEmpty;

  /// No description provided for @allStatuses.
  ///
  /// In id, this message translates to:
  /// **'Semua status'**
  String get allStatuses;

  /// No description provided for @status.
  ///
  /// In id, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @orderId.
  ///
  /// In id, this message translates to:
  /// **'Order ID'**
  String get orderId;

  /// No description provided for @amount.
  ///
  /// In id, this message translates to:
  /// **'Jumlah'**
  String get amount;

  /// No description provided for @fee.
  ///
  /// In id, this message translates to:
  /// **'Biaya'**
  String get fee;

  /// No description provided for @paidAt.
  ///
  /// In id, this message translates to:
  /// **'Dibayar'**
  String get paidAt;

  /// No description provided for @checkStatus.
  ///
  /// In id, this message translates to:
  /// **'Cek status'**
  String get checkStatus;

  /// No description provided for @statusChecked.
  ///
  /// In id, this message translates to:
  /// **'Status terbaru: {status}'**
  String statusChecked(String status);

  /// No description provided for @psPending.
  ///
  /// In id, this message translates to:
  /// **'Menunggu'**
  String get psPending;

  /// No description provided for @psSettling.
  ///
  /// In id, this message translates to:
  /// **'Diproses'**
  String get psSettling;

  /// No description provided for @psSuccess.
  ///
  /// In id, this message translates to:
  /// **'Berhasil'**
  String get psSuccess;

  /// No description provided for @psFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal'**
  String get psFailed;

  /// No description provided for @psExpired.
  ///
  /// In id, this message translates to:
  /// **'Kedaluwarsa'**
  String get psExpired;

  /// No description provided for @debtsEmpty.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada hutang pada filter ini.'**
  String get debtsEmpty;

  /// No description provided for @unpaidOnly.
  ///
  /// In id, this message translates to:
  /// **'Belum lunas saja'**
  String get unpaidOnly;

  /// No description provided for @searchCustomer.
  ///
  /// In id, this message translates to:
  /// **'Cari nama customer'**
  String get searchCustomer;

  /// No description provided for @searchProduct.
  ///
  /// In id, this message translates to:
  /// **'Cari nama produk'**
  String get searchProduct;

  /// No description provided for @searchUsername.
  ///
  /// In id, this message translates to:
  /// **'Cari username'**
  String get searchUsername;

  /// No description provided for @remaining.
  ///
  /// In id, this message translates to:
  /// **'Sisa'**
  String get remaining;

  /// No description provided for @addManualDebt.
  ///
  /// In id, this message translates to:
  /// **'Tambah hutang manual'**
  String get addManualDebt;

  /// No description provided for @receivePayment.
  ///
  /// In id, this message translates to:
  /// **'Terima pembayaran'**
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

  /// No description provided for @debtAdded.
  ///
  /// In id, this message translates to:
  /// **'Hutang ditambahkan.'**
  String get debtAdded;

  /// No description provided for @dueDate.
  ///
  /// In id, this message translates to:
  /// **'Jatuh tempo (opsional)'**
  String get dueDate;

  /// No description provided for @pickCustomer.
  ///
  /// In id, this message translates to:
  /// **'Pilih customer'**
  String get pickCustomer;

  /// No description provided for @exceedsRemaining.
  ///
  /// In id, this message translates to:
  /// **'Melebihi sisa hutang.'**
  String get exceedsRemaining;

  /// No description provided for @reportsTitle.
  ///
  /// In id, this message translates to:
  /// **'Laporan'**
  String get reportsTitle;

  /// No description provided for @monthlyReport.
  ///
  /// In id, this message translates to:
  /// **'Laporan bulanan'**
  String get monthlyReport;

  /// No description provided for @monthlyReportHint.
  ///
  /// In id, this message translates to:
  /// **'Penjualan, transaksi hutang, hutang manual, dan pembayaran hutang per hari.'**
  String get monthlyReportHint;

  /// No description provided for @month.
  ///
  /// In id, this message translates to:
  /// **'Bulan'**
  String get month;

  /// No description provided for @year.
  ///
  /// In id, this message translates to:
  /// **'Tahun'**
  String get year;

  /// No description provided for @download.
  ///
  /// In id, this message translates to:
  /// **'Unduh PDF'**
  String get download;

  /// No description provided for @downloadThisMonth.
  ///
  /// In id, this message translates to:
  /// **'Unduh laporan bulan ini'**
  String get downloadThisMonth;

  /// No description provided for @dashboardTitle.
  ///
  /// In id, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @needsAction.
  ///
  /// In id, this message translates to:
  /// **'Perlu tindakan'**
  String get needsAction;

  /// No description provided for @nothingToDo.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada yang perlu ditindaklanjuti hari ini.'**
  String get nothingToDo;

  /// No description provided for @openConflicts.
  ///
  /// In id, this message translates to:
  /// **'{count, plural, =1{1 konflik stok belum ditinjau} other{{count} konflik stok belum ditinjau}}'**
  String openConflicts(int count);

  /// No description provided for @oldestDebts.
  ///
  /// In id, this message translates to:
  /// **'Hutang belum lunas paling lama'**
  String get oldestDebts;

  /// No description provided for @failedPayments.
  ///
  /// In id, this message translates to:
  /// **'{count, plural, =1{1 pembayaran QRIS/VA gagal atau kedaluwarsa hari ini} other{{count} pembayaran QRIS/VA gagal atau kedaluwarsa hari ini}}'**
  String failedPayments(int count);

  /// No description provided for @revenue.
  ///
  /// In id, this message translates to:
  /// **'Omzet'**
  String get revenue;

  /// No description provided for @grossProfit.
  ///
  /// In id, this message translates to:
  /// **'Laba kotor'**
  String get grossProfit;

  /// No description provided for @transactionCount.
  ///
  /// In id, this message translates to:
  /// **'Transaksi'**
  String get transactionCount;

  /// No description provided for @activeReceivables.
  ///
  /// In id, this message translates to:
  /// **'Piutang aktif'**
  String get activeReceivables;

  /// No description provided for @rangeToday.
  ///
  /// In id, this message translates to:
  /// **'Hari ini'**
  String get rangeToday;

  /// No description provided for @range7.
  ///
  /// In id, this message translates to:
  /// **'7 hari'**
  String get range7;

  /// No description provided for @range30.
  ///
  /// In id, this message translates to:
  /// **'30 hari'**
  String get range30;

  /// No description provided for @rangeMonth.
  ///
  /// In id, this message translates to:
  /// **'Bulan ini'**
  String get rangeMonth;

  /// No description provided for @rangeCustom.
  ///
  /// In id, this message translates to:
  /// **'Custom'**
  String get rangeCustom;

  /// No description provided for @dailyChartTitle.
  ///
  /// In id, this message translates to:
  /// **'Omzet dan laba kotor harian, {range}'**
  String dailyChartTitle(String range);

  /// No description provided for @topProducts.
  ///
  /// In id, this message translates to:
  /// **'5 produk terlaris'**
  String get topProducts;

  /// No description provided for @paymentMix.
  ///
  /// In id, this message translates to:
  /// **'Pembagian metode bayar'**
  String get paymentMix;

  /// No description provided for @debtFlow.
  ///
  /// In id, this message translates to:
  /// **'Hutang baru dan dibayar'**
  String get debtFlow;

  /// No description provided for @newDebt.
  ///
  /// In id, this message translates to:
  /// **'Hutang baru'**
  String get newDebt;

  /// No description provided for @paidDebt.
  ///
  /// In id, this message translates to:
  /// **'Dibayar'**
  String get paidDebt;

  /// No description provided for @devicesOnline.
  ///
  /// In id, this message translates to:
  /// **'Device yang sedang login'**
  String get devicesOnline;

  /// No description provided for @noData.
  ///
  /// In id, this message translates to:
  /// **'Belum ada data pada rentang ini.'**
  String get noData;

  /// No description provided for @quickAddProduct.
  ///
  /// In id, this message translates to:
  /// **'Tambah produk'**
  String get quickAddProduct;

  /// No description provided for @quickAddStaff.
  ///
  /// In id, this message translates to:
  /// **'Tambah staff'**
  String get quickAddStaff;

  /// No description provided for @quickAddCustomer.
  ///
  /// In id, this message translates to:
  /// **'Tambah customer'**
  String get quickAddCustomer;

  /// No description provided for @quickMonthReport.
  ///
  /// In id, this message translates to:
  /// **'Unduh laporan bulan ini'**
  String get quickMonthReport;

  /// No description provided for @sold.
  ///
  /// In id, this message translates to:
  /// **'{qty} terjual'**
  String sold(String qty);

  /// No description provided for @chartTable.
  ///
  /// In id, this message translates to:
  /// **'Lihat sebagai tabel'**
  String get chartTable;

  /// No description provided for @importTitle.
  ///
  /// In id, this message translates to:
  /// **'Impor dari file Excel atau CSV'**
  String get importTitle;

  /// No description provided for @importHint.
  ///
  /// In id, this message translates to:
  /// **'Kolom wajib: sku, product_name, purchase_price, selling_price, selling_price_debt. Opsional: barcode, unit (pcs, gram, kg, liter, kardus, ikat), stock, category, image, product_type (physical atau digital). Maks 10.000 baris, 25 MB. SKU yang sudah ada akan diperbarui.'**
  String get importHint;

  /// No description provided for @pickFile.
  ///
  /// In id, this message translates to:
  /// **'Pilih file .xlsx atau .csv'**
  String get pickFile;

  /// No description provided for @downloadTemplate.
  ///
  /// In id, this message translates to:
  /// **'Unduh template CSV'**
  String get downloadTemplate;

  /// No description provided for @importing.
  ///
  /// In id, this message translates to:
  /// **'Mengimpor {name}…'**
  String importing(String name);

  /// No description provided for @manualTitle.
  ///
  /// In id, this message translates to:
  /// **'Atau isi manual'**
  String get manualTitle;

  /// No description provided for @importFormat.
  ///
  /// In id, this message translates to:
  /// **'Hanya file .xlsx atau .csv.'**
  String get importFormat;

  /// No description provided for @importEmpty.
  ///
  /// In id, this message translates to:
  /// **'File kosong.'**
  String get importEmpty;

  /// No description provided for @importTooLarge.
  ///
  /// In id, this message translates to:
  /// **'File lebih dari 25 MB.'**
  String get importTooLarge;

  /// No description provided for @loginPanelLine.
  ///
  /// In id, this message translates to:
  /// **'Penjualan, stok, dan hutang toko dalam satu tempat.'**
  String get loginPanelLine;

  /// No description provided for @loginPanelNote.
  ///
  /// In id, this message translates to:
  /// **'Transaksi dicatat dari aplikasi Kasir, termasuk saat offline.'**
  String get loginPanelNote;

  /// No description provided for @summaryTitle.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan'**
  String get summaryTitle;

  /// No description provided for @vsPrevious.
  ///
  /// In id, this message translates to:
  /// **'vs {range} sebelumnya'**
  String vsPrevious(String range);

  /// No description provided for @recentTransactions.
  ///
  /// In id, this message translates to:
  /// **'Transaksi terbaru'**
  String get recentTransactions;

  /// No description provided for @seeAll.
  ///
  /// In id, this message translates to:
  /// **'Lihat semua'**
  String get seeAll;

  /// No description provided for @statusDone.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get statusDone;

  /// No description provided for @range.
  ///
  /// In id, this message translates to:
  /// **'Rentang'**
  String get range;

  /// No description provided for @account.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get account;

  /// No description provided for @switchLanguage.
  ///
  /// In id, this message translates to:
  /// **'Ganti bahasa'**
  String get switchLanguage;

  /// No description provided for @rangeTodayShort.
  ///
  /// In id, this message translates to:
  /// **'hari ini'**
  String get rangeTodayShort;

  /// No description provided for @periodBefore.
  ///
  /// In id, this message translates to:
  /// **'periode'**
  String get periodBefore;
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

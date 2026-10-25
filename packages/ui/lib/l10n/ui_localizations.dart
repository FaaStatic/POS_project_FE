import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'ui_localizations_en.dart';
import 'ui_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of UiLocalizations
/// returned by `UiLocalizations.of(context)`.
///
/// Applications need to include `UiLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/ui_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: UiLocalizations.localizationsDelegates,
///   supportedLocales: UiLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the UiLocalizations.supportedLocales
/// property.
abstract class UiLocalizations {
  UiLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static UiLocalizations of(BuildContext context) {
    return Localizations.of<UiLocalizations>(context, UiLocalizations)!;
  }

  static const LocalizationsDelegate<UiLocalizations> delegate =
      _UiLocalizationsDelegate();

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

  /// No description provided for @retry.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In id, this message translates to:
  /// **'Memuat'**
  String get loading;

  /// No description provided for @showPassword.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan kata sandi'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In id, this message translates to:
  /// **'Sembunyikan kata sandi'**
  String get hidePassword;

  /// No description provided for @close.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @search.
  ///
  /// In id, this message translates to:
  /// **'Cari'**
  String get search;

  /// No description provided for @clearSearch.
  ///
  /// In id, this message translates to:
  /// **'Hapus pencarian'**
  String get clearSearch;

  /// No description provided for @previousPage.
  ///
  /// In id, this message translates to:
  /// **'Sebelumnya'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In id, this message translates to:
  /// **'Berikutnya'**
  String get nextPage;

  /// No description provided for @offlineBanner.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada koneksi internet'**
  String get offlineBanner;

  /// No description provided for @pendingCount.
  ///
  /// In id, this message translates to:
  /// **'{count, plural, =0{Semua transaksi terkirim} other{{count} transaksi belum terkirim}}'**
  String pendingCount(int count);

  /// No description provided for @decrease.
  ///
  /// In id, this message translates to:
  /// **'Kurangi'**
  String get decrease;

  /// No description provided for @increase.
  ///
  /// In id, this message translates to:
  /// **'Tambah'**
  String get increase;

  /// No description provided for @quantity.
  ///
  /// In id, this message translates to:
  /// **'Jumlah'**
  String get quantity;

  /// No description provided for @newBuyer.
  ///
  /// In id, this message translates to:
  /// **'Pembeli baru'**
  String get newBuyer;

  /// No description provided for @allTabs.
  ///
  /// In id, this message translates to:
  /// **'Semua ({count})'**
  String allTabs(int count);

  /// No description provided for @tabLabel.
  ///
  /// In id, this message translates to:
  /// **'Transaksi {number}'**
  String tabLabel(int number);

  /// No description provided for @qtyFor.
  ///
  /// In id, this message translates to:
  /// **'Jumlah {name}'**
  String qtyFor(String name);

  /// No description provided for @loadMore.
  ///
  /// In id, this message translates to:
  /// **'Muat lebih banyak'**
  String get loadMore;

  /// No description provided for @actions.
  ///
  /// In id, this message translates to:
  /// **'Aksi'**
  String get actions;

  /// No description provided for @moreActions.
  ///
  /// In id, this message translates to:
  /// **'Aksi lainnya'**
  String get moreActions;
}

class _UiLocalizationsDelegate extends LocalizationsDelegate<UiLocalizations> {
  const _UiLocalizationsDelegate();

  @override
  Future<UiLocalizations> load(Locale locale) {
    return SynchronousFuture<UiLocalizations>(lookupUiLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_UiLocalizationsDelegate old) => false;
}

UiLocalizations lookupUiLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return UiLocalizationsEn();
    case 'id':
      return UiLocalizationsId();
  }

  throw FlutterError(
    'UiLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

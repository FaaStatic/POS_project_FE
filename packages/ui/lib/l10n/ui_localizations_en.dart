// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'ui_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class UiLocalizationsEn extends UiLocalizations {
  UiLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get retry => 'Try again';

  @override
  String get loading => 'Loading';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get search => 'Search';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get previousPage => 'Previous';

  @override
  String get nextPage => 'Next';

  @override
  String get offlineBanner => 'No internet connection';

  @override
  String pendingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions not sent',
      one: '1 transaction not sent',
      zero: 'All transactions sent',
    );
    return '$_temp0';
  }

  @override
  String get decrease => 'Decrease';

  @override
  String get increase => 'Increase';

  @override
  String get quantity => 'Quantity';

  @override
  String get newBuyer => 'New buyer';

  @override
  String allTabs(int count) {
    return 'All ($count)';
  }

  @override
  String tabLabel(int number) {
    return 'Transaction $number';
  }

  @override
  String qtyFor(String name) {
    return 'Quantity of $name';
  }

  @override
  String get loadMore => 'Load more';

  @override
  String get actions => 'Actions';

  @override
  String get moreActions => 'More actions';

  @override
  String get pickDates => 'Pick dates';

  @override
  String get clearDates => 'Clear dates';
}

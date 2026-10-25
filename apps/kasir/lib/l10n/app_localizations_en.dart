// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kasir';

  @override
  String get loginTitle => 'Sign in to Kasir';

  @override
  String get loginSubtitle => 'Use a staff or store admin account.';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get errorNetwork => 'No connection. Check the internet and try again.';

  @override
  String get errorTimeout => 'The server took too long to respond. Try again.';

  @override
  String get sessionExpired => 'Your session ended. Please sign in again.';

  @override
  String get errorUnknown => 'Something went wrong. Try again.';

  @override
  String get vRequired => 'Required';

  @override
  String get vUsernameLength => 'Username must be 3–100 characters';

  @override
  String get vPasswordLength => 'Password must be at least 6 characters';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get logout => 'Sign out';

  @override
  String signedInAs(String name) {
    return 'Signed in as $name';
  }

  @override
  String get navSettings => 'Settings';
}

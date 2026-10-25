import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

/// Local failures are translated; backend failures show the server text as-is (v1).
String failureText(BuildContext context, Failure failure) {
  final l10n = AppLocalizations.of(context);
  return switch (failure) {
    NetworkFailure() => l10n.errorNetwork,
    TimeoutFailure() => l10n.errorTimeout,
    UnauthorizedFailure(message: null) => l10n.sessionExpired,
    _ => failure.message ?? l10n.errorUnknown,
  };
}

/// Translates a [Validators] error key.
String? validationText(BuildContext context, String? key) {
  if (key == null) return null;
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'username_length' => l10n.vUsernameLength,
    'password_length' => l10n.vPasswordLength,
    _ => l10n.vRequired,
  };
}

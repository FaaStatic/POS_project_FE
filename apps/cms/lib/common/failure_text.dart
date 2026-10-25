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
    ValidationFailure(:final message?) || ConflictFailure(:final message?) => _keyText(l10n, message) ?? message,
    _ => failure.message ?? l10n.errorUnknown,
  };
}

String? _keyText(AppLocalizations l10n, String key) => switch (key) {
      'confirm_mismatch' => l10n.purgeMismatch,
      'customer_has_debt' => l10n.customerHasDebt,
      'category_duplicate' => l10n.categoryDuplicate,
      'category_length' => l10n.vCategoryLength,
      'zero_delta' => l10n.vZero,
      'barcode_format' => l10n.vBarcode,
      'required' => l10n.vRequired,
      'username_length' => l10n.vUsernameLength,
      'password_length' => l10n.vPasswordLength,
      'positive_number' => l10n.vPositive,
      _ => null,
    };

/// Translates a [Validators] error key.
String? validationText(BuildContext context, String? key) {
  if (key == null) return null;
  final l10n = AppLocalizations.of(context);
  return switch (key) {
    'username_length' => l10n.vUsernameLength,
    'password_length' => l10n.vPasswordLength,
    'barcode_format' => l10n.vBarcode,
    'sku_length' => l10n.vSku,
    'positive_number' => l10n.vPositive,
    'non_negative_number' => l10n.vNumber,
    'category_length' => l10n.vCategoryLength,
    _ => l10n.vRequired,
  };
}

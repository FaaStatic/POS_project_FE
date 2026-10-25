import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

/// Local failures and validation keys are translated; backend text is shown as-is (v1).
String failureText(BuildContext context, Failure failure) {
  final l10n = AppLocalizations.of(context);
  return switch (failure) {
    NetworkFailure() => l10n.errorNetwork,
    TimeoutFailure() => l10n.errorTimeout,
    UnauthorizedFailure(message: null) => l10n.sessionExpired,
    ValidationFailure(:final message?) || ConflictFailure(:final message?) => _keyText(l10n, message) ?? message,
    ServerFailure(:final message?) when message.startsWith('print_failed') => l10n.printFailed,
    _ => failure.message ?? l10n.errorUnknown,
  };
}

String? _keyText(AppLocalizations l10n, String key) => switch (key) {
      'empty_cart' => l10n.vEmptyCart,
      'invalid_qty' => l10n.vInvalidQty,
      'debt_needs_customer' => l10n.debtNeedsCustomer,
      'destination_required' => l10n.destinationRequired,
      'digital_needs_cash' => l10n.digitalCashOnly,
      'draft_locked' => l10n.tabLocked,
      'awaiting_payment' => l10n.closeTabWaiting,
      'reason_length' => l10n.cancelReasonShort,
      'exceeds_remaining' => l10n.exceedsRemaining,
      'positive_number' => l10n.vPositive,
      'barcode_format' => l10n.vBarcode,
      'no_printer' => l10n.noPrinter,
      'required' => l10n.vRequired,
      _ => null,
    };

/// Translates a [Validators] error key for form fields.
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
    _ => l10n.vRequired,
  };
}

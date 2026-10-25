import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

String methodLabel(AppLocalizations l10n, PaymentMethod method) => switch (method) {
      PaymentMethod.cash => l10n.cash,
      PaymentMethod.debt => l10n.debt,
      PaymentMethod.qris => l10n.qris,
      PaymentMethod.va => l10n.va,
    };

String rupiah(BuildContext context, num amount) =>
    formatRupiah(amount, locale: Localizations.localeOf(context).languageCode);

String qty(BuildContext context, num value) => formatQty(value, locale: Localizations.localeOf(context).languageCode);

ReceiptDocument receiptFor(BuildContext context, Sale sale, ReceiptSettings settings) {
  final l10n = AppLocalizations.of(context);
  return ReceiptDocument.fromSale(
    sale,
    settings,
    locale: Localizations.localeOf(context).languageCode,
    methodLabel: (m) => methodLabel(l10n, m),
    labels: ReceiptLabels(
      number: l10n.receiptNumber,
      date: l10n.receiptDate,
      cashier: l10n.receiptCashier,
      customer: l10n.receiptCustomer,
      destination: l10n.destination,
      total: l10n.receiptTotal,
      method: l10n.receiptMethod,
      offlineNote: l10n.receiptOfflineNote,
      storeNameMissing: l10n.storeNameMissing,
    ),
  );
}

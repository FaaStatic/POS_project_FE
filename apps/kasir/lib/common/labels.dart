import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:ui/ui.dart' show UiLocalizations;

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
      markPaid: l10n.receiptMarkPaid,
      markDebt: l10n.receiptMarkDebt,
      markCancelled: l10n.receiptMarkCancelled,
      markUnpaid: l10n.receiptMarkUnpaid,
      debtPayment: l10n.receiptDebtPayment,
      debtPaidNow: l10n.receiptDebtPaidNow,
      debtPaidTotal: l10n.receiptDebtPaidTotal,
      debtOwed: l10n.receiptDebtOwed,
    ),
  );
}

/// "Transaksi N", or "Hutang N" for a debt payment tab.
String draftTitle(BuildContext context, Draft draft) => draft.isDebtPayment
    ? AppLocalizations.of(context).debtTabLabel(draft.number)
    : UiLocalizations.of(context).tabLabel(draft.number);

/// What a tab shows under its title: the cart summary, the customer of a debt tab, or its status.
String draftSubtitle(BuildContext context, Draft draft) {
  final l10n = AppLocalizations.of(context);
  return switch (draft.status) {
    DraftStatus.awaitingPayment => draft.charge?.method == ChargeMethod.va ? l10n.waitingVa : l10n.waitingQris,
    DraftStatus.paid => l10n.paid,
    DraftStatus.open when draft.isDebtPayment => draft.customerName ?? l10n.debtTabPickCustomer,
    DraftStatus.open => l10n.cartSummary(qty(context, draft.itemCount), rupiah(context, draft.total())),
  };
}

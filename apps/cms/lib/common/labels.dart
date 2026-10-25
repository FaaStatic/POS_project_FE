import 'package:core/core.dart';
import 'package:ui/ui.dart';

import '../l10n/app_localizations.dart';

String methodLabel(AppLocalizations l10n, PaymentMethod m) => switch (m) {
      PaymentMethod.cash => l10n.cash,
      PaymentMethod.debt => l10n.debt,
      PaymentMethod.qris => l10n.qris,
      PaymentMethod.va => l10n.va,
    };

String paymentStateLabel(AppLocalizations l10n, PaymentState s) => switch (s) {
      PaymentState.pending => l10n.psPending,
      PaymentState.settling => l10n.psSettling,
      PaymentState.success => l10n.psSuccess,
      PaymentState.failed => l10n.psFailed,
      PaymentState.expired => l10n.psExpired,
    };

BadgeTone paymentStateTone(PaymentState s) => switch (s) {
      PaymentState.success => BadgeTone.success,
      PaymentState.failed || PaymentState.expired => BadgeTone.danger,
      _ => BadgeTone.warning,
    };

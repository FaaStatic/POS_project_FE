import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ui/ui.dart';

import '../../../../common/labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/checkout_bloc.dart';

/// Locked tab waiting for QRIS or VA. The cashier may leave; polling and FCM
/// keep checking in the background.
class ChargeView extends StatelessWidget {
  const ChargeView({super.key, required this.draft});
  final Draft draft;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final charge = draft.charge!;
    final qris = charge.method == ChargeMethod.qris;
    final expiry = charge.expiresAt;

    return ListView(
      padding: const EdgeInsets.all(Space.xl),
      children: [
        StatusBadge(label: qris ? l10n.waitingQris : l10n.waitingVa, tone: BadgeTone.warning),
        const SizedBox(height: Space.lg),
        Text(rupiah(context, charge.grossAmount), style: theme.textTheme.headlineMedium?.tabular),
        const SizedBox(height: Space.sm),
        Text(qris ? l10n.scanQrHint : l10n.vaHint, style: theme.textTheme.bodyLarge),
        const SizedBox(height: Space.lg),
        if (qris && charge.qrUrl != null)
          Center(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(Space.md),
              child: Image.network(
                charge.qrUrl!,
                width: 260,
                height: 260,
                semanticLabel: l10n.qris,
                errorBuilder: (_, _, _) => SizedBox(width: 260, child: Text(l10n.qrUnavailable, style: const TextStyle(color: Colors.black))),
              ),
            ),
          ),
        if (!qris && charge.vaNumber != null) ...[
          Text(l10n.vaNumber((charge.bank ?? '').toUpperCase()), style: theme.textTheme.labelLarge),
          const SizedBox(height: Space.xs),
          Row(
            children: [
              Expanded(child: SelectableText(charge.vaNumber!, style: theme.textTheme.headlineSmall?.tabular)),
              IconButton(
                tooltip: 'Copy',
                icon: const Icon(Icons.copy),
                onPressed: () => Clipboard.setData(ClipboardData(text: charge.vaNumber!)),
              ),
            ],
          ),
        ],
        if (expiry != null) ...[
          const SizedBox(height: Space.md),
          Text(l10n.expiresAt(DateFormat.Hm().format(expiry.toLocal())), style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: Space.lg),
        Text(l10n.waitingNote, style: theme.textTheme.bodySmall),
        const SizedBox(height: Space.lg),
        AppButton(
          label: l10n.checkNow,
          variant: AppButtonVariant.outline,
          expand: true,
          onPressed: () => context.read<CheckoutBloc>().add(ChargesPolled(orderId: charge.orderId)),
        ),
      ],
    );
  }
}

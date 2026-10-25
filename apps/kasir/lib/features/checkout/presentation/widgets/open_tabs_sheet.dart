import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import '../../../../common/labels.dart';
import '../../../../l10n/app_localizations.dart';

/// "Semua (N)": every open tab with its total and status; tap to switch.
Future<int?> showOpenTabs(BuildContext context, List<Draft> drafts, int? activeId) => showModalBottomSheet<int>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (context) {
    final l10n = AppLocalizations.of(context);
    final ui = UiLocalizations.of(context);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      builder: (context, controller) => ListView(
        controller: controller,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.sm),
            child: Text(l10n.openTabs, style: Theme.of(context).textTheme.titleMedium),
          ),
          for (final d in drafts)
            ListTile(
              selected: d.id == activeId,
              title: Text(ui.tabLabel(d.number)),
              subtitle: Text(switch (d.status) {
                DraftStatus.awaitingPayment => d.charge?.method == ChargeMethod.va ? l10n.waitingVa : l10n.waitingQris,
                DraftStatus.paid => l10n.paid,
                DraftStatus.open => l10n.cartSummary(qty(context, d.itemCount), rupiah(context, d.total())),
              }),
              trailing: Text(rupiah(context, d.total()), style: Theme.of(context).textTheme.titleSmall?.tabular),
              onTap: () => Navigator.pop(context, d.id),
            ),
        ],
      ),
    );
  },
);

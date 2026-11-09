import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../../../common/labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/checkout_bloc.dart';

/// Discards a tab. A tab that holds items asks first; an empty one goes straight away.
Future<void> confirmCloseTab(BuildContext context, Draft draft) async {
  final l10n = AppLocalizations.of(context);
  final bloc = context.read<CheckoutBloc>();
  if (!draft.isEmpty) {
    final ok = await showConfirmDialog(
      context,
      title: l10n.closeTabTitle(draft.number, qty(context, draft.itemCount)),
      confirmLabel: l10n.remove,
      destructive: true,
    );
    if (!ok) return;
  }
  bloc.add(TabClosed(draft.id));
}

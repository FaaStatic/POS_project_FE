import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/failure_text.dart';
import '../../../../common/labels.dart';
import '../../../../common/receipt_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/history_cubit.dart';
import 'history_page.dart';

/// Receipt of one sale: shown right after payment and from History.
class SaleDetailPage extends StatelessWidget {
  const SaleDetailPage({super.key, required this.clientRef, this.autoPrint = false});

  final String clientRef;

  /// Set when opened straight after checkout and auto print is on.
  final bool autoPrint;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => getIt<SaleDetailCubit>()..load(clientRef),
      child: BlocConsumer<SaleDetailCubit, SaleDetailState>(
        listenWhen: (a, b) => a.eventId != b.eventId || (a.loading && !b.loading),
        listener: (context, s) {
          if (s.eventId == 0 && s.sale != null) {
            final settings = getIt<GetReceiptSettings>()();
            if (autoPrint && settings.autoPrint && settings.printerAddress != null) {
              context.read<SaleDetailCubit>().print(receiptFor(context, s.sale!, settings));
            }
            return;
          }
          final message = s.failure != null
              ? failureText(context, s.failure!)
              : s.printed
              ? l10n.printed
              : s.cancelled
              ? l10n.cancelled
              : null;
          if (message != null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        },
        builder: (context, state) {
          final sale = state.sale;
          return Scaffold(
            appBar: AppBar(title: Text(sale?.receiptNumber ?? l10n.receipt)),
            body: state.loading
                ? const LoadingView()
                : sale == null
                ? ErrorState(message: l10n.errorUnknown)
                : _Body(sale: sale, working: state.working),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.sale, required this.working});
  final Sale sale;
  final bool working;

  Future<void> _cancel(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<SaleDetailCubit>();
    final reason = await showReasonDialog(
      context,
      title: l10n.cancelSaleTitle(sale.receiptNumber),
      label: l10n.cancelReason,
      confirmLabel: l10n.cancelSale,
      tooShort: l10n.cancelReasonShort,
    );
    if (reason != null) await cubit.cancel(reason);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = getIt<GetReceiptSettings>()();
    final cubit = context.read<SaleDetailCubit>();

    return ListView(
      padding: const EdgeInsets.all(Space.lg),
      children: [
        Wrap(
          spacing: Space.sm,
          runSpacing: Space.sm,
          children: [
            SaleStatusBadge(sale: sale),
            if (sale.stockConflict) StatusBadge(label: l10n.stockConflict, tone: BadgeTone.warning),
          ],
        ),
        if (sale.error != null) ...[
          const SizedBox(height: Space.sm),
          Text(
            l10n.syncError(sale.error!),
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
          ),
        ],
        if (sale.cancelReason != null) ...[
          const SizedBox(height: Space.sm),
          Text('${l10n.cancelReason}: ${sale.cancelReason}', style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: Space.lg),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ReceiptView(document: receiptFor(context, sale, settings)),
        ),
        const SizedBox(height: Space.xl),
        if (settings.printerAddress == null)
          AppButton(
            label: l10n.setupPrinter,
            variant: AppButtonVariant.outline,
            expand: true,
            onPressed: () => context.push('/settings/printer'),
          )
        else
          AppButton(
            label: l10n.reprint,
            variant: AppButtonVariant.outline,
            expand: true,
            loading: working,
            onPressed: () => cubit.print(receiptFor(context, sale, settings)),
          ),
        const SizedBox(height: Space.md),
        AppButton(
          label: l10n.done,
          large: true,
          expand: true,
          onPressed: () => context.canPop() ? context.pop() : context.go('/checkout'),
        ),
        if (sale.status != SaleStatus.cancelled) ...[
          const SizedBox(height: Space.xl),
          AppButton(
            label: l10n.cancelSale,
            variant: AppButtonVariant.ghost,
            expand: true,
            onPressed: working ? null : () => _cancel(context),
          ),
          if (sale.isSynced)
            Text(l10n.cancelNeedsInternet, textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
        ],
      ],
    );
  }
}

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/failure_text.dart';
import '../../../../common/feedback.dart';
import '../../../../common/file_saver.dart';
import '../../../../common/labels.dart';
import '../../../../common/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/transactions_cubit.dart';

/// CMS never creates or edits transactions; it can only cancel with a reason.
class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({super.key, required this.transactionId});
  final String transactionId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => getIt<TransactionDetailCubit>()..load(transactionId),
      child: BlocBuilder<TransactionDetailCubit, TransactionDetailState>(
        builder: (context, state) {
          final t = state.transaction;
          return Scaffold(
            appBar: AppBar(title: Text(t?.invoice ?? l10n.transactionDetail)),
            body: state.loading
                ? const LoadingView()
                : t == null
                ? ErrorState(
                    message: failureText(context, state.failure!),
                    onRetry: () => context.read<TransactionDetailCubit>().load(transactionId),
                  )
                : _Body(transaction: t, working: state.working),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.transaction, required this.working});
  final Transaction transaction;
  final bool working;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final t = transaction;
    final cubit = context.read<TransactionDetailCubit>();
    final num = theme.textTheme.bodyLarge?.tabular;

    return ConstrainedBody(
      padding: const EdgeInsets.all(Space.lg),
      maxWidth: 880,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ListView(
          padding: const EdgeInsets.all(Space.xl),
          children: [
            Wrap(
              spacing: Space.lg,
              runSpacing: Space.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(dateTimeText(context, t.createdAt), style: theme.textTheme.bodyLarge),
                Text(methodLabel(l10n, t.method), style: theme.textTheme.bodyLarge),
                if (t.stockConflict)
                  StatusBadge(
                    label: t.conflictReviewed ? l10n.reviewed : l10n.conflict,
                    tone: t.conflictReviewed ? BadgeTone.neutral : BadgeTone.warning,
                  ),
              ],
            ),
            if (t.stockConflict && !t.conflictReviewed) ...[
              const SizedBox(height: Space.lg),
              Text(l10n.conflictHint, style: theme.textTheme.bodyMedium),
              const SizedBox(height: Space.sm),
              Align(
                alignment: Alignment.centerLeft,
                child: AppButton(
                  label: l10n.markReviewed,
                  loading: working,
                  onPressed: () => report(context, cubit.markReviewed(), l10n.markedReviewed),
                ),
              ),
            ],
            const SizedBox(height: Space.xl),
            Text(l10n.items, style: theme.textTheme.titleMedium),
            const SizedBox(height: Space.sm),
            for (final i in t.items)
              Padding(
                key: ValueKey(i.productId),
                padding: const EdgeInsets.symmetric(vertical: Space.sm),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: Space.lg,
                  children: [
                    Text(i.name, style: theme.textTheme.bodyLarge),
                    Text(
                      '${formatQty(i.qty, locale: Localizations.localeOf(context).languageCode)} × ${money(context, i.price)} = ${money(context, i.subtotal)}',
                      style: num,
                    ),
                  ],
                ),
              ),
            const Divider(height: Space.xl),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                Text(l10n.total, style: theme.textTheme.titleMedium),
                Text(money(context, t.total), style: theme.textTheme.titleLarge?.tabular),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                Text(l10n.profit, style: theme.textTheme.bodyLarge),
                Text(money(context, t.profit), style: num),
              ],
            ),
            const SizedBox(height: Space.xxl),
            Wrap(
              spacing: Space.md,
              runSpacing: Space.md,
              children: [
                AppButton(
                  label: l10n.downloadReceipt,
                  variant: AppButtonVariant.outline,
                  loading: working,
                  onPressed: () async {
                    final result = await cubit.receipt();
                    if (!context.mounted) return;
                    if (result case Ok(value: (final bytes, final name))) saveFile(bytes, name);
                    showResult(context, result, l10n.downloaded);
                  },
                ),
                AppButton(
                  label: l10n.cancelTransaction,
                  variant: AppButtonVariant.destructive,
                  onPressed: working
                      ? null
                      : () async {
                          final reason = await showReasonDialog(
                            context,
                            title: l10n.cancelTitle(t.invoice),
                            label: l10n.cancelReason,
                            confirmLabel: l10n.cancelTransaction,
                            tooShort: l10n.cancelReasonShort,
                          );
                          if (reason == null || !context.mounted) return;
                          final result = await cubit.cancel(reason);
                          if (!context.mounted) return;
                          showResult(context, result, l10n.cancelledOk);
                          if (result case Ok()) Navigator.of(context).pop();
                        },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

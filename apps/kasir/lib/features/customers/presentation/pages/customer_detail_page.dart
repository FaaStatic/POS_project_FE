import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/failure_text.dart';
import '../../../../app/router.dart';
import '../../../../common/labels.dart';
import '../../../checkout/presentation/bloc/checkout_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/customers_cubit.dart';

class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({super.key, required this.customerId});
  final String customerId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => getIt<CustomerDetailCubit>()..load(customerId),
      child: BlocBuilder<CustomerDetailCubit, CustomerDetailState>(
        builder: (context, state) {
          final c = state.customer;
          final debt = state.debt;
          return Scaffold(
            appBar: AppBar(title: Text(c?.name ?? l10n.customer)),
            body: c == null
                ? (state.loading
                      ? const LoadingView()
                      : ErrorState(
                          message: failureText(context, state.failure!),
                          onRetry: () => context.read<CustomerDetailCubit>().load(customerId),
                        ))
                : RefreshIndicator(
                    onRefresh: () => context.read<CustomerDetailCubit>().load(customerId),
                    child: ListView(
                      padding: const EdgeInsets.all(Space.lg),
                      children: [
                        if (c.phone.isNotEmpty) Text(c.phone, style: theme.textTheme.bodyLarge),
                        if (c.address.isNotEmpty) Text(c.address, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: Space.xl),
                        Text(l10n.debtsTitle, style: theme.textTheme.titleMedium),
                        if (state.loading)
                          const Padding(padding: EdgeInsets.all(Space.lg), child: LinearProgressIndicator()),
                        if (debt == null && !state.loading)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Space.md),
                            child: Text(l10n.noDebts),
                          ),
                        // A Wrap, not a ListTile: on phones the pay button drops under the amount.
                        if (debt case final d?)
                          Padding(
                            key: ValueKey(d.id),
                            padding: const EdgeInsets.symmetric(vertical: Space.sm),
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: Space.md,
                              runSpacing: Space.sm,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      l10n.remaining(rupiah(context, d.remaining), rupiah(context, d.total)),
                                      style: theme.textTheme.bodyLarge?.tabular,
                                    ),
                                    if (d.date != null) Text(formatDateShort(context, d.date!), style: theme.textTheme.bodySmall),
                                  ],
                                ),
                                AppButton(
                                  label: l10n.payDebtTab,
                                  variant: AppButtonVariant.secondary,
                                  onPressed: () {
                                    context.read<CheckoutBloc>().add(NewDebtTabRequested(customerId: c.id, customerName: c.name));
                                    context.go(Routes.checkout);
                                  },
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}

String formatDateShort(BuildContext context, DateTime d) =>
    MaterialLocalizations.of(context).formatMediumDate(d.toLocal());

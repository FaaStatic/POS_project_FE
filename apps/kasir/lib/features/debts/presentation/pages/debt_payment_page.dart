import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../../../../app/di.dart';
import '../../../../common/failure_text.dart';
import '../../../../common/labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/debt_payment_cubit.dart';

class DebtPaymentPage extends StatefulWidget {
  const DebtPaymentPage({super.key, required this.debtId});
  final String debtId;

  @override
  State<DebtPaymentPage> createState() => _DebtPaymentPageState();
}

class _DebtPaymentPageState extends State<DebtPaymentPage> {
  final _amount = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => getIt<DebtPaymentCubit>()..load(widget.debtId),
      child: BlocConsumer<DebtPaymentCubit, DebtPaymentState>(
        listenWhen: (a, b) => b.receipt != null && a.receipt == null,
        listener: (context, s) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.paymentRecorded(rupiah(context, s.receipt!.remaining))))),
        builder: (context, state) {
          final debt = state.debt;
          return Scaffold(
            appBar: AppBar(title: Text(l10n.receivePayment)),
            body: state.loading
                ? const LoadingView()
                : debt == null
                    ? ErrorState(
                        message: failureText(context, state.failure!),
                        onRetry: () => context.read<DebtPaymentCubit>().load(widget.debtId),
                      )
                    : SingleChildScrollView(
                        child: ConstrainedBody(
                          padding: const EdgeInsets.all(Space.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(debt.customerName, style: theme.textTheme.titleMedium),
                              const SizedBox(height: Space.xs),
                              Text(l10n.remaining(rupiah(context, debt.remaining), rupiah(context, debt.total)),
                                  style: theme.textTheme.headlineSmall?.tabular),
                              const SizedBox(height: Space.xl),
                              if (debt.remaining > 0) ...[
                                AppTextField(
                                  label: l10n.paymentAmount,
                                  controller: _amount,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                ),
                                const SizedBox(height: Space.sm),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () => _amount.text = '${debt.remaining}',
                                    child: Text(l10n.payFull(rupiah(context, debt.remaining))),
                                  ),
                                ),
                              ],
                              if (state.failure != null) ...[
                                const SizedBox(height: Space.md),
                                Text(failureText(context, state.failure!), style: TextStyle(color: theme.colorScheme.error)),
                              ],
                              const SizedBox(height: Space.xl),
                              Text(l10n.onlineOnly, style: theme.textTheme.bodySmall),
                              const SizedBox(height: Space.sm),
                              AppButton(
                                label: l10n.receivePayment,
                                large: true,
                                expand: true,
                                loading: state.paying,
                                onPressed: debt.remaining <= 0
                                    ? null
                                    : () => context.read<DebtPaymentCubit>().pay(int.tryParse(_amount.text) ?? 0),
                              ),
                            ],
                          ),
                        ),
                      ),
          );
        },
      ),
    );
  }
}

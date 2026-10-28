import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ui/ui.dart';

import '../../common/failure_text.dart';
import '../../features/checkout/presentation/bloc/checkout_bloc.dart';
import '../../features/checkout/presentation/widgets/assign_barcode_sheet.dart';
import '../../features/push/data/push_service.dart';
import '../../features/sync/presentation/bloc/sync_cubit.dart';
import '../../l10n/app_localizations.dart';
import '../di.dart';

/// Lives for one signed-in session: owns the checkout bloc (so QRIS/VA polling
/// continues on every tab), the sync cubit, push wiring, and checkout snackbars.
class SessionScope extends StatefulWidget {
  const SessionScope({super.key, required this.child});
  final Widget child;

  @override
  State<SessionScope> createState() => _SessionScopeState();
}

class _SessionScopeState extends State<SessionScope> {
  late final CheckoutBloc _checkout = getIt<CheckoutBloc>()..add(const CheckoutStarted());
  late final SyncCubit _sync = getIt<SyncCubit>()..start();
  final _subs = <StreamSubscription<String>>[];

  @override
  void initState() {
    super.initState();
    final push = getIt<PushService>();
    unawaited(push.registerDevice());
    _subs
      ..add(push.paymentUpdates.listen((orderId) => _checkout.add(ChargesPolled(orderId: orderId))))
      ..add(push.openedPayments.listen(_openPayment));
  }

  /// Notification tap: show the sale if it is already recorded, otherwise the waiting tab.
  Future<void> _openPayment(String orderId) async {
    _checkout.add(ChargesPolled(orderId: orderId));
    final status = await getIt<CheckPaymentStatus>()(orderId);
    final transactionId = switch (status) {
      Ok(:final value) => value.transactionId,
      Err() => null,
    };
    final sale = transactionId == null ? null : await getIt<SalesLog>().byTransactionId(transactionId);
    if (!mounted) return;
    sale == null ? context.go('/checkout') : context.push('/sale/${sale.clientRef}');
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _checkout.close();
    _sync.close();
    super.dispose();
  }

  void _notice(BuildContext context, CheckoutNotice notice) {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    void show(String text, {SnackBarAction? action}) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(text), action: action));
    }

    switch (notice) {
      case ScanAddedNotice(:final productName, :final tabNumber):
        show(l10n.scanAdded(productName, tabNumber));
      case ScanUnknownNotice(:final code):
        show(
          l10n.unknownBarcode(code),
          action: SnackBarAction(
            label: l10n.assignBarcode,
            onPressed: () async {
              if (!_sync.state.online) {
                show(l10n.onlineOnly);
                return;
              }
              final product = await showAssignBarcode(context, code);
              if (product != null) {
                show(l10n.barcodeAssigned(product.name));
                _checkout.add(ProductAdded(product));
              }
            },
          ),
        );
      case SaleRecordedNotice(:final sale, :final offline):
        show(offline ? l10n.savedOffline : l10n.saved);
        context.push('/sale/${sale.clientRef}?print=1');
      case ChargePaidNotice(:final tabNumber):
        show(l10n.chargePaid(tabNumber));
      case ChargeFailedNotice(:final tabNumber):
        show(l10n.chargeFailed(tabNumber));
      case StaleDraftsNotice(:final count):
        show(l10n.staleDraftsRemoved(count));
      case TabLockedNotice():
        show(l10n.tabLocked);
      case FailureNotice(failure: TimeoutFailure()):
        show(l10n.timeoutUnknown);
      case FailureNotice(:final failure):
        show(failureText(context, failure));
    }
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _checkout),
          BlocProvider.value(value: _sync),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<CheckoutBloc, CheckoutState>(
              listenWhen: (a, b) => a.noticeId != b.noticeId && b.notice != null,
              listener: (context, s) => _notice(context, s.notice!),
            ),
            BlocListener<SyncCubit, SyncState>(
              listenWhen: (a, b) => a.reportId != b.reportId,
              listener: (context, s) {
                final l10n = AppLocalizations.of(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(s.failure != null ? failureText(context, s.failure!) : l10n.syncDone(s.lastReport?.synced ?? 0)),
                ));
              },
            ),
          ],
          child: widget.child,
        ),
      );
}

/// Offline / pending banner with the manual sync button, shown above every tab.
class SyncBanner extends StatelessWidget {
  const SyncBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SyncCubit>().state;
    return OfflineBanner(
      offline: !s.online,
      pendingCount: s.pending,
      syncing: s.syncing,
      syncLabel: s.online ? AppLocalizations.of(context).syncNow : null,
      onSync: () => context.read<SyncCubit>().syncNow(),
    );
  }
}

/// Manual sync row for the settings page. Disabled while offline or syncing.
class SyncTile extends StatelessWidget {
  const SyncTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final s = context.watch<SyncCubit>().state;
    return ListTile(
      leading: const Icon(Iconsax.refresh_copy),
      title: Text(l10n.syncNow),
      subtitle: Text(l10n.syncPending(s.pending)),
      trailing: s.syncing
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
      enabled: s.online && !s.syncing,
      onTap: () => context.read<SyncCubit>().syncNow(),
    );
  }
}

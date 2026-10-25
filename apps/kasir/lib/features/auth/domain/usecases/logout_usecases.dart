import 'package:core/core.dart';

class LogoutCheck {
  const LogoutCheck({this.awaitingTab, this.openTabs = 0, this.pendingSales = 0});

  /// Number of a tab waiting for QRIS/VA; logout is blocked while set.
  final int? awaitingTab;
  final int openTabs;
  final int pendingSales;

  bool get blocked => awaitingTab != null;
  bool get needsConfirmation => openTabs > 0 || pendingSales > 0;
}

class CheckLogout {
  const CheckLogout(this._drafts, this._sales);
  final DraftRepository _drafts;
  final SalesLog _sales;

  Future<LogoutCheck> call() async {
    final drafts = await _drafts.all();
    final awaiting = drafts.where((d) => d.status == DraftStatus.awaitingPayment).firstOrNull;
    return LogoutCheck(
      awaitingTab: awaiting?.number,
      openTabs: drafts.where((d) => !d.isEmpty || d.status == DraftStatus.paid).length,
      pendingSales: (await _sales.pending()).length,
    );
  }
}

/// Drafts are discarded on logout; queued sales stay on the device for the next sign-in.
class DiscardDrafts {
  const DiscardDrafts(this._drafts);
  final DraftRepository _drafts;

  Future<void> call() => _drafts.deleteAll();
}

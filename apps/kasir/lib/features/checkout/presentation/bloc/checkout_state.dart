import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_state.freezed.dart';

/// One-shot messages for snackbars and navigation; [CheckoutState.noticeId] changes with each.
sealed class CheckoutNotice {
  const CheckoutNotice();
}

final class ScanAddedNotice extends CheckoutNotice {
  const ScanAddedNotice(this.productName, this.tabNumber);
  final String productName;
  final int tabNumber;
}

final class ScanUnknownNotice extends CheckoutNotice {
  const ScanUnknownNotice(this.code);
  final String code;
}

final class SaleRecordedNotice extends CheckoutNotice {
  const SaleRecordedNotice(this.sale, {required this.offline});
  final Sale sale;
  final bool offline;
}

final class ChargeFailedNotice extends CheckoutNotice {
  const ChargeFailedNotice(this.tabNumber);
  final int tabNumber;
}

final class ChargePaidNotice extends CheckoutNotice {
  const ChargePaidNotice(this.tabNumber);
  final int tabNumber;
}

final class StaleDraftsNotice extends CheckoutNotice {
  const StaleDraftsNotice(this.count);
  final int count;
}

final class FailureNotice extends CheckoutNotice {
  const FailureNotice(this.failure);
  final Failure failure;
}

final class TabLockedNotice extends CheckoutNotice {
  const TabLockedNotice();
}

@freezed
abstract class CheckoutState with _$CheckoutState {
  const CheckoutState._();

  const factory CheckoutState({
    @Default([]) List<Draft> drafts,
    int? activeId,
    @Default(true) bool online,
    @Default(false) bool loading,
    @Default(false) bool paying,
    @Default(PaymentMethod.cash) PaymentMethod method,
    @Default(VaBank.bca) VaBank vaBank,
    @Default(<String, double>{}) Map<String, double> shortfalls,
    CheckoutNotice? notice,
    @Default(0) int noticeId,
  }) = _CheckoutState;

  Draft? get active => drafts.where((d) => d.id == activeId).firstOrNull;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt.freezed.dart';

@freezed
abstract class Debt with _$Debt {
  const Debt._();

  const factory Debt({
    required String id,
    required String customerId,
    @Default('') String customerName,
    required int total,
    required int remaining,
    required bool paid,
    DateTime? date,
  }) = _Debt;

  int get paidAmount => total - remaining;
}

@freezed
abstract class DebtPaymentReceipt with _$DebtPaymentReceipt {
  const factory DebtPaymentReceipt({
    required String debtId,
    required String customerName,
    required int amount,
    required int previousRemaining,
    required int remaining,
    required bool paid,
    DateTime? paidAt,
  }) = _DebtPaymentReceipt;
}

class DebtQuery {
  const DebtQuery({this.customerId, this.search, this.unpaidOnly = false, this.oldestFirst = false, this.limit = 20});
  final String? customerId;
  final String? search;
  final bool unpaidOnly;
  final bool oldestFirst;
  final int limit;
}

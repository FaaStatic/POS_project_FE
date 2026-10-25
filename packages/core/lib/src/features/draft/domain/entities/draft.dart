import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../payment/domain/entities/payment.dart';

part 'draft.freezed.dart';

enum DraftStatus { open, awaitingPayment, paid }

@freezed
abstract class DraftItem with _$DraftItem {
  const DraftItem._();

  const factory DraftItem({
    required int id,
    required String productId,
    required String name,
    required int unitPrice,
    required int debtPrice,
    required double qty,
    @Default(0) int unit,
    @Default(false) bool isDigital,
    String? destination,
  }) = _DraftItem;

  int price({required bool debt}) => debt ? debtPrice : unitPrice;
  int subtotal({required bool debt}) => (qty * price(debt: debt)).round();
  bool get missingDestination => isDigital && (destination == null || destination!.trim().isEmpty);
}

/// Locally stored "Transaksi N" tab. Never sent to the server, never locks stock.
@freezed
abstract class Draft with _$Draft {
  const Draft._();

  const factory Draft({
    required int id,
    required int number,
    String? customerId,
    String? customerName,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(DraftStatus.open) DraftStatus status,
    Charge? charge,
    String? paidSaleRef,
    @Default([]) List<DraftItem> items,
  }) = _Draft;

  bool get isEmpty => items.isEmpty;
  bool get isLocked => status != DraftStatus.open;
  bool get hasDigital => items.any((i) => i.isDigital);
  double get itemCount => items.fold(0, (sum, i) => sum + i.qty);
  int total({bool debt = false}) => items.fold(0, (sum, i) => sum + i.subtotal(debt: debt));
}

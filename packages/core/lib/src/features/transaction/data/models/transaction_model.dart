import '../../../../common/json.dart';
import '../../../../constants/payment_method.dart';
import '../../domain/entities/change_line.dart';
import '../../domain/entities/transaction.dart';

abstract final class TransactionModel {
  static Transaction fromJson(Map<String, dynamic> j) => Transaction(
        id: readString(j['transaction_id']),
        invoice: readString(j['invoice_number']),
        method: PaymentMethod.fromIndex(readInt(j['payment_type'])),
        total: readInt(j['total_transaction']),
        profit: readInt(j['total_profit']),
        stockConflict: readBool(j['stock_conflict']),
        conflictReviewed: readBool(j['conflict_reviewed']),
        status: TransactionStatus.parse(readString(j['status'])),
        cancelReason: readString(j['cancel_reason']),
        createdAt: readDate(j['created_at']),
        items: [
          for (final d in readList(j['transaction_details']))
            TransactionItem(
              productId: readString(d['product_id']),
              name: readString(d['product_name']),
              price: readInt(d['price']),
              qty: readDouble(d['qty']),
              subtotal: readInt(d['subtotal']),
            ),
        ],
        amountPaid: j['amount_paid'] == null ? null : readInt(j['amount_paid']),
        changeAmount: j['change_amount'] == null ? null : readInt(j['change_amount']),
        change: [
          for (final c in readList(j['change']))
            ChangeLine(
              kind: ChangeKind.fromWire(readNullableString(c['kind'])),
              amount: readInt(c['amount']),
              productId: readNullableString(c['product_id']),
              productName: readString(c['product_name']),
              qty: readDouble(c['qty']),
            ),
        ],
      );

  static Map<String, dynamic> checkoutToJson(CheckoutRequest r) => {
        'no_invoice': r.invoice,
        'type_payment': r.method.wire,
        'user_id': r.userId,
        'customer_id': ?r.customerId,
        'details': [
          for (final l in r.lines) {'product_id': l.productId, 'qty': l.qty, 'destination': ?l.destination},
        ],
        ..._changeToJson(r.amountPaid, r.change),
      };

  /// The server prices goods itself, so only cash lines send an amount.
  static Map<String, dynamic> _changeToJson(int? amountPaid, List<ChangeLine> change) => {
        'amount_paid': ?amountPaid,
        if (change.isNotEmpty)
          'change': [
            for (final c in change)
              c.isCash
                  ? {'kind': c.kind.wire, 'amount': c.amount}
                  : {'kind': c.kind.wire, 'product_id': c.productId, 'qty': c.qty},
          ],
      };

  static CheckoutResult checkoutResultFromJson(Map<String, dynamic> j) => CheckoutResult(
        transactionId: readString(j['transaction_id']),
        invoice: readString(j['no_invoice']),
        total: readInt(j['total_transaction']),
        method: PaymentMethod.fromWire(readString(j['payment_type'])),
        stockConflict: readBool(j['stock_conflict']),
        debtRemaining: j['debt_info'] is Map ? readInt(readMap(j['debt_info'])['remaining_debt']) : null,
      );

  static Map<String, dynamic> offlineToJson(OfflineSale s) => {
        'client_ref': s.clientRef,
        'created_at_client': s.createdAt.toUtc().toIso8601String(),
        'type_payment': s.method.wire,
        'customer_id': ?s.customerId,
        'details': [
          for (final l in s.lines)
            {'product_id': l.productId, 'qty': l.qty, 'unit_price': l.unitPrice, 'destination': ?l.destination},
        ],
        ..._changeToJson(s.amountPaid, s.change),
      };

  static SyncResult syncResultFromJson(Map<String, dynamic> j) => SyncResult(
        clientRef: readString(j['client_ref']),
        status: switch (readString(j['status'])) {
          'created' => SyncStatus.created,
          'duplicate' => SyncStatus.duplicate,
          _ => SyncStatus.failed,
        },
        transactionId: readNullableString(j['transaction_id']),
        invoice: readNullableString(j['no_invoice']),
        stockConflict: readBool(j['stock_conflict']),
        retryable: readBool(j['retryable']),
        error: readNullableString(j['error']),
      );
}

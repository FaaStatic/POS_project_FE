import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

ChangeLine goods(double qty, {int price = 500, bool whole = true, ChangeKind kind = ChangeKind.candy}) => ChangeLine.goods(
      kind: kind,
      productId: 'p1',
      productName: 'Permen',
      qty: qty,
      unitPrice: price,
      wholeOnly: whole,
    );

String? check({int? paid, int total = 8500, PaymentMethod method = PaymentMethod.cash, List<ChangeLine> change = const []}) =>
    validateChange(method: method, total: total, amountPaid: paid, change: change);

void main() {
  group('ChangeLine', () {
    test('goods are valued at selling price times qty, rounded', () {
      expect(goods(3).amount, 1500);
      expect(goods(0.25, price: 10000, whole: false, kind: ChangeKind.product).amount, 2500);
      expect(goods(0.333, price: 1000, whole: false).amount, 333);
    });

    test('wire names follow the backend', () {
      expect(ChangeKind.values.map((k) => k.wire), ['tunai', 'permen', 'produk_lain']);
    });
  });

  group('validateChange', () {
    test('no amount paid and no lines is the old behaviour', () => expect(check(), isNull));

    test('lines without an amount paid are rejected', () {
      expect(check(change: [ChangeLine.cash(500)]), 'amount_paid_required');
    });

    test('only cash payments carry change', () {
      expect(check(method: PaymentMethod.debt, paid: 10000, change: [ChangeLine.cash(1500)]), 'change_cash_only');
    });

    test('paying less than the total fails', () => expect(check(paid: 8000), 'amount_paid_short'));

    test('exact payment needs no lines', () => expect(check(paid: 8500), isNull));

    test('lines must add up to the change due', () {
      expect(check(paid: 10000, change: [ChangeLine.cash(1000)]), 'change_mismatch');
      expect(check(paid: 10000, change: [ChangeLine.cash(1500)]), isNull);
      expect(check(paid: 10000, change: [ChangeLine.cash(500), goods(2)]), isNull);
      expect(check(paid: 10000), 'change_mismatch');
    });

    test('goods need a whole qty for pcs and at most 3 decimals otherwise', () {
      expect(check(paid: 9500, change: [goods(1.5, price: 666)]), 'invalid_qty');
      expect(check(paid: 9500, change: [goods(0.3333, price: 3000, whole: false)]), 'invalid_qty');
      expect(check(paid: 9500, change: [goods(0.5, price: 2000, whole: false)]), isNull);
    });

    test('a zero or negative line is rejected', () {
      expect(check(paid: 9000, change: [ChangeLine.cash(500), ChangeLine.cash(0)]), 'change_invalid');
    });
  });

  group('wire', () {
    test('checkout request carries amount_paid and change, skipped when absent', () {
      const base = CheckoutRequest(invoice: 'INV-1', userId: 'u1', method: PaymentMethod.cash, lines: []);
      expect(TransactionModel.checkoutToJson(base).containsKey('amount_paid'), isFalse);
      expect(TransactionModel.checkoutToJson(base).containsKey('change'), isFalse);

      final json = TransactionModel.checkoutToJson(
        base.copyWith(amountPaid: 10000, change: [ChangeLine.cash(500), goods(2)]),
      );
      expect(json['amount_paid'], 10000);
      expect(json['change'], [
        {'kind': 'tunai', 'amount': 500},
        {'kind': 'permen', 'product_id': 'p1', 'qty': 2.0},
      ]);
    });

    test('offline sale carries the same fields', () {
      final json = TransactionModel.offlineToJson(
        OfflineSale(
          clientRef: 'r1',
          createdAt: DateTime.utc(2026, 11, 3),
          method: PaymentMethod.cash,
          lines: const [],
          amountPaid: 10000,
          change: [ChangeLine.cash(1500)],
        ),
      );
      expect(json['amount_paid'], 10000);
      expect(json['change'], [
        {'kind': 'tunai', 'amount': 1500},
      ]);
    });

    test('a server transaction keeps the cash received and each part of the change', () {
      final t = TransactionModel.fromJson({
        'transaction_id': 't1',
        'invoice_number': 'INV-1',
        'payment_type': 0,
        'total_transaction': 7000,
        'amount_paid': 10000,
        'change_amount': 3000,
        'change': [
          {'kind': 'tunai', 'amount': 1000},
          {'kind': 'permen', 'amount': 2000, 'product_id': 'p1', 'product_name': 'Permen', 'qty': 4},
        ],
      });
      expect(t.amountPaid, 10000);
      expect(t.changeAmount, 3000);
      expect(t.change.map((c) => c.kind), [ChangeKind.cash, ChangeKind.candy]);
      expect(t.change[1], isA<ChangeLine>().having((c) => c.productName, 'productName', 'Permen').having((c) => c.qty, 'qty', 4));
    });

    test('a transaction without change info reads as not recorded', () {
      final t = TransactionModel.fromJson({'transaction_id': 't1', 'invoice_number': 'INV-1', 'payment_type': 1, 'total_transaction': 7000});
      expect(t.amountPaid, isNull);
      expect(t.changeAmount, isNull);
      expect(t.change, isEmpty);
    });
  });
}

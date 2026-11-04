import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/features/checkout/domain/usecases/checkout_usecases.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';

void main() {
  late LocalFixture local;
  late MockDebts debts;
  late MockAuth auth;
  late FakeNetwork network;

  const debt = Debt(id: 'd1', customerId: 'k1', customerName: 'Bu Sri', total: 9000, remaining: 5000, paid: false);

  setUp(() async {
    local = LocalFixture();
    debts = MockDebts();
    auth = MockAuth();
    network = FakeNetwork();
    when(() => auth.current).thenReturn(staff);
    await local.cache.replaceDebts(const [debt]);
  });
  tearDown(() => local.close());

  PayDebtAtCounter pay() => PayDebtAtCounter(
        debts: debts,
        sales: local.sales,
        drafts: local.drafts,
        cache: local.cache,
        network: network,
        session: GetCurrentSession(auth),
        clock: () => DateTime(2026, 10, 25, 9),
        newRef: () => 'ref-1',
      );

  Future<Draft> debtTab({bool customer = true}) async {
    final d = await local.drafts.create(kind: DraftKind.debtPayment);
    if (customer) await local.drafts.setCustomer(d.id, id: 'k1', name: 'Bu Sri');
    return (await local.drafts.byId(d.id))!;
  }

  void serverAccepts({int remaining = 2000}) => when(
        () => debts.pay(debtId: any(named: 'debtId'), userId: any(named: 'userId'), amount: any(named: 'amount'), idempotencyKey: any(named: 'idempotencyKey')),
      ).thenAnswer((_) async => Ok(DebtPaymentReceipt(debtId: 'd1', customerName: 'Bu Sri', amount: 3000, previousRemaining: 5000, remaining: remaining, paid: remaining == 0)));

  test('online: paid at the server, receipt keeps before/after, change is cash, tab closes', () async {
    serverAccepts();
    final draft = await debtTab();
    final outcome = (await pay()(draft, amount: 3000, cashReceived: 5000) as Ok<CheckoutOutcome>).value;
    expect(outcome.offline, isFalse);
    final sale = outcome.sale;
    expect([sale.kind, sale.status, sale.total, sale.debtBefore, sale.debtAfter], [SaleKind.debtPayment, SaleStatus.synced, 3000, 5000, 2000]);
    expect(sale.receiptNumber, startsWith('HTG-'));
    expect(sale.change.single.amount, 2000);
    verify(() => debts.pay(debtId: 'd1', userId: 'u1', amount: 3000, idempotencyKey: sale.receiptNumber)).called(1);
    expect((await local.cache.debtOfCustomer('k1'))!.remaining, 2000);
    expect(await local.drafts.byId(draft.id), isNull);
  });

  test('offline: queued, cache lowered, settled debt leaves the cache', () async {
    network.online = false;
    final draft = await debtTab();
    final outcome = (await pay()(draft, amount: 5000, cashReceived: 5000) as Ok<CheckoutOutcome>).value;
    expect(outcome.offline, isTrue);
    expect(outcome.sale.debtSettled, isTrue);
    expect((await local.sales.pending(kind: SaleKind.debtPayment)).single.clientRef, 'ref-1');
    expect(await local.cache.debtOfCustomer('k1'), isNull);
    verifyNever(() => debts.pay(debtId: any(named: 'debtId'), userId: any(named: 'userId'), amount: any(named: 'amount'), idempotencyKey: any(named: 'idempotencyKey')));
  });

  test('a dropped connection queues the payment instead of losing it', () async {
    when(() => debts.pay(debtId: any(named: 'debtId'), userId: any(named: 'userId'), amount: any(named: 'amount'), idempotencyKey: any(named: 'idempotencyKey')))
        .thenAnswer((_) async => const Err(NetworkFailure()));
    final outcome = (await pay()(await debtTab(), amount: 1000, cashReceived: 1000) as Ok<CheckoutOutcome>).value;
    expect(outcome.offline, isTrue);
    expect(outcome.sale.status, SaleStatus.pending);
  });

  test('refuses: no customer, no debt, zero, more than owed, less cash than amount, server rejection', () async {
    Future<Failure?> failure(Draft d, int amount, int cash) async => (await pay()(d, amount: amount, cashReceived: cash) as Err<CheckoutOutcome>).failure;
    expect(await failure(await debtTab(customer: false), 1000, 1000), const ValidationFailure('customer_required'));
    expect(await failure(await debtTab(), 0, 0), const ValidationFailure('positive_number'));
    expect(await failure(await debtTab(), 5001, 6000), const ValidationFailure('exceeds_remaining'));
    expect(await failure(await debtTab(), 3000, 2000), const ValidationFailure('amount_paid_short'));
    final sale = await local.drafts.create();
    expect(await failure(sale, 1000, 1000), const ValidationFailure('not_debt_tab'));

    when(() => debts.pay(debtId: any(named: 'debtId'), userId: any(named: 'userId'), amount: any(named: 'amount'), idempotencyKey: any(named: 'idempotencyKey')))
        .thenAnswer((_) async => const Err(ConflictFailure('already_paid')));
    expect(await failure(await debtTab(), 1000, 1000), const ConflictFailure('already_paid'));
    expect(await local.sales.pending(), isEmpty);
    expect((await local.cache.debtOfCustomer('k1'))!.remaining, 5000);
  });
}

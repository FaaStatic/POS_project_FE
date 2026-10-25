import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/features/checkout/domain/usecases/checkout_usecases.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';

void main() {
  late LocalFixture local;
  late MockTransactions remote;
  late MockAuth auth;
  late FakeNetwork network;
  var refs = 0;

  setUpAll(registerFallbacks);

  setUp(() async {
    local = LocalFixture();
    await local.seed();
    remote = MockTransactions();
    auth = MockAuth();
    network = FakeNetwork();
    refs = 0;
    when(() => auth.current).thenReturn(staff);
  });
  tearDown(() => local.close());

  CheckoutTransaction checkout() => CheckoutTransaction(
        transactions: remote,
        sales: local.sales,
        drafts: local.drafts,
        cache: local.cache,
        network: network,
        session: GetCurrentSession(auth),
        clock: () => DateTime(2026, 10, 25, 9),
        newRef: () => 'ref-${++refs}',
      );

  group('CheckoutTransaction', () {
    test('online cash sale is recorded with the server invoice and closes the tab', () async {
      final draft = await local.draftWith([(indomie, 2)]);
      when(() => remote.create(any())).thenAnswer((_) async => const Ok(CheckoutResult(
            transactionId: 't1', invoice: 'INV-1', total: 7000, method: PaymentMethod.cash)));
      final outcome = (await checkout()(draft, PaymentMethod.cash) as Ok<CheckoutOutcome>).value;
      expect(outcome.offline, isFalse);
      expect(outcome.sale.receiptNumber, 'INV-1');
      expect(outcome.sale.status, SaleStatus.synced);
      expect(await local.drafts.byId(draft.id), isNull);
      expect((await local.cache.product('p1'))!.stock, 8);
      expect(await local.sales.pending(), isEmpty);
    });

    test('offline cash sale is queued with an OFF number and local stock drops', () async {
      network.online = false;
      final draft = await local.draftWith([(indomie, 3)]);
      final outcome = (await checkout()(draft, PaymentMethod.cash) as Ok<CheckoutOutcome>).value;
      expect(outcome.offline, isTrue);
      expect(outcome.sale.receiptNumber, startsWith('OFF-'));
      expect(outcome.sale.lines.single.unitPrice, 3500);
      expect((await local.sales.pending()).single.clientRef, 'ref-1');
      expect((await local.cache.product('p1'))!.stock, 7);
      verifyNever(() => remote.create(any()));
    });

    test('connection refused online falls back to the offline queue', () async {
      final draft = await local.draftWith([(indomie, 1)]);
      when(() => remote.create(any())).thenAnswer((_) async => const Err(NetworkFailure()));
      final outcome = (await checkout()(draft, PaymentMethod.cash) as Ok<CheckoutOutcome>).value;
      expect(outcome.offline, isTrue);
    });

    test('timeout is not queued, to avoid recording the sale twice', () async {
      final draft = await local.draftWith([(indomie, 1)]);
      when(() => remote.create(any())).thenAnswer((_) async => const Err(TimeoutFailure()));
      expect(await checkout()(draft, PaymentMethod.cash), const Err<CheckoutOutcome>(TimeoutFailure()));
      expect(await local.sales.pending(), isEmpty);
      expect(await local.drafts.byId(draft.id), isNotNull);
    });

    test('server rejection keeps the tab open', () async {
      final draft = await local.draftWith([(indomie, 1)]);
      when(() => remote.create(any())).thenAnswer((_) async => const Err(ValidationFailure('insufficient stock')));
      expect(await checkout()(draft, PaymentMethod.cash), const Err<CheckoutOutcome>(ValidationFailure('insufficient stock')));
      expect(await local.drafts.byId(draft.id), isNotNull);
    });

    test('offline debt uses the debt price and requires a customer', () async {
      network.online = false;
      final noCustomer = await local.draftWith([(indomie, 1)]);
      expect(await checkout()(noCustomer, PaymentMethod.debt), const Err<CheckoutOutcome>(ValidationFailure('debt_needs_customer')));
      final draft = await local.draftWith([(indomie, 2)], customerId: 'k1', customerName: 'Bu Sri');
      final sale = (await checkout()(draft, PaymentMethod.debt) as Ok<CheckoutOutcome>).value.sale;
      expect(sale.total, 8000);
      expect(sale.customerName, 'Bu Sri');
    });

    test('digital lines need a destination', () async {
      final draft = await local.draftWith([(pulsa, 1)]);
      expect(await checkout()(draft, PaymentMethod.cash), const Err<CheckoutOutcome>(ValidationFailure('destination_required')));
      await local.drafts.setDestination(draft.items.single.id, '08123');
      when(() => remote.create(any())).thenAnswer((_) async =>
          const Ok(CheckoutResult(transactionId: 't', invoice: 'INV', total: 11000, method: PaymentMethod.cash)));
      final ok = await checkout()((await local.drafts.byId(draft.id))!, PaymentMethod.cash);
      expect((ok as Ok<CheckoutOutcome>).value.sale.lines.single.destination, '08123');
      final sent = verify(() => remote.create(captureAny())).captured.single as CheckoutRequest;
      expect(sent.lines.single.destination, '08123');
    });

    test('QRIS is not a checkout method and locked tabs are refused', () async {
      final draft = await local.draftWith([(indomie, 1)]);
      expect(await checkout()(draft, PaymentMethod.qris), const Err<CheckoutOutcome>(ValidationFailure('use_charge')));
      expect(await checkout()(draft.copyWith(status: DraftStatus.awaitingPayment), PaymentMethod.cash),
          const Err<CheckoutOutcome>(ConflictFailure('draft_locked')));
    });

    test('signed out user cannot check out', () async {
      when(() => auth.current).thenReturn(null);
      final draft = await local.draftWith([(indomie, 1)]);
      expect(await checkout()(draft, PaymentMethod.cash), const Err<CheckoutOutcome>(UnauthorizedFailure()));
    });
  });

  group('tabs', () {
    test('add, scan known and unknown codes, close', () async {
      final draft = await OpenDraft(local.drafts)();
      final add = AddItem(local.drafts);
      expect(await add(draft, aqua), isA<Ok<void>>());
      final scan = ScanBarcode(local.cache, add);
      expect(await scan(draft, ' 899 '), isA<ScanAdded>());
      expect(await scan(draft, '000'), isA<ScanUnknown>());
      expect(await scan(draft.copyWith(status: DraftStatus.paid), '899'), isA<ScanLocked>());
      expect((await local.drafts.byId(draft.id))!.items.length, 2);
      expect(await CloseDraft(local.drafts)(draft), isA<Ok<void>>());
      expect(await CloseDraft(local.drafts)(draft.copyWith(status: DraftStatus.awaitingPayment)),
          const Err<void>(ConflictFailure('awaiting_payment')));
    });

    test('purge removes drafts idle for 24 hours', () async {
      await local.drafts.create();
      final purge = PurgeStaleDrafts(local.drafts, clock: () => DateTime.now().add(const Duration(hours: 25)));
      expect(await purge(), 1);
    });

    test('stock shortfall is flagged when another tab already sold the stock', () async {
      final draft = await local.draftWith([(aqua, 1), (indomie, 1)]);
      final short = FindStockShortfalls(local.cache);
      expect(await short(draft), isEmpty);
      await local.cache.adjustStock({'p2': -1});
      expect(await short(draft), {'p2': 0.0});
      expect(await short(await local.draftWith([(pulsa, 1)])), isEmpty);
    });
  });

  group('charges', () {
    late MockPayments payments;
    setUp(() => payments = MockPayments());

    StartCharge start() => StartCharge(
          qris: ChargeQris(payments),
          va: ChargeVa(payments),
          drafts: local.drafts,
          network: network,
          session: GetCurrentSession(auth),
        );

    ResolveCharge resolve() => ResolveCharge(
          status: CheckPaymentStatus(payments),
          transactions: remote,
          sales: local.sales,
          drafts: local.drafts,
          cache: local.cache,
          session: GetCurrentSession(auth),
          newRef: () => 'paid-${++refs}',
        );

    const charge = Charge(orderId: 'ORD-1', method: ChargeMethod.qris, state: PaymentState.pending, grossAmount: 7070);

    test('QRIS charge locks the tab', () async {
      final draft = await local.draftWith([(indomie, 2)]);
      when(() => payments.chargeQris(userId: 'u1', customerId: null, items: any(named: 'items')))
          .thenAnswer((_) async => const Ok(charge));
      expect(await start()(draft, ChargeMethod.qris), const Ok(charge));
      expect((await local.drafts.byId(draft.id))!.status, DraftStatus.awaitingPayment);
    });

    test('VA charge passes the bank', () async {
      final draft = await local.draftWith([(indomie, 1)]);
      when(() => payments.chargeVa(userId: 'u1', customerId: null, bank: VaBank.mandiri, items: any(named: 'items')))
          .thenAnswer((_) async => const Ok(charge));
      expect(await start()(draft, ChargeMethod.va, bank: VaBank.mandiri), isA<Ok<Charge>>());
    });

    test('charges need internet, a non-empty cart, and no digital products', () async {
      expect(await start()(await local.draftWith([]), ChargeMethod.qris), const Err<Charge>(ValidationFailure('empty_cart')));
      expect(await start()(await local.draftWith([(pulsa, 1)]), ChargeMethod.qris),
          const Err<Charge>(ValidationFailure('digital_needs_cash')));
      network.online = false;
      expect(await start()(await local.draftWith([(indomie, 1)]), ChargeMethod.qris), const Err<Charge>(NetworkFailure()));
    });

    test('settled charge records a sale and marks the tab paid', () async {
      final draft = await local.draftWith([(indomie, 2)]);
      await local.drafts.markAwaiting(draft.id, charge);
      when(() => payments.status('ORD-1')).thenAnswer((_) async => const Ok(ChargeStatus(
          orderId: 'ORD-1', state: PaymentState.success, grossAmount: 7070, transactionId: 't9')));
      when(() => remote.get('t9')).thenAnswer((_) async =>
          const Ok(Transaction(id: 't9', invoice: 'INV-9', method: PaymentMethod.qris, total: 7070)));
      final awaiting = (await local.drafts.byId(draft.id))!;
      expect(await resolve()(awaiting), ChargeResolution.paid);
      final paid = (await local.drafts.byId(draft.id))!;
      expect(paid.status, DraftStatus.paid);
      final sale = (await local.sales.byRef(paid.paidSaleRef!))!;
      expect(sale.receiptNumber, 'INV-9');
      expect(sale.method, PaymentMethod.qris);
      expect((await local.cache.product('p1'))!.stock, 8);
      // A second poll after FCM must not record it twice.
      expect(await resolve()(awaiting), ChargeResolution.paid);
      expect((await local.sales.watchAll().first).length, 1);
    });

    test('expired charge reopens the tab; pending and errors keep waiting', () async {
      final draft = await local.draftWith([(indomie, 1)]);
      await local.drafts.markAwaiting(draft.id, charge);
      final awaiting = (await local.drafts.byId(draft.id))!;
      when(() => payments.status('ORD-1')).thenAnswer((_) async => const Err(NetworkFailure()));
      expect(await resolve()(awaiting), ChargeResolution.pending);
      when(() => payments.status('ORD-1'))
          .thenAnswer((_) async => const Ok(ChargeStatus(orderId: 'ORD-1', state: PaymentState.settling, grossAmount: 1)));
      expect(await resolve()(awaiting), ChargeResolution.pending);
      when(() => payments.status('ORD-1'))
          .thenAnswer((_) async => const Ok(ChargeStatus(orderId: 'ORD-1', state: PaymentState.expired, grossAmount: 1)));
      expect(await resolve()(awaiting), ChargeResolution.failed);
      expect((await local.drafts.byId(draft.id))!.status, DraftStatus.open);
      expect(await resolve()((await local.drafts.byId(draft.id))!), ChargeResolution.pending);
    });
  });
}

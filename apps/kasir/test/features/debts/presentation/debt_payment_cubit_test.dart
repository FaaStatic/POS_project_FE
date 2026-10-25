import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/features/debts/presentation/bloc/debt_payment_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';

class MockDebts extends Mock implements DebtRepository {}

void main() {
  late MockDebts debts;
  late MockAuth auth;
  const debt = Debt(id: 'd1', customerId: 'k1', total: 10000, remaining: 6000, paid: false);

  setUp(() {
    debts = MockDebts();
    auth = MockAuth();
    when(() => auth.current).thenReturn(staff);
    when(() => debts.get('d1')).thenAnswer((_) async => const Ok(debt));
  });

  DebtPaymentCubit build() => DebtPaymentCubit(GetDebt(debts), PayDebt(debts), GetCurrentSession(auth), idempotencyKey: 'key-1');

  test('loads and pays with a stable idempotency key', () async {
    when(() => debts.pay(debtId: 'd1', userId: 'u1', amount: 6000, idempotencyKey: 'key-1')).thenAnswer((_) async =>
        const Ok(DebtPaymentReceipt(debtId: 'd1', customerName: 'Bu Sri', amount: 6000, previousRemaining: 6000, remaining: 0, paid: true)));
    final cubit = build();
    await cubit.load('d1');
    expect(cubit.state.debt, debt);
    await cubit.pay(6000);
    expect(cubit.state.receipt?.paid, isTrue);
    expect(cubit.state.debt?.remaining, 0);
  });

  test('overpaying is refused before any request', () async {
    final cubit = build();
    await cubit.load('d1');
    await cubit.pay(7000);
    expect(cubit.state.failure, const ValidationFailure('exceeds_remaining'));
  });

  test('load failure and signed-out pay are reported', () async {
    when(() => debts.get('d1')).thenAnswer((_) async => const Err(NetworkFailure()));
    final cubit = build();
    await cubit.load('d1');
    expect(cubit.state.failure, const NetworkFailure());
    when(() => debts.get('d1')).thenAnswer((_) async => const Ok(debt));
    await cubit.load('d1');
    when(() => auth.current).thenReturn(null);
    await cubit.pay(1000);
    expect(cubit.state.failure, const UnauthorizedFailure());
  });
}

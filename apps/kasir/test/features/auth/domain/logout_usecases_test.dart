import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/features/auth/domain/usecases/logout_usecases.dart';

import '../../../helpers/fixtures.dart';
import '../../sync/domain/sync_usecases_test.dart' show queued;

void main() {
  late LocalFixture local;
  setUp(() => local = LocalFixture());
  tearDown(() => local.close());

  test('empty device logs out without confirmation', () async {
    await local.drafts.create();
    final check = await CheckLogout(local.drafts, local.sales)();
    expect(check.blocked, isFalse);
    expect(check.needsConfirmation, isFalse);
  });

  test('open tabs and queued sales need confirmation', () async {
    await local.draftWith([(indomie, 1)]);
    await local.sales.add(queued('a'));
    final check = await CheckLogout(local.drafts, local.sales)();
    expect([check.openTabs, check.pendingSales], [1, 1]);
    expect(check.needsConfirmation, isTrue);
  });

  test('a tab waiting for QRIS blocks logout and names the tab', () async {
    await local.draftWith([(indomie, 1)]);
    final waiting = await local.draftWith([(indomie, 1)]);
    await local.drafts.markAwaiting(waiting.id, const Charge(orderId: 'o', method: ChargeMethod.qris, state: PaymentState.pending, grossAmount: 1));
    final check = await CheckLogout(local.drafts, local.sales)();
    expect(check.blocked, isTrue);
    expect(check.awaitingTab, 2);
  });

  test('discard removes every draft', () async {
    await local.draftWith([(indomie, 1)]);
    await DiscardDrafts(local.drafts)();
    expect(await local.drafts.all(), isEmpty);
  });
}

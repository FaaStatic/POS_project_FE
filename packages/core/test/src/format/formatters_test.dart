import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id'));

  test('rupiah uses dot grouping in id and comma in en', () {
    expect(formatRupiah(12500), 'Rp 12.500');
    expect(formatRupiah(12500, locale: 'en'), 'Rp 12,500');
    expect(formatRupiah(-3000), '-Rp 3.000');
  });

  test('qty drops trailing zeros', () {
    expect(formatQty(2), '2');
    expect(formatQty(1.5), '1,5');
  });

  test('api date is yyyy-MM-dd', () {
    expect(apiDate(DateTime(2026, 3, 7)), '2026-03-07');
  });

  test('display dates are localized', () {
    expect(formatDate(DateTime(2026, 10, 25)), contains('2026'));
    expect(formatDateTime(DateTime(2026, 10, 25, 9, 5)), contains('09.05'));
  });

  test('PaymentMethod maps backend index and wire values', () {
    expect(PaymentMethod.fromIndex(3), PaymentMethod.qris);
    expect(PaymentMethod.fromIndex(9), PaymentMethod.cash);
    expect(PaymentMethod.fromWire('transfer'), PaymentMethod.va);
    expect(PaymentMethod.debt.worksOffline, isTrue);
    expect(PaymentMethod.qris.worksOffline, isFalse);
    expect(UserRole.parse('superadmin').isSuper, isTrue);
    expect(UserRole.parse('staff').isSuper, isFalse);
  });

  test('AppConfig requires API_BASE_URL', () {
    expect(() => AppConfig.fromEnv({}), throwsStateError);
    final c = AppConfig.fromEnv({'API_BASE_URL': 'http://x', 'FLAVOR': 'prod'});
    expect(c.isProd, isTrue);
  });
}

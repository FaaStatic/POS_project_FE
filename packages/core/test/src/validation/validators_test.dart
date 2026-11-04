import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('barcode follows backend rule: 1-64 of letters, digits, -._', () {
    expect(Validators.barcode(''), isNull);
    expect(Validators.barcode('8992388101012'), isNull);
    expect(Validators.barcode('AB-1.2_3'), isNull);
    expect(Validators.barcode('has space'), 'barcode_format');
    expect(Validators.barcode('x' * 65), 'barcode_format');
  });

  test('username and password lengths', () {
    expect(Validators.username('ab'), 'username_length');
    expect(Validators.username(' abc '), isNull);
    expect(Validators.username(''), 'required');
    expect(Validators.password('12345'), 'password_length');
    expect(Validators.password('123456'), isNull);
  });

  test('cancel reason is 3-500 characters', () {
    expect(Validators.cancelReason('ab'), 'reason_length');
    expect(Validators.cancelReason('salah input'), isNull);
    expect(Validators.cancelReason('x' * 501), 'reason_length');
  });

  test('quantity follows the backend rules: finite, 3 decimals, within range, whole for pcs', () {
    expect(Validators.quantity('0'), isNull);
    expect(Validators.quantity('2,125'), isNull);
    expect(Validators.quantity('0.5'), isNull);
    expect(Validators.quantity('999999999.999'), isNull);
    expect(Validators.quantity(''), 'non_negative_number');
    expect(Validators.quantity('abc'), 'non_negative_number');
    expect(Validators.quantity('-1'), 'non_negative_number');
    expect(Validators.quantity('NaN'), 'non_negative_number');
    expect(Validators.quantity('Infinity'), 'non_negative_number');
    expect(Validators.quantity('1.2345'), 'qty_decimals');
    expect(Validators.quantity('1000000000'), 'qty_too_large');
    expect(Validators.quantity('1e10'), 'qty_too_large');
    expect(Validators.quantity('2.5', whole: true), 'qty_whole');
    expect(Validators.quantity('3', whole: true), isNull);
  });

  test('quantity accepts a negative adjustment only when signed', () {
    expect(Validators.quantity('-2.5', signed: true), isNull);
    expect(Validators.quantity('-2.5'), 'non_negative_number');
    expect(Validators.quantity('-2.5', signed: true, whole: true), 'qty_whole');
    expect(Validators.quantity('-1000000000', signed: true), 'qty_too_large');
  });

  test('numbers, sku, category', () {
    expect(Validators.positiveInt('0'), 'positive_number');
    expect(Validators.positiveInt('2500'), isNull);
    expect(Validators.nonNegativeNumber('1,5'), isNull);
    expect(Validators.nonNegativeNumber('-1'), 'non_negative_number');
    expect(Validators.sku(''), 'required');
    expect(Validators.sku('x' * 51), 'sku_length');
    expect(Validators.categoryName('x' * 101), 'category_length');
    expect(Validators.categoryKey('  Mie Instan '), 'mie instan');
    expect(Validators.required(' '), 'required');
  });
}

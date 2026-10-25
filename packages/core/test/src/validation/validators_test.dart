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

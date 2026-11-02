import 'package:cms/common/auto_sku.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TextEditingController field;
  late AutoSku sku;

  setUp(() {
    field = TextEditingController();
    sku = AutoSku(field);
  });

  test('set puts the generated SKU in the field without the user owning it', () {
    sku.set('MIE-P-IG-001');
    expect(field.text, 'MIE-P-IG-001');
    expect(sku.touched, isFalse);
  });

  test('the input echoing the generated text is not the user typing', () {
    sku.set('MIE-P-IG-001');
    expect(sku.typed('MIE-P-IG-001'), isFalse);
    expect(sku.touched, isFalse);
  });

  test('typing something else takes the SKU over', () {
    sku.set('MIE-P-IG-001');
    expect(sku.typed('MANUAL-1'), isTrue);
    expect(sku.touched, isTrue);
  });

  test('clearing the field hands it back, even when the generated text was empty too', () {
    expect(sku.typed('X'), isTrue);
    expect(sku.touched, isTrue);
    sku.set('');
    expect(sku.typed(''), isTrue);
    expect(sku.touched, isFalse);
  });
}

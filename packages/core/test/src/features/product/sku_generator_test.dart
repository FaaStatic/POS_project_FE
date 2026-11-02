import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('categoryCode: first 3 letters or digits, spaces dropped, upper case', () {
    for (final (category, code) in [
      ('Mie Instan', 'MIE'),
      ('Minuman', 'MIN'),
      ('  sembako  ', 'SEM'),
      ('ATK', 'ATK'),
      ('A', 'A'),
      ('Minuman & Snack', 'MIN'),
      ('M i e', 'MIE'),
      ('123 Promo', '123'),
    ]) {
      test('"$category" -> $code', () => expect(SkuGenerator.categoryCode(category), code));
    }

    test('nothing usable gives null', () {
      expect(SkuGenerator.categoryCode(''), isNull);
      expect(SkuGenerator.categoryCode('   '), isNull);
      expect(SkuGenerator.categoryCode('&&&'), isNull);
    });
  });

  group('nameAcronym: initials of the words, first letters of a lone word', () {
    for (final (name, acronym) in [
      ('Indomie Goreng', 'IG'),
      ('Gula Pasir Gulaku 1kg', 'GPG'),
      ('Minyak Goreng Bimoli 2L', 'MGB'),
      ('Beras Rojolele Premium 5kg', 'BRP'),
      ('Telur Ayam Negeri', 'TAN'),
      // A single word has no initials to speak of, so its first three letters stand in.
      ('Aqua 600ml', 'AQU'),
      ('Kopi', 'KOP'),
      ('Go', 'GO'),
      // Sizes and symbols are not words: they are skipped, not turned into initials.
      ('Aqua Botol 600ml (Dus)', 'ABD'),
      ('Teh   Pucuk', 'TP'),
      ('indomie goreng', 'IG'),
    ]) {
      test('"$name" -> $acronym', () => expect(SkuGenerator.nameAcronym(name), acronym));
    }

    test('long names keep the first 6 initials', () {
      expect(SkuGenerator.nameAcronym('Satu Dua Tiga Empat Lima Enam Tujuh Delapan'), 'SDTELE');
    });

    test('a name with no letters falls back to its first characters', () {
      expect(SkuGenerator.nameAcronym('555'), '555');
      expect(SkuGenerator.nameAcronym('1234 ml'), 'ML');
    });

    test('nothing usable gives null', () {
      expect(SkuGenerator.nameAcronym(''), isNull);
      expect(SkuGenerator.nameAcronym(' - '), isNull);
    });
  });

  group('prefix', () {
    test('is category, type letter, and name acronym', () {
      expect(SkuGenerator.prefix(category: 'Mie Instan', type: ProductType.physical, name: 'Indomie Goreng'), 'MIE-P-IG');
      expect(SkuGenerator.prefix(category: 'Pulsa', type: ProductType.digital, name: 'Telkomsel 50rb'), 'PUL-D-TEL');
    });

    test('any missing part means no SKU, like the sheet formula leaving the cell empty', () {
      expect(SkuGenerator.prefix(category: '', type: ProductType.physical, name: 'Indomie'), isNull);
      expect(SkuGenerator.prefix(category: 'Mie', type: ProductType.physical, name: ''), isNull);
      expect(SkuGenerator.prefix(category: ' ', type: ProductType.physical, name: ' '), isNull);
    });
  });

  group('nextNumber continues after the highest taken number for that prefix', () {
    test('starts at 1 when nothing is taken', () => expect(SkuGenerator.nextNumber('MIE-P-IG', const []), 1));

    test('is one past the highest, gaps are not refilled', () {
      expect(SkuGenerator.nextNumber('MIE-P-IG', ['MIE-P-IG-001', 'MIE-P-IG-002']), 3);
      expect(SkuGenerator.nextNumber('MIE-P-IG', ['MIE-P-IG-001', 'MIE-P-IG-007']), 8);
    });

    test('goes past 999 without breaking', () => expect(SkuGenerator.nextNumber('MIE-P-IG', ['MIE-P-IG-999']), 1000));

    test('other prefixes, a longer acronym, and free text do not count', () {
      expect(
        SkuGenerator.nextNumber('MIE-P-IG', ['MIE-P-IGS-004', 'MIE-D-IG-009', 'MIN-P-IG-003', 'MIE-P-IG-ABC', 'MIE-P-IG-', 'IDM-GRG']),
        1,
      );
    });
  });

  test('format pads to three digits', () {
    expect(SkuGenerator.format('MIE-P-IG', 1), 'MIE-P-IG-001');
    expect(SkuGenerator.format('MIE-P-IG', 42), 'MIE-P-IG-042');
    expect(SkuGenerator.format('MIE-P-IG', 1000), 'MIE-P-IG-1000');
  });
}

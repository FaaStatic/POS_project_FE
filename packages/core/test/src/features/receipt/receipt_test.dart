import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

const labels = ReceiptLabels(
  number: 'No.',
  date: 'Tanggal',
  cashier: 'Kasir',
  customer: 'Customer',
  destination: 'Tujuan',
  total: 'TOTAL',
  method: 'Bayar',
  offlineNote: 'Nomor sementara',
  storeNameMissing: 'Nama toko belum diatur',
  markPaid: 'LUNAS',
  markDebt: 'HUTANG',
  markCancelled: 'DIBATALKAN',
  markUnpaid: 'BELUM LUNAS',
  debtPayment: 'PEMBAYARAN HUTANG',
  debtPaidNow: 'Dibayar sekarang',
  debtPrevious: 'Saldo sebelumnya',
  debtOwed: 'Saldo terhutang',
  debtEstimate: '(saldo perkiraan)',
);

void main() {
  setUpAll(() => initializeDateFormatting('id'));

  final sale = Sale(
    clientRef: 'r',
    receiptNumber: 'OFF-ABCD-1',
    createdAt: DateTime(2026, 10, 25, 9, 5),
    method: PaymentMethod.cash,
    customerName: 'Bu Sri',
    cashierName: 'kasir1',
    total: 18500,
    lines: const [
      SaleLine(productId: 'p', name: 'Indomie Goreng Rasa Ayam Bawang Spesial', qty: 2, unitPrice: 3500),
      SaleLine(productId: 'q', name: 'Pulsa 10rb', qty: 1, unitPrice: 11500, destination: '0812'),
    ],
  );

  test('58mm receipt keeps every line within 32 characters', () {
    final doc = ReceiptDocument.fromSale(sale, const ReceiptSettings(), methodLabel: (_) => 'Tunai', labels: labels);
    final text = doc.lines.map((l) => l.text).join('\n');
    expect(text, contains('Nama toko belum diatur'));
    expect(text, contains('Tujuan: 0812'));
    expect(text, contains('Nomor sementara'));
    expect(text, contains('Rp 18.500'));
    for (final line in text.split('\n')) {
      expect(line.length, lessThanOrEqualTo(32), reason: line);
    }
  });

  test('number, date and cashier are listed with their colons aligned, a long value wraps under itself', () {
    final doc = ReceiptDocument.fromSale(
      sale.copyWith(receiptNumber: 'INV-0123456789ABCDEF0123456789ABCDEF'),
      const ReceiptSettings(),
      methodLabel: (_) => 'Tunai',
      labels: labels,
    );
    final text = doc.lines.map((l) => l.text).toList();
    final first = text.indexWhere((l) => l.startsWith('No.'));
    expect(text.sublist(first, first + 5), [
      'No.      : INV-0123456789ABCD',
      '           EF0123456789ABCDEF',
      'Tanggal  : 25 Okt 2026 09.05',
      'Kasir    : kasir1',
      'Customer : Bu Sri',
    ]);
  });

  test('a status mark is centered and bold under the total: paid, on credit, or cancelled', () {
    String markFor(Sale s) => ReceiptDocument.fromSale(s, const ReceiptSettings(), methodLabel: (_) => 'x', labels: labels)
        .lines
        .firstWhere((l) => l.text.startsWith('***'))
        .text;
    final line = ReceiptDocument.fromSale(sale, const ReceiptSettings(), methodLabel: (_) => 'x', labels: labels)
        .lines
        .firstWhere((l) => l.text.startsWith('***'));
    expect(line.align, ReceiptAlign.center);
    expect(line.bold, isTrue);
    expect(markFor(sale), '*** LUNAS ***');
    expect(markFor(sale.copyWith(method: PaymentMethod.debt)), '*** HUTANG ***');
    expect(markFor(sale.copyWith(status: SaleStatus.cancelled)), '*** DIBATALKAN ***');
  });

  test('no line carries a line break, even when a value is wider than the paper', () {
    final doc = ReceiptDocument.fromSale(
      sale.copyWith(total: 99999999999, lines: const [SaleLine(productId: 'p', name: 'Barang', qty: 123456, unitPrice: 99999999)]),
      const ReceiptSettings(),
      methodLabel: (_) => 'Transfer Virtual Account',
      labels: labels,
    );
    expect(doc.lines.where((l) => l.text.contains('\n')), isEmpty);
    for (final line in doc.lines) {
      expect(line.text.length, lessThanOrEqualTo(32), reason: line.text);
    }
  });

  test('80mm receipt uses the store info and footer', () {
    final doc = ReceiptDocument.fromSale(
      sale.copyWith(receiptNumber: 'INV-1'),
      const ReceiptSettings(storeName: 'Toko Maju', storeAddress: 'Jl. Melati 1', footer: 'Terima kasih', paper: PaperWidth.mm80),
      methodLabel: (_) => 'Tunai',
      labels: labels,
    );
    final text = doc.lines.map((l) => l.text).toList();
    expect(text.first, 'Toko Maju');
    expect(text.last, 'Terima kasih');
    expect(text.any((l) => l.contains('Nomor sementara')), isFalse);
    expect(doc.lines.first.bold, isTrue);
  });

  test('settings repository round-trips and emits', () async {
    final repo = ReceiptSettingsRepositoryImpl(MemoryStore());
    final next = repo.watch().skip(1).first;
    await SaveReceiptSettings(repo)(const ReceiptSettings(storeName: ' Toko ', autoPrint: true));
    expect((await next).storeName, 'Toko');
    expect(GetReceiptSettings(repo)().autoPrint, isTrue);
  });

  test('a debt payment slip lists what was paid, what is paid so far and what is still owed', () {
    final payment = sale.copyWith(
      receiptNumber: 'HTG-ABCD-1',
      total: 3000,
      lines: const [],
      kind: SaleKind.debtPayment,
      debtBefore: 5000,
      debtAfter: 2000,
    );
    String text(Sale s) => ReceiptDocument.fromSale(s, const ReceiptSettings(), methodLabel: (_) => 'Tunai', labels: labels)
        .lines
        .map((l) => l.text)
        .join('\n');
    final partly = text(payment);
    expect(partly, contains('PEMBAYARAN HUTANG'));
    expect(partly, contains('Dibayar sekarang'));
    expect(partly, contains('Rp 3.000'));
    expect(partly, matches(RegExp(r'Saldo sebelumnya\s+Rp 5\.000')));
    expect(partly, matches(RegExp(r'Saldo terhutang\s+Rp 2\.000')));
    expect(partly, contains('*** BELUM LUNAS ***'));
    expect(partly, isNot(contains('TOTAL')));
    for (final line in partly.split('\n')) {
      expect(line.length, lessThanOrEqualTo(32), reason: line);
    }

    final settled = text(payment.copyWith(debtBefore: 3000, debtAfter: 0));
    expect(settled, contains('*** LUNAS ***'));
    expect(settled, matches(RegExp(r'Saldo terhutang\s+Rp 0')));
  });

  group('credit sale', () {
    final credit = sale.copyWith(
      receiptNumber: 'INV-9',
      method: PaymentMethod.debt,
      total: 50000,
      debtBefore: 120000,
      debtAfter: 170000,
    );
    String text(Sale s) => ReceiptDocument.fromSale(s, const ReceiptSettings(), methodLabel: (_) => 'Hutang', labels: labels)
        .lines
        .map((l) => l.text)
        .join('\n');

    test('lists the customer balance before and after, between the total and the status mark', () {
      final out = text(credit);
      expect(out, matches(RegExp(r'Saldo sebelumnya\s+Rp 120\.000')));
      expect(out, matches(RegExp(r'Saldo terhutang\s+Rp 170\.000')));
      expect(out.indexOf('TOTAL'), lessThan(out.indexOf('Saldo sebelumnya')));
      expect(out.indexOf('Saldo terhutang'), lessThan(out.indexOf('*** HUTANG ***')));
      expect(out, isNot(contains('perkiraan')));
      for (final line in out.split('\n')) {
        expect(line.length, lessThanOrEqualTo(32), reason: line);
      }
    });

    test('an offline slip marks the balance as an estimate', () {
      expect(text(credit.copyWith(receiptNumber: 'OFF-ABCD-1')), contains('(saldo perkiraan)'));
    });

    test('no balance rows when the balance is unknown, or for a cash sale', () {
      expect(text(credit.copyWith(debtBefore: null, debtAfter: null)), isNot(contains('Saldo')));
      expect(text(sale.copyWith(debtBefore: 1, debtAfter: 2)), isNot(contains('Saldo')));
    });
  });

  test('the rules under the store block and above the footer are double; the others stay single', () {
    final lines = ReceiptDocument.fromSale(
      sale,
      const ReceiptSettings(storeName: 'Toko Maju', footer: 'Terima kasih'),
      methodLabel: (_) => 'Tunai',
      labels: labels,
    ).lines.map((l) => l.text).toList();
    final rules = lines.where((l) => RegExp(r'^[-=]+$').hasMatch(l)).toList();
    expect(rules.first, '=' * 32);
    expect(rules.last, '=' * 32);
    expect(rules.sublist(1, rules.length - 1), everyElement('-' * 32));
    expect(lines[lines.length - 2], '=' * 32);
  });

  test('number, date, cashier and customer rows carry the info role; items and totals do not', () {
    final doc = ReceiptDocument.fromSale(sale, const ReceiptSettings(), methodLabel: (_) => 'Tunai', labels: labels);
    String? roleOf(String start) => doc.lines.where((l) => l.text.startsWith(start)).firstOrNull?.role.name;
    expect(roleOf('No.'), 'info');
    expect(roleOf('Tanggal'), 'info');
    expect(roleOf('Kasir'), 'info');
    expect(roleOf('Customer'), 'info');
    expect(roleOf('TOTAL'), 'body');
  });
}

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
}

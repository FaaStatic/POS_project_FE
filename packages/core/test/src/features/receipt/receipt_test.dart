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

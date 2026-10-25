import '../../../../constants/payment_method.dart';
import '../../../../format/formatters.dart';
import '../../../sales/domain/entities/sale.dart';
import 'receipt_settings.dart';

enum ReceiptAlign { left, center }

class ReceiptLine {
  const ReceiptLine(this.text, {this.align = ReceiptAlign.left, this.bold = false});
  final String text;
  final ReceiptAlign align;
  final bool bold;

  @override
  String toString() => text;
}

/// Plain-text receipt laid out for [ReceiptSettings.paper]; the screen and the
/// thermal printer render the same lines.
class ReceiptDocument {
  ReceiptDocument(this.lines);

  factory ReceiptDocument.fromSale(
    Sale sale,
    ReceiptSettings settings, {
    required String Function(PaymentMethod) methodLabel,
    required ReceiptLabels labels,
    String locale = 'id',
  }) {
    final width = settings.paper.chars;
    final rule = '-' * width;
    final lines = <ReceiptLine>[
      ReceiptLine(settings.storeName.isEmpty ? labels.storeNameMissing : settings.storeName,
          align: ReceiptAlign.center, bold: true),
      if (settings.storeAddress.isNotEmpty)
        for (final part in _wrap(settings.storeAddress, width)) ReceiptLine(part, align: ReceiptAlign.center),
      ReceiptLine(rule),
      ReceiptLine(_pair(labels.number, sale.receiptNumber, width)),
      ReceiptLine(_pair(labels.date, formatDateTime(sale.createdAt, locale: locale), width)),
      ReceiptLine(_pair(labels.cashier, sale.cashierName, width)),
      if (sale.customerName != null) ReceiptLine(_pair(labels.customer, sale.customerName!, width)),
      ReceiptLine(rule),
      for (final item in sale.lines) ...[
        for (final part in _wrap(item.name, width)) ReceiptLine(part),
        if (item.destination != null) ReceiptLine('  ${labels.destination}: ${item.destination}'),
        ReceiptLine(_pair(
          '  ${formatQty(item.qty, locale: locale)} x ${formatRupiah(item.unitPrice, locale: locale)}',
          formatRupiah(item.subtotal, locale: locale),
          width,
        )),
      ],
      ReceiptLine(rule),
      ReceiptLine(_pair(labels.total, formatRupiah(sale.total, locale: locale), width), bold: true),
      ReceiptLine(_pair(labels.method, methodLabel(sale.method), width)),
      if (sale.isOffline) ReceiptLine(labels.offlineNote, align: ReceiptAlign.center),
      if (settings.footer.isNotEmpty) ...[
        ReceiptLine(rule),
        for (final part in _wrap(settings.footer, width)) ReceiptLine(part, align: ReceiptAlign.center),
      ],
    ];
    return ReceiptDocument(lines);
  }

  final List<ReceiptLine> lines;

  static String _pair(String left, String right, int width) {
    final gap = width - left.length - right.length;
    if (gap >= 1) return '$left${' ' * gap}$right';
    return '$left\n${right.padLeft(width)}';
  }

  static List<String> _wrap(String text, int width) {
    final out = <String>[];
    var line = '';
    for (final word in text.split(RegExp(r'\s+'))) {
      if (line.isEmpty) {
        line = word;
      } else if (line.length + 1 + word.length <= width) {
        line = '$line $word';
      } else {
        out.add(line);
        line = word;
      }
      while (line.length > width) {
        out.add(line.substring(0, width));
        line = line.substring(width);
      }
    }
    if (line.isNotEmpty) out.add(line);
    return out;
  }
}

/// Translated labels supplied by the app.
class ReceiptLabels {
  const ReceiptLabels({
    required this.number,
    required this.date,
    required this.cashier,
    required this.customer,
    required this.destination,
    required this.total,
    required this.method,
    required this.offlineNote,
    required this.storeNameMissing,
  });

  final String number;
  final String date;
  final String cashier;
  final String customer;
  final String destination;
  final String total;
  final String method;
  final String offlineNote;
  final String storeNameMissing;
}

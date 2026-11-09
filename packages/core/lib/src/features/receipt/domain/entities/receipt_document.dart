import '../../../../constants/payment_method.dart';
import '../../../../format/formatters.dart';
import '../../../sales/domain/entities/sale.dart';
import 'receipt_settings.dart';

enum ReceiptAlign { left, center }

/// Which part of the slip a line belongs to. The printer ignores it; the on-screen paper sizes
/// the store name, address and footer by it, sets the number/date/cashier rows ([info]) a size smaller, and
/// everything else in the monospace grid.
enum ReceiptRole { store, address, info, body, footer }

class ReceiptLine {
  const ReceiptLine(this.text, {this.align = ReceiptAlign.left, this.bold = false, this.role = ReceiptRole.body});
  final String text;
  final ReceiptAlign align;
  final bool bold;
  final ReceiptRole role;

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
    final doubleRule = '=' * width;
    final lines = <ReceiptLine>[
      ReceiptLine(settings.storeName.isEmpty ? labels.storeNameMissing : settings.storeName,
          align: ReceiptAlign.center, bold: true, role: ReceiptRole.store),
      if (settings.storeAddress.isNotEmpty)
        for (final part in _wrap(settings.storeAddress, width)) ReceiptLine(part, align: ReceiptAlign.center, role: ReceiptRole.address),
      ReceiptLine(doubleRule),
      ..._fields([
        (labels.number, sale.receiptNumber),
        (labels.date, formatDateTime(sale.createdAt, locale: locale)),
        (labels.cashier, sale.cashierName),
        if (sale.customerName != null) (labels.customer, sale.customerName!),
      ], width),
      ReceiptLine(rule),
      if (sale.isDebtPayment) ...[
        ReceiptLine(labels.debtPayment, align: ReceiptAlign.center, bold: true),
        ReceiptLine(rule),
        for (final row in _pair(labels.debtPaidNow, formatRupiah(sale.total, locale: locale), width)) ReceiptLine(row, bold: true),
        for (final row in _pair(labels.debtPrevious, formatRupiah(sale.debtBefore ?? 0, locale: locale), width)) ReceiptLine(row),
        for (final row in _pair(labels.debtOwed, formatRupiah(sale.debtAfter ?? 0, locale: locale), width)) ReceiptLine(row, bold: true),
      ] else ...[
        for (final item in sale.lines) ...[
          for (final part in _wrap(item.name, width)) ReceiptLine(part),
          if (item.destination != null) ReceiptLine('  ${labels.destination}: ${item.destination}'),
          for (final row in _pair(
            '  ${formatQty(item.qty, locale: locale)} x ${formatRupiah(item.unitPrice, locale: locale)}',
            formatRupiah(item.subtotal, locale: locale),
            width,
          ))
            ReceiptLine(row),
        ],
        ReceiptLine(rule),
        for (final row in _pair(labels.total, formatRupiah(sale.total, locale: locale), width)) ReceiptLine(row, bold: true),
        if (sale.method == PaymentMethod.debt && sale.debtBefore != null && sale.debtAfter != null) ...[
          for (final row in _pair(labels.debtPrevious, formatRupiah(sale.debtBefore!, locale: locale), width)) ReceiptLine(row),
          for (final row in _pair(labels.debtOwed, formatRupiah(sale.debtAfter!, locale: locale), width)) ReceiptLine(row, bold: true),
          if (sale.isOffline) ReceiptLine(labels.debtEstimate, align: ReceiptAlign.center),
        ],
      ],
      for (final row in _pair(labels.method, methodLabel(sale.method), width)) ReceiptLine(row),
      ReceiptLine(
        '*** ${sale.status == SaleStatus.cancelled
            ? labels.markCancelled
            : sale.isDebtPayment
            ? (sale.debtSettled ? labels.markPaid : labels.markUnpaid)
            : sale.method == PaymentMethod.debt
            ? labels.markDebt
            : labels.markPaid} ***',
        align: ReceiptAlign.center,
        bold: true,
      ),
      if (sale.isOffline) ReceiptLine(labels.offlineNote, align: ReceiptAlign.center),
      if (settings.footer.isNotEmpty) ...[
        ReceiptLine(doubleRule),
        for (final part in _wrap(settings.footer, width)) ReceiptLine(part, align: ReceiptAlign.center, role: ReceiptRole.footer),
      ],
    ];
    return ReceiptDocument(lines);
  }

  final List<ReceiptLine> lines;

  /// Left text and right-aligned value on one row; when they do not fit, the value drops to its
  /// own row so no line ever carries a line break.
  static List<String> _pair(String left, String right, int width) {
    final gap = width - left.length - right.length;
    if (gap >= 1) return ['$left${' ' * gap}$right'];
    return [left, right.padLeft(width)];
  }

  /// "Label   : value" rows with the colons aligned, the way a till slip lists number, date and
  /// cashier. A value longer than the paper wraps under itself.
  static List<ReceiptLine> _fields(List<(String, String)> rows, int width) {
    final labelWidth = rows.fold(0, (widest, r) => r.$1.length > widest ? r.$1.length : widest);
    final valueWidth = width - labelWidth - 3;
    return [
      for (final (label, value) in rows)
        for (final (i, part) in _fit(value, valueWidth).indexed)
          ReceiptLine(
            '${i == 0 ? label.padRight(labelWidth) : ' ' * labelWidth}${i == 0 ? ' : ' : '   '}$part',
            role: ReceiptRole.info,
          ),
    ];
  }

  /// Words wrap as usual; one long code (an invoice number) is cut into equal rows instead of
  /// being chopped at the paper edge, which would leave a stub on the last row.
  static List<String> _fit(String text, int width) {
    if (text.length <= width || text.contains(' ')) return _wrap(text, width);
    final rows = (text.length / width).ceil();
    final size = (text.length / rows).ceil();
    return [for (var i = 0; i < text.length; i += size) text.substring(i, i + size > text.length ? text.length : i + size)];
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
    required this.markPaid,
    required this.markDebt,
    required this.markCancelled,
    required this.markUnpaid,
    required this.debtPayment,
    required this.debtPaidNow,
    required this.debtPrevious,
    required this.debtOwed,
    required this.debtEstimate,
  });

  /// Centered status mark under the total, printed as "*** LUNAS ***".
  final String markPaid;
  final String markDebt;
  final String markCancelled;
  final String markUnpaid;

  /// Debt payment slip: title and this payment. [debtPrevious] and [debtOwed] are the customer's
  /// total balance before and after, also printed on a credit sale; [debtEstimate] flags a balance
  /// computed offline.
  final String debtPayment;
  final String debtPaidNow;
  final String debtPrevious;
  final String debtOwed;
  final String debtEstimate;

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

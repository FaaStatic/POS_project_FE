import 'package:intl/intl.dart';

/// `Rp 12.500` for id, `Rp 12,500` for en. Rupiah has no minor unit in practice.
String formatRupiah(num amount, {String locale = 'id'}) {
  final digits = NumberFormat.decimalPattern(locale).format(amount.abs().round());
  return '${amount < 0 ? '-' : ''}Rp $digits';
}

/// Quantities may be fractional (kg, liter); trailing zeros are dropped.
String formatQty(num qty, {String locale = 'id'}) => NumberFormat('#,##0.##', locale).format(qty);

String formatDate(DateTime date, {String locale = 'id'}) => DateFormat.yMMMd(locale).format(date.toLocal());

String formatDateTime(DateTime date, {String locale = 'id'}) =>
    DateFormat.yMMMd(locale).add_Hm().format(date.toLocal());

/// Backend query format for date filters.
String apiDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

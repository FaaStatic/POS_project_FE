import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../pump.dart';

void main() {
  testWidgets('shows the range and clears it', (tester) async {
    DateTimeRange? value = DateTimeRange(start: DateTime(2026, 10, 1), end: DateTime(2026, 10, 25));
    await pumpUi(tester, StatefulBuilder(
      builder: (context, setState) => Center(child: DateRangeField(value: value, onChanged: (v) => setState(() => value = v))),
    ));
    expect(find.textContaining('2026'), findsOneWidget);
    await tester.tap(find.byTooltip('Hapus tanggal'));
    await tester.pump();
    expect(find.text('Pilih tanggal'), findsOneWidget);
    await tester.tap(find.text('Pilih tanggal'));
    await tester.pumpAndSettle();
    expect(find.byType(DateRangePickerDialog), findsOneWidget);
  });
}

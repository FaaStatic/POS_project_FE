import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../pump.dart';

void main() {
  testWidgets('password field toggles visibility with a labelled button', (tester) async {
    await pumpUi(tester, const AppTextField(label: 'Kata sandi', password: true));
    EditableText editable() => tester.widget<EditableText>(find.byType(EditableText));
    expect(editable().obscureText, isTrue);
    await tester.tap(find.byTooltip('Tampilkan kata sandi'));
    await tester.pump();
    expect(editable().obscureText, isFalse);
    expect(find.byTooltip('Sembunyikan kata sandi'), findsOneWidget);
  });

  testWidgets('shows validator error', (tester) async {
    final key = GlobalKey<FormState>();
    await pumpUi(
      tester,
      Form(key: key, child: AppTextField(label: 'Username', validator: (v) => v!.isEmpty ? 'Wajib diisi' : null)),
    );
    key.currentState!.validate();
    await tester.pump();
    expect(find.text('Wajib diisi'), findsOneWidget);
  });

  testWidgets('renders at 200% text in dark theme', (tester) async {
    await pumpUi(
      tester,
      const Padding(padding: EdgeInsets.all(16), child: AppTextField(label: 'Nama produk', helper: 'Contoh: Indomie Goreng')),
      dark: true,
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
  });
}

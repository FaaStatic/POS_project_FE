import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../pump.dart';

void main() {
  testWidgets('empty state shows message and single action', (tester) async {
    var taps = 0;
    await pumpUi(
      tester,
      EmptyState(message: 'Belum ada produk.', actionLabel: 'Tambah produk pertama', onAction: () => taps++),
    );
    await tester.tap(find.text('Tambah produk pertama'));
    expect(taps, 1);
  });

  testWidgets('error state offers retry', (tester) async {
    var retries = 0;
    await pumpUi(tester, ErrorState(message: 'Gagal memuat produk.', onRetry: () => retries++));
    await tester.tap(find.text('Coba lagi'));
    expect(retries, 1);
  });

  testWidgets('state views survive 200% text in dark theme', (tester) async {
    await pumpUi(
      tester,
      ErrorState(message: 'Gagal memuat transaksi karena koneksi terputus.', onRetry: () {}),
      dark: true,
      textScale: 2,
      size: const Size(320, 640),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('loading view has an accessible label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpUi(tester, const LoadingView());
    expect(find.bySemanticsLabel('Memuat'), findsOneWidget);
    handle.dispose();
  });
}

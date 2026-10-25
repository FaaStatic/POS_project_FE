import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../pump.dart';

void main() {
  for (final tone in BadgeTone.values) {
    testWidgets('$tone badge renders in both themes at 200%', (tester) async {
      for (final dark in [false, true]) {
        await pumpUi(tester, Center(child: StatusBadge(label: 'Konflik stok', tone: tone)), dark: dark, textScale: 2);
        expect(tester.takeException(), isNull);
      }
    });
  }

  testWidgets('offline banner hides when online and nothing pending', (tester) async {
    await pumpUi(tester, const OfflineBanner(offline: false, pendingCount: 0));
    expect(find.byType(Material), findsWidgets);
    expect(find.text('Tidak ada koneksi internet'), findsNothing);
  });

  testWidgets('offline banner shows count and sync action', (tester) async {
    var syncs = 0;
    await pumpUi(
      tester,
      OfflineBanner(offline: true, pendingCount: 3, syncLabel: 'Sync sekarang', onSync: () => syncs++),
    );
    expect(find.text('Tidak ada koneksi internet · 3 transaksi belum terkirim'), findsOneWidget);
    await tester.tap(find.text('Sync sekarang'));
    expect(syncs, 1);
  });

  testWidgets('theme exposes status colors', (tester) async {
    late StatusColors colors;
    await pumpUi(tester, Builder(builder: (context) {
      colors = StatusColors.of(context);
      return const SizedBox();
    }), dark: true);
    expect(colors.success, BrandColors.greenDark);
  });
}

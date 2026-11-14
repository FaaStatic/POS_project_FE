import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/features/settings/presentation/pages/settings_page.dart';
import 'package:kasir/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> _pump(WidgetTester tester, {String locale = 'id'}) => tester.pumpWidget(
      MaterialApp(
        locale: Locale(locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: Center(child: AppVersionLabel())),
      ),
    );

void main() {
  // The platform result is cached for the isolate, so the "no answer" case runs before any mock is set.
  testWidgets('shows nothing when the platform cannot report the build', (tester) async {
    await _pump(tester);
    await tester.pumpAndSettle();
    expect(find.textContaining('Versi'), findsNothing);
  });

  testWidgets('shows the version and build number in the app language', (tester) async {
    PackageInfo.setMockInitialValues(
      appName: 'myKasir',
      packageName: 'com.suhaili.cashier',
      version: '1.4.2',
      buildNumber: '37',
      buildSignature: '',
    );
    await _pump(tester);
    await tester.pumpAndSettle();
    expect(find.text('Versi 1.4.2 (37)'), findsOneWidget);

    await _pump(tester, locale: 'en');
    await tester.pumpAndSettle();
    expect(find.text('Version 1.4.2 (37)'), findsOneWidget);
  });
}

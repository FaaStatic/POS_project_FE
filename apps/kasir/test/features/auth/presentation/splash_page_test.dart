import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasir/features/auth/presentation/pages/splash_page.dart';
import 'package:ui/ui.dart';

void main() {
  Future<double> scaleAfter(WidgetTester tester, Duration elapsed, {bool reduceMotion = false}) async {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(disableAnimations: reduceMotion),
        child: const MaterialApp(localizationsDelegates: UiLocalizations.localizationsDelegates, home: SplashPage()),
      ),
    );
    await tester.pump(elapsed);
    return tester.widget<ScaleTransition>(find.ancestor(of: find.byType(Hero), matching: find.byType(ScaleTransition))).scale.value;
  }

  testWidgets('logo pulses while loading and sits on the hero tag', (tester) async {
    final start = await scaleAfter(tester, Duration.zero);
    final later = await scaleAfter(tester, const Duration(milliseconds: 450));
    expect(later, isNot(closeTo(start, 0.01)));
    expect(tester.widget<Hero>(find.byType(Hero)).tag, brandHeroTag);
  });

  testWidgets('reduced motion keeps the logo still', (tester) async {
    final start = await scaleAfter(tester, Duration.zero, reduceMotion: true);
    final later = await scaleAfter(tester, const Duration(milliseconds: 450), reduceMotion: true);
    expect(later, start);
  });
}

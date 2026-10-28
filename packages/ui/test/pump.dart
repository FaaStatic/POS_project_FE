import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

/// Pumps [child] inside a themed, localized app with an optional text scale.
Future<void> pumpUi(
  WidgetTester tester,
  Widget child, {
  bool dark = false,
  double textScale = 1,
  Size size = const Size(400, 800),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final mode = dark ? ThemeMode.dark : ThemeMode.light;
  await tester.pumpWidget(
    ShadApp.custom(
      theme: AppTheme.touch.shadLight,
      darkTheme: AppTheme.touch.shadDark,
      themeMode: mode,
      appBuilder: (context) => MaterialApp(
        theme: AppTheme.touch.light,
        darkTheme: AppTheme.touch.dark,
        themeMode: mode,
        locale: const Locale('id'),
        supportedLocales: UiLocalizations.supportedLocales,
        localizationsDelegates: const [
          UiLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) => ShadAppBuilder(child: child),
        home: MediaQuery.withClampedTextScaling(
          minScaleFactor: textScale,
          maxScaleFactor: textScale,
          child: Scaffold(body: child),
        ),
      ),
    ),
  );
}

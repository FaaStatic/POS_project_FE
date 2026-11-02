import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../pump.dart';

const _categories = ['Minuman', 'Mie Instan', 'Sembako', 'Snack'];

class _Host extends StatefulWidget {
  const _Host({this.createLabel, this.options = _categories});
  final String Function(String text)? createLabel;
  final List<String> options;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppAutocomplete(
        label: 'Kategori',
        hint: 'Pilih kategori',
        controller: controller,
        options: widget.options,
        createLabel: widget.createLabel,
      );
}

Finder get _field => find.byType(EditableText);

void main() {
  testWidgets('focusing an empty field lists every option', (tester) async {
    await pumpUi(tester, const _Host());
    await tester.tap(_field);
    await tester.pumpAndSettle();
    for (final c in _categories) {
      expect(find.text(c), findsOneWidget);
    }
  });

  testWidgets('typing narrows the list, ignoring case', (tester) async {
    await pumpUi(tester, const _Host());
    await tester.tap(_field);
    await tester.enterText(_field, 'MI');
    await tester.pumpAndSettle();
    expect(find.text('Minuman'), findsOneWidget);
    expect(find.text('Mie Instan'), findsOneWidget);
    expect(find.text('Sembako'), findsNothing);
    expect(find.text('Snack'), findsNothing);
  });

  testWidgets('choosing an option fills the field', (tester) async {
    await pumpUi(tester, const _Host());
    await tester.tap(_field);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sembako'));
    await tester.pumpAndSettle();

    expect(tester.widget<EditableText>(_field).controller.text, 'Sembako');
    expect(find.text('Snack'), findsNothing, reason: 'the list closes');
  });

  testWidgets('arrow keys and Enter choose without the mouse', (tester) async {
    await pumpUi(tester, const _Host());
    await tester.tap(_field);
    await tester.pumpAndSettle();
    // The first option starts highlighted, so one step down is the second.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    // Enter in a text field arrives as the keyboard's "done" action, not as a key event.
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(tester.widget<EditableText>(_field).controller.text, 'Mie Instan');
  });

  group('creating a new value', () {
    testWidgets('is not offered when the field only takes existing values', (tester) async {
      await pumpUi(tester, const _Host());
      await tester.tap(_field);
      await tester.enterText(_field, 'Frozen');
      await tester.pumpAndSettle();
      expect(find.textContaining('Frozen'), findsOneWidget, reason: 'only what was typed, no option row');
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('is offered as its own row when allowed, and keeps the typed text', (tester) async {
      await pumpUi(tester, _Host(createLabel: (t) => 'Buat "$t"'));
      await tester.tap(_field);
      await tester.enterText(_field, 'Frozen');
      await tester.pumpAndSettle();
      expect(find.text('Buat "Frozen"'), findsOneWidget);

      await tester.tap(find.text('Buat "Frozen"'));
      await tester.pumpAndSettle();
      expect(tester.widget<EditableText>(_field).controller.text, 'Frozen');
    });

    testWidgets('is not offered for text that already matches an option', (tester) async {
      await pumpUi(tester, _Host(createLabel: (t) => 'Buat "$t"'));
      await tester.tap(_field);
      await tester.enterText(_field, 'snack');
      await tester.pumpAndSettle();
      expect(find.textContaining('Buat'), findsNothing);
      expect(find.text('Snack'), findsOneWidget);
    });
  });

  testWidgets('the arrow opens the list and a second tap closes it', (tester) async {
    await pumpUi(tester, const _Host());
    await tester.tap(find.byTooltip('Tampilkan pilihan'));
    await tester.pumpAndSettle();
    expect(find.text('Snack'), findsOneWidget);

    await tester.tap(find.byTooltip('Tampilkan pilihan'));
    await tester.pumpAndSettle();
    expect(find.text('Snack'), findsNothing);
  });

  testWidgets('a long list scrolls inside a capped panel', (tester) async {
    final many = [for (var i = 1; i <= 60; i++) 'Kategori $i'];
    await pumpUi(tester, _Host(options: many), size: const Size(400, 800));
    await tester.tap(_field);
    await tester.pumpAndSettle();
    expect(find.text('Kategori 1'), findsOneWidget);
    expect(find.text('Kategori 60'), findsNothing, reason: 'built lazily, not all at once');
    expect(tester.takeException(), isNull);
  });

  for (final dark in [false, true]) {
    testWidgets('fits a phone at 200% text (dark: $dark)', (tester) async {
      await pumpUi(tester, _Host(createLabel: (t) => 'Buat "$t"'), size: const Size(360, 800), textScale: 2, dark: dark);
      await tester.tap(_field);
      await tester.enterText(_field, 'Frozen');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}

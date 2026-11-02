import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import '../pump.dart';

/// A real 64x64 lossy WebP from cwebp (a gradient), so the preview decodes in a widget test.
final _webp = base64Decode(
  'UklGRvIAAABXRUJQVlA4IOYAAADQCACdASpAAEAAPrVYo0w/sqMiLB1YA/AWiWIzgX//WDE8sJnBreoNEox3ve7+5jV8cMxfTNaTZyWbtfk8p7aAcAsRP/9hIR2PExdH/6QAAP76Ff0f86ftP+q3kuqg/MIxGa5mS9jastmdbk+xYAcFFVOYFBMRkaWko3SvRPBbgoMsN/yGPArIR2CWfpFWN6TSIKBTelzHsMJNk/gXHwFIylib5cAQluRvIeDX9+SX/LzndUiOXnQSEFNYyuzQQOWSh/XavLZkBMeyL+LG/lEDwlYhJogaiX63E1FuI74GpB1gxKAAAA==',
);

const _hint = 'WebP, rasio 1:1, maks 500 KB';

class _Host extends StatefulWidget {
  const _Host({required this.pick, this.validate, this.initial = '', this.changes});
  final Future<PickedImage?> Function() pick;
  final String? Function(Uint8List bytes)? validate;
  final String initial;
  final List<String>? changes;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late String value = widget.initial;

  @override
  Widget build(BuildContext context) => ImageUploadField(
        label: 'Gambar produk',
        hint: _hint,
        value: value,
        pick: widget.pick,
        validate: widget.validate ?? (_) => null,
        onChanged: (v) {
          widget.changes?.add(v);
          setState(() => value = v);
        },
      );
}

PickedImage _file([String name = 'indomie.webp']) => (name: name, bytes: _webp);

void main() {
  testWidgets('empty: hint, a pick button, and nothing to remove', (tester) async {
    await pumpUi(tester, _Host(pick: () async => null));
    expect(find.text('Gambar produk'), findsOneWidget);
    expect(find.text(_hint), findsOneWidget);
    expect(find.text('Pilih gambar'), findsOneWidget);
    expect(find.text('Hapus gambar'), findsNothing);
  });

  testWidgets('a valid file is reported as raw base64 with a preview and new actions', (tester) async {
    final changes = <String>[];
    await pumpUi(tester, _Host(pick: () async => _file(), changes: changes));
    await tester.tap(find.text('Pilih gambar'));
    await tester.pumpAndSettle();

    expect(changes, [base64Encode(_webp)]);
    expect(changes.single, isNot(contains('data:')));
    expect(find.text('indomie.webp'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Ganti gambar'), findsOneWidget);
    expect(find.text('Hapus gambar'), findsOneWidget);
  });

  testWidgets('a rejected file shows the message and changes nothing', (tester) async {
    final changes = <String>[];
    await pumpUi(
      tester,
      _Host(
        pick: () async => _file('foto.png'),
        validate: (_) => 'Gambar harus berformat WebP.',
        changes: changes,
      ),
    );
    await tester.tap(find.text('Pilih gambar'));
    await tester.pumpAndSettle();

    expect(find.text('Gambar harus berformat WebP.'), findsOneWidget);
    expect(changes, isEmpty);
    expect(find.text('foto.png'), findsNothing);
    expect(find.text('Hapus gambar'), findsNothing);
  });

  testWidgets('the error clears once a valid file is chosen', (tester) async {
    var first = true;
    await pumpUi(
      tester,
      _Host(
        pick: () async => _file(),
        // The first pick is rejected, the second accepted.
        validate: (_) => first ? 'Ukuran gambar maksimal 500 KB.' : null,
      ),
    );
    await tester.tap(find.text('Pilih gambar'));
    await tester.pumpAndSettle();
    expect(find.text('Ukuran gambar maksimal 500 KB.'), findsOneWidget);

    first = false;
    await tester.tap(find.text('Pilih gambar'));
    await tester.pumpAndSettle();
    expect(find.text('Ukuran gambar maksimal 500 KB.'), findsNothing);
    expect(find.text('Ganti gambar'), findsOneWidget);
  });

  testWidgets('cancelling the dialog changes nothing', (tester) async {
    final changes = <String>[];
    await pumpUi(tester, _Host(pick: () async => null, changes: changes));
    await tester.tap(find.text('Pilih gambar'));
    await tester.pumpAndSettle();
    expect(changes, isEmpty);
    expect(find.text('Pilih gambar'), findsOneWidget);
  });

  testWidgets('removing reports an empty string and returns to the empty state', (tester) async {
    final changes = <String>[];
    await pumpUi(tester, _Host(pick: () async => null, initial: base64Encode(_webp), changes: changes));
    expect(find.text('Ganti gambar'), findsOneWidget);
    await tester.tap(find.text('Hapus gambar'));
    await tester.pumpAndSettle();
    expect(changes, ['']);
    expect(find.text('Pilih gambar'), findsOneWidget);
  });

  testWidgets('an existing stored value is previewed before any pick', (tester) async {
    await pumpUi(tester, _Host(pick: () async => null, initial: base64Encode(_webp)));
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Hapus gambar'), findsOneWidget);
  });

  testWidgets('a stored URL that will not load still lays out', (tester) async {
    await pumpUi(tester, _Host(pick: () async => null, initial: 'https://cdn.example.com/a.png'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Ganti gambar'), findsOneWidget);
  });

  for (final dark in [false, true]) {
    testWidgets('survives 200% text on a phone (dark: $dark)', (tester) async {
      await pumpUi(
        tester,
        _Host(pick: () async => _file(), validate: (_) => 'Gambar harus persegi, rasio 1:1.'),
        size: const Size(360, 800),
        textScale: 2,
        dark: dark,
      );
      await tester.tap(find.text('Pilih gambar'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}

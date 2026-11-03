import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// On-screen copy of the printed receipt: a sheet of paper. The store name, address and footer
/// are centered paragraphs sized from the app's type scale (h1, b1, 18sp); everything between
/// them sits in a monospace cell grid exactly as wide as the thermal paper (32 or 48
/// characters), 14sp, so the columns line up like the printed slip.
class ReceiptView extends StatelessWidget {
  const ReceiptView({super.key, required this.document});

  final ReceiptDocument document;

  // Paper stays light in both themes; ink on it is 15:1.
  static const _paper = Colors.white;
  static const _ink = Neutral.foreground;

  /// Footer size, between the 16sp address and the 28sp store name.
  static const _footerSize = 18.0;

  /// Opacity of the logo behind the text.
  static const _watermark = 0.07;

  /// Info, items and totals.
  static const _bodySize = 14.0;

  /// No monospace family exists on every platform, so name each platform's own.
  static const _mono = TextStyle(
    fontFamily: 'monospace',
    fontFamilyFallback: ['Menlo', 'Roboto Mono', 'Courier New', 'Courier'],
    fontSize: _bodySize,
    height: 1.4,
    color: _ink,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The same touch scale the rest of the kasir uses: h1 = headlineMedium, b1 = bodyLarge.
    final h1 = theme.textTheme.headlineMedium!.copyWith(color: _ink, fontWeight: FontWeight.w700);
    final b1 = theme.textTheme.bodyLarge!.copyWith(color: _ink);
    final footer = theme.textTheme.bodyLarge!.copyWith(color: _ink, fontSize: _footerSize, height: 1.4);
    final columns = document.lines.fold(0, (widest, l) => l.text.length > widest ? l.text.length : widest);

    Widget paragraph(ReceiptRole role, String text) => Padding(
      padding: switch (role) {
        ReceiptRole.store => const EdgeInsets.only(bottom: Space.xs),
        ReceiptRole.address => const EdgeInsets.only(bottom: Space.md),
        ReceiptRole.footer => const EdgeInsets.only(top: Space.sm),
        ReceiptRole.body => EdgeInsets.zero,
      },
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: switch (role) {
          ReceiptRole.store => h1,
          ReceiptRole.address => b1,
          ReceiptRole.footer => footer,
          ReceiptRole.body => _mono,
        },
      ),
    );

    final children = <Widget>[];
    for (var i = 0; i < document.lines.length;) {
      final line = document.lines[i];
      if (line.role == ReceiptRole.body) {
        children.add(
          Text(
            line.text,
            textAlign: line.align == ReceiptAlign.center ? TextAlign.center : TextAlign.start,
            style: line.bold ? _mono.copyWith(fontWeight: FontWeight.w700) : _mono,
            softWrap: false,
          ),
        );
        i++;
        continue;
      }
      // The document wrapped these at the paper's character width; at a larger size they flow again.
      final parts = <String>[];
      while (i < document.lines.length && document.lines[i].role == line.role) {
        parts.add(document.lines[i].text);
        i++;
      }
      children.add(paragraph(line.role, parts.join(' ')));
    }

    // The receipt is a picture of paper: it keeps its own size, and FittedBox only shrinks it to fit.
    return MediaQuery.withNoTextScaling(
      child: Semantics(
        container: true,
        label: document.lines.map((l) => l.text).join('\n'),
        child: ExcludeSemantics(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _paper,
              borderRadius: BorderRadius.circular(Radii.medium),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Stack(
              children: [
                // The app logo as a watermark: faint enough that the ink keeps its full contrast.
                const Positioned.fill(child: Center(child: Opacity(opacity: _watermark, child: BrandLogo.mark(height: 180)))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.xl),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: _cell * columns,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Width of one character cell in [_mono], measured once; a monospace font gives the same for every glyph.
  static final _cell = (TextPainter(
    text: const TextSpan(text: '0000000000', style: _mono),
    textDirection: TextDirection.ltr,
  )..layout()).width / 10;
}

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// On-screen copy of the printed receipt: a sheet of paper. The store name, address and footer
/// are centered paragraphs (h1 for the name, 8sp for the address, 18sp for the footer); everything between
/// them sits in a monospace cell grid exactly as wide as the thermal paper (32 or 48
/// characters), 14sp, so the columns line up like the printed slip.
class ReceiptView extends StatelessWidget {
  const ReceiptView({super.key, required this.document, this.fill = false});

  final ReceiptDocument document;

  /// Scales the slip up to the width it is given instead of keeping its phone size. For tablets, where the
  /// natural size would sit as a small paper in a wide empty page; the slip keeps its proportions.
  final bool fill;

  // Paper stays light in both themes; ink on it is 15:1.
  static const _paper = Colors.white;
  static const _ink = Neutral.foreground;

  /// Footer size, between the 8sp address and the 28sp store name.
  static const _footerSize = 12.0;

  /// The store address is small print under the name.
  static const _addressSize = 8.0;

  /// Logo above the store name.
  static const _logoHeight = 48.0;

  /// Opacity of the logo behind the text.
  static const _watermark = 0.07;

  /// Items and totals.
  static const _bodySize = 15.0;

  /// Number, date, cashier and customer rows.
  static const _infoSize = 12.0;

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
    // The same touch scale the rest of the kasir uses: h1 = headlineMedium.
    final h1 = theme.textTheme.headlineMedium!.copyWith(
      color: _ink,
      fontWeight: FontWeight.w700,
    );
    final address = theme.textTheme.bodyLarge!.copyWith(
      color: _ink,
      fontSize: _addressSize,
      height: 1.4,
    );
    final footer = theme.textTheme.bodyLarge!.copyWith(
      color: _ink,
      fontSize: _footerSize,
      height: 1.4,
    );
    final columns = document.lines.fold(
      0,
      (widest, l) => l.text.length > widest ? l.text.length : widest,
    );

    Widget paragraph(ReceiptRole role, String text) => Padding(
      padding: switch (role) {
        ReceiptRole.store => const EdgeInsets.only(bottom: Space.xs),
        ReceiptRole.address => const EdgeInsets.only(bottom: Space.md),
        ReceiptRole.footer => const EdgeInsets.only(top: Space.sm),
        ReceiptRole.body || ReceiptRole.info => EdgeInsets.zero,
      },
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: switch (role) {
          ReceiptRole.store => h1,
          ReceiptRole.address => address,
          ReceiptRole.footer => footer,
          ReceiptRole.body || ReceiptRole.info => _mono,
        },
      ),
    );

    final children = <Widget>[
      // Screen only: the thermal slip gets the same mark as a raster (see esc_pos.dart).
      const Padding(
        padding: EdgeInsets.only(bottom: Space.sm),
        child: Center(child: BrandLogo.mark(height: _logoHeight)),
      ),
    ];
    for (var i = 0; i < document.lines.length;) {
      final line = document.lines[i];
      if (line.role == ReceiptRole.body || line.role == ReceiptRole.info) {
        if (_isRule(line.text)) {
          children.add(
            CustomPaint(
              painter: _DashPainter(_ink, twin: line.text.startsWith('=')),
              size: const Size.fromHeight(_bodySize * 1.4),
            ),
          );
          i++;
          continue;
        }
        children.add(
          Text(
            line.text,
            textAlign: line.align == ReceiptAlign.center
                ? TextAlign.center
                : TextAlign.start,
            style: _lineStyle(line),
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
                const Positioned.fill(
                  child: Center(
                    child: Opacity(
                      opacity: _watermark,
                      child: BrandLogo.mark(height: 180),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Space.lg,
                    vertical: Space.xl,
                  ),
                  child: LayoutBuilder(
                    builder: (context, box) {
                      final slip = FittedBox(
                        fit: fill ? BoxFit.contain : BoxFit.scaleDown,
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: _cell * columns,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: children,
                          ),
                        ),
                      );
                      // FittedBox only grows into a tight width.
                      return fill && box.maxWidth.isFinite
                          ? SizedBox(width: box.maxWidth, child: slip)
                          : slip;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// A row made only of hyphens (single) or equals signs (double) is a separator; the printer keeps it as text.
  static bool _isRule(String text) => RegExp(r'^(-{3,}|={3,})$').hasMatch(text);

  static TextStyle _lineStyle(ReceiptLine line) {
    // Same family and left edge as the grid, so only the size changes; the rows are left-aligned text.
    final base = line.role == ReceiptRole.info ? _mono.copyWith(fontSize: _infoSize) : _mono;
    return line.bold ? base.copyWith(fontWeight: FontWeight.w700) : base;
  }

  /// Width of one character cell in [_mono], measured once; a monospace font gives the same for every glyph.
  static final _cell =
      (TextPainter(
        text: const TextSpan(text: '0000000000', style: _mono),
        textDirection: TextDirection.ltr,
      )..layout()).width /
      10;
}

/// Separator drawn edge to edge of the cell grid, the way an Indomaret or Alfamart slip rules off
/// its sections. The first dash starts on the left edge and the last ends on the right edge; the
/// gaps stretch to fit, so the line lines up with the left-aligned text and the right-aligned prices
/// whatever monospace font the platform picked.
class _DashPainter extends CustomPainter {
  const _DashPainter(this.color, {this.twin = false});
  final Color color;

  /// Two parallel dashed lines, for the rules under the store block and above the footer.
  final bool twin;

  static const _dash = 5.0;
  static const _minGap = 3.0;
  static const _stroke = 1.2;
  static const _pairGap = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final count = ((size.width + _minGap) / (_dash + _minGap)).floor();
    if (count < 2) return;
    final gap = (size.width - count * _dash) / (count - 1);
    final y = size.height / 2;
    final paint = Paint()
      ..color = color
      ..strokeWidth = _stroke;
    final offsets = twin ? const [-_pairGap / 2, _pairGap / 2] : const [0.0];
    for (var i = 0; i < count; i++) {
      final x = i * (_dash + gap);
      for (final dy in offsets) {
        canvas.drawLine(Offset(x, y + dy), Offset(x + _dash, y + dy), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) => old.color != color || old.twin != twin;
}
